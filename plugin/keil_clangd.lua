-- Keil uVision -> clangd
--
-- 打开 C 文件时，如果找不到 compile_commands.json，就在工程里找最近的
-- .uvprojx 并自动生成编译数据库。装一次，所有 Keil 工程通用。
--
-- 生成器：<config>/keil/uvprojx2cdb.py（来自 UPS_NS6024/tools/gen_compile_commands.py）
-- 手动重新生成：:KeilDb

local generator = vim.fs.joinpath(vim.fn.stdpath('config'), 'keil', 'uvprojx2cdb.py')

-- 每个工程本会话只尝试一次，避免反复调用
local attempted = {}

local function notify(msg, level)
  vim.notify('[keil] ' .. msg, level or vim.log.levels.INFO)
end

local function python_cmd()
  local exe = vim.fn.exepath('python')
  -- Windows 应用商店的 python.exe 是个占位符，不能用
  if exe == '' or exe:lower():find('windowsapps', 1, true) then
    return 'py'
  end
  return exe
end

local function find_up(name, dir)
  return vim.fs.find(name, { path = dir, upward = true })[1]
end

-- 向下有限深度查找 .uvprojx，带访问上限避免在大目录里扫太久
local function find_down(root, max_depth)
  local level = { root }
  local visited = 0
  for _ = 1, max_depth do
    local next_level = {}
    for _, d in ipairs(level) do
      visited = visited + 1
      if visited > 500 then
        return nil
      end
      for name, typ in vim.fs.dir(d, { depth = 1 }) do
        if typ == 'file' and name:lower():match('%.uvprojx$') then
          return vim.fs.joinpath(d, name)
        elseif typ == 'directory'
          and name ~= '.git'
          and name ~= 'node_modules'
          and name ~= '.venv'
          and name ~= 'AppData'
        then
          next_level[#next_level + 1] = vim.fs.joinpath(d, name)
        end
      end
    end
    level = next_level
    if #level == 0 then
      break
    end
  end
  return nil
end

local function find_project(dir)
  local up = vim.fs.find(function(name)
    return name:lower():match('%.uvprojx$') ~= nil
  end, { path = dir, upward = true, type = 'file' })[1]
  if up then
    return up
  end

  -- 有些工程把 .uvprojx 放在子目录（如 MDK/、Keil5_project/），
  -- 而且是从文件的兄弟目录下去找，所以先定位工程根（含 .git 的目录）
  local roots = {}
  local d = dir
  for _ = 1, 5 do
    if vim.fn.isdirectory(vim.fs.joinpath(d, '.git')) == 1 then
      roots[#roots + 1] = d
      break
    end
    roots[#roots + 1] = d
    local parent = vim.fs.dirname(d)
    if parent == d then
      break
    end
    d = parent
  end

  for _, root in ipairs(roots) do
    local hit = find_down(root, 3)
    if hit then
      return hit
    end
  end
  return nil
end

--- 生成编译数据库，返回生成的文件路径或 nil
local function generate(project, target)
  if vim.fn.filereadable(generator) == 0 then
    notify('找不到生成器: ' .. generator, vim.log.levels.ERROR)
    return nil
  end

  local cmd = { python_cmd(), generator, '-p', project }
  if target and target ~= '' then
    vim.list_extend(cmd, { '-t', target })
  end
  local res = vim.system(cmd, { text = true }):wait(30000)
  if res.code ~= 0 then
    notify('生成失败: ' .. vim.trim(res.stderr or '未知错误'), vim.log.levels.ERROR)
    return nil
  end

  local out = res.stdout or ''
  local path = out:match('output:%s*[^\r\n]-([A-Za-z]:[^\r\n]-%.json)')
  local count = out:match('%((%d+) files%)')
  notify(('已生成 %s（%s 个文件）'):format(path and vim.fn.fnamemodify(path, ':t') or 'compile_commands.json',
    count or '?'))

  -- clangd 可能已经用旧配置启动过，重启用新的数据库
  if #vim.lsp.get_clients({ name = 'clangd' }) > 0 then
    pcall(vim.cmd, 'LspRestart clangd')
  end
  return path
end

local function ensure_db(buf)
  local file = vim.api.nvim_buf_get_name(buf)
  if file == '' then
    return
  end

  local dir = vim.fs.dirname(file)
  if find_up('compile_commands.json', dir) then
    return
  end

  local project = find_project(dir)
  if not project then
    return
  end

  local key = vim.fs.dirname(project)
  if attempted[key] then
    return
  end
  attempted[key] = true

  -- BufReadPre 阶段同步生成，保证 clangd 启动时数据库已存在
  generate(project)
end

vim.api.nvim_create_autocmd('BufReadPre', {
  pattern = { '*.c', '*.h', '*.cpp', '*.hpp', '*.cc' },
  callback = function(args)
    ensure_db(args.buf)
  end,
  desc = 'generate compile_commands.json for Keil projects',
})

vim.api.nvim_create_user_command('KeilDb', function(opts)
  local arg = vim.trim(opts.args or '')
  local project, target

  if arg == '' then
    project = find_project(vim.fn.expand('%:p:h'))
  elseif vim.fn.isdirectory(arg) == 1 or arg:lower():match('%.uvprojx$') then
    project = arg
  else
    -- 纯名字当作 Keil target（例如 UPS_HW110）
    project = find_project(vim.fn.expand('%:p:h'))
    target = arg
  end

  if not project then
    notify('当前目录向上找不到 .uvprojx，可用 :KeilDb <工程路径> [target]', vim.log.levels.ERROR)
    return
  end
  attempted[vim.fs.dirname(vim.fn.fnamemodify(project, ':p'))] = true
  generate(project, target)
end, { nargs = '?', desc = 'regenerate compile_commands.json for the current Keil project' })
