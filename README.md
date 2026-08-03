# 🚀 Neovim 配置 - Mini 生态完整版

> 基于 mini.nvim 生态的现代化 Neovim 开发环境

[![Neovim](https://img.shields.io/badge/Neovim-0.9+-57A143?style=flat&logo=neovim&logoColor=white)](https://neovim.io/)
[![Lua](https://img.shields.io/badge/Lua-5.1-2C2D72?style=flat&logo=lua&logoColor=white)](https://www.lua.org/)
[![mini.nvim](https://img.shields.io/badge/mini.nvim-生态-4B8BBE?style=flat)](https://github.com/echasnovski/mini.nvim)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## 📋 目录

- [✨ 特性](#-特性)
- [📦 插件列表](#-插件列表)
- [🚀 快速开始](#-快速开始)
- [📂 项目结构](#-项目结构)
- [⚙️ 配置详解](#️-配置详解)
- [⌨️ 快捷键映射](#️-快捷键映射)
- [🔧 LSP 支持](#-lsp-支持)
- [📝 任务管理](#-任务管理)
- [🎨 主题与界面](#-主题与界面)
- [🤖 AI 辅助](#-ai-辅助)
- [🔩 自定义配置](#-自定义配置)
- [📄 许可证](#-许可证)

---

## ✨ 特性

- **⚡ 极致性能**：Lua 编写，启动速度快，资源占用低
- **🎯 完整 Mini 生态**：集成 15+ mini.nvim 插件
- **🔍 智能补全**：mini.completion + mini.snippets
- **📁 高效文件管理**：mini.pick 基于 ripgrep 的快速搜索
- **📊 现代化界面**：Alucard 主题 + mini.statusline + mini.tabline
- **🔧 LSP 支持**：7+ 语言服务器（Clangd, LuaLS, PyLSP 等）
- **📋 异步任务系统**：AsyncRun + AsyncTasks 支持
- **🌳 语法高亮**：Treesitter + Treesitter Context
- **🔐 Git 集成**：mini.diff 显示差异
- **🤖 AI 辅助**：windsurf.vim (Codeium) 智能补全
- **📢 通知系统**：mini.notify 优雅通知
- **🎨 平滑动画**：mini.animate 视觉增强

---

## 📦 插件列表

### Mini.nvim 生态 (15个)

| 插件 | 描述 | 加载方式 |
|------|------|----------|
| [mini.animate](https://github.com/nvim-mini/mini.animate) | 平滑动画效果 | 延迟加载 |
| [mini.clue](https://github.com/nvim-mini/mini.clue) | 快捷键提示面板 | 延迟加载 |
| [mini.cmdline](https://github.com/nvim-mini/mini.cmdline) | 命令行增强 | 延迟加载 |
| [mini.completion](https://github.com/nvim-mini/mini.completion) | 自动补全引擎 | 延迟加载 |
| [mini.cursorword](https://github.com/nvim-mini/mini.cursorword) | 光标下单词高亮 | 延迟加载 |
| [mini.diff](https://github.com/nvim-mini/mini.diff) | Git 差异显示 | 延迟加载 |
| [mini.icons](https://github.com/nvim-mini/mini.icons) | 文件图标支持 | 延迟加载 |
| [mini.indentscope](https://github.com/nvim-mini/mini.indentscope) | 缩进指示线 | 延迟加载 |
| [mini.misc](https://github.com/nvim-mini/mini.misc) | 工具函数集合 | 立即加载 |
| [mini.notify](https://github.com/nvim-mini/mini.notify) | 通知系统 | 立即加载 |
| [mini.pick](https://github.com/nvim-mini/mini.pick) | 文件/内容选择器 | 延迟加载 |
| [mini.snippets](https://github.com/nvim-mini/mini.snippets) | 代码片段系统 | 延迟加载 |
| [mini.statusline](https://github.com/nvim-mini/mini.statusline) | 状态栏 | 立即加载 |
| [mini.tabline](https://github.com/nvim-mini/mini.tabline) | 标签栏 | 立即加载 |

### 语言与工具插件

| 插件 | 描述 | 加载方式 |
|------|------|----------|
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP 配置管理 | 延迟加载 |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | 语法树解析 | 延迟加载 |
| [nvim-treesitter-context](https://github.com/nvim-treesitter/nvim-treesitter-context) | 上下文显示 | 延迟加载 |

### 主题与界面

| 插件 | 描述 | 加载方式 |
|------|------|----------|
| [dracula/vim](https://github.com/dracula/vim) | Dracula/Alucard 主题 | 立即加载 |

### 任务与工具

| 插件 | 描述 | 加载方式 |
|------|------|----------|
| [asyncrun.vim](https://github.com/skywind3000/asyncrun.vim) | 异步任务运行 | 延迟加载 |
| [asynctasks.vim](https://github.com/skywind3000/asynctasks.vim) | 任务管理系统 | 延迟加载 |
| [vim-terminal-help](https://github.com/skywind3000/vim-terminal-help) | 终端辅助 | 延迟加载 |

### AI 辅助

| 插件 | 描述 | 加载方式 |
|------|------|----------|
| [windsurf.vim](https://github.com/Exafunction/windsurf.vim) | Codeium AI 补全 | 延迟加载 |

---

## 🚀 快速开始

### 系统依赖

```bash
# 必需
- Neovim >= 0.9.0
- Git
- Node.js >= 18.0.0 (LSP 支持)
- ripgrep (mini.pick 搜索)

# 可选 LSP 服务器
- clangd (C/C++ LSP)
- lua-language-server (Lua LSP)
- pylsp (Python LSP)
- bash-language-server (Bash LSP)
- json-lsp (JSON LSP)
- lemminx (XML LSP)
- vala-language-server (Vala LSP)
```

### 安装步骤

```bash
# 1. 备份现有配置
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak

# 2. 克隆配置
git clone https://github.com/yourusername/nvim-config.git ~/.config/nvim

# 3. 启动 Neovim
nvim

# 4. 等待插件自动安装完成
# 首次启动会自动下载所有插件
```

### 验证安装

```vim
" 检查插件状态
:packadd

" 查看 LSP 状态
:LspInfo

" 测试文件搜索
<C-p>
```

---

## 📂 项目结构

```
~/.config/nvim/
├── init.lua                 # 主入口文件
├── nvim-pack-lock.json      # 插件版本锁定
├── plugin/
│   └── config.lua          # 完整配置 (所有设置)
└── tasks.ini               # 异步任务配置
```

---

## ⚙️ 配置详解

### 基础设置 (config.lua)

```lua
-- 编辑器基础设置
o.relativenumber = true    -- 相对行号
o.scrolloff = 999          -- 保持光标居中
o.cursorline = true        -- 高亮当前行
o.termguicolors = true     -- 真彩色支持
o.encoding = "UTF-8"       -- 编码设置

-- 文件编码支持
o.fileencodings = "ucs-bom,utf-8,gb2312,default,latin1"

-- 窗口分割设置
o.splitright = true        -- 水平分割在右侧
o.splitbelow = true        -- 垂直分割在下方

-- 搜索设置
o.smartcase = true         -- 智能大小写
o.ignorecase = true        -- 忽略大小写
```

### 加载策略

配置采用分层加载策略：
- **立即加载 (now)**：核心插件和基础功能
- **延迟加载 (later)**：非关键功能，提升启动速度

```lua
-- 立即加载：基础插件
now(function()
    add { "https://github.com/nvim-mini/mini.notify" }
    -- ...
end)

-- 延迟加载：功能插件
later(function()
    add { "https://github.com/nvim-mini/mini.pick" }
    -- ...
end)
```

---

## ⌨️ 快捷键映射

### 基础快捷键

| 快捷键 | 功能 | 模式 |
|--------|------|------|
| `<M-q>` | 关闭窗口 | Normal |
| `<space>d` | 诊断到位置列表 | Normal |
| `<space>f` | 格式化代码 | Normal |
| `<space>r` | 查找引用 | Normal |

### 文件搜索

| 快捷键 | 功能 |
|--------|------|
| `<C-p>` | 文件搜索 (mini.pick) |
| `<leader>p` | 内容实时搜索 (mini.pick) |

### 任务管理

| 快捷键 | 功能 |
|--------|------|
| `<F5>` | 运行当前文件任务 |
| `<F6>` | 运行项目任务 |
| `<F7>` | 构建项目 |
| `<F4>` | 停止当前任务 |

### AI 辅助

| 快捷键 | 功能 |
|--------|------|
| `<C-f>` | 接受 Codeium 补全 (插入模式) |

### 窗口管理

| 快捷键 | 功能 |
|--------|------|
| `<space>d` | 打开诊断列表 |
| `<M-q>` | 关闭当前窗口 |

---

## 🔧 LSP 支持

### 支持的服务器

```lua
vim.lsp.enable {
    "clangd",     -- C/C++
    "lua_ls",     -- Lua
    "bashls",     -- Bash
    "jsonls",     -- JSON
    "pylsp",      -- Python
    "lemminx",    -- XML
    "vala_ls",    -- Vala
}
```

### LSP 配置示例

```lua
-- Clangd 配置 (Webkit 风格)
vim.lsp.config('clangd', {
    cmd = { 'clangd', '--fallback-style=Webkit' }
})

-- Lua 语言服务器配置
vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            hint = {
                enable = true,
                setType = true
            },
            runtime = {
                version = "LuaJIT",
            },
            type = {
                inferParamType = true,
                checkTableShape = true,
            },
        }
    }
})
```

### LSP 功能

- ✅ 代码补全
- ✅ 诊断信息 (虚拟文本)
- ✅ 代码格式化
- ✅ 查找引用
- ✅ 内联提示 (inlay hints)
- ✅ 类型推导

---

## 📝 任务管理

### tasks.ini 配置

```ini
# 运行当前 Lua 文件
[file-run]
command:lua=luajit "$(VIM_FILENAME)"
cwd=$(VIM_FILEDIR)
output=terminal

# 运行项目 (示例)
[project-run]
command:python=python3 main.py
cwd=$(VIM_FILEPARENT)
output=terminal

# 构建项目 (示例)
[project-build]
command:make=make
cwd=$(VIM_FILEPARENT)
output=quickfix
```

### 任务使用

```vim
" 运行当前文件
:AsyncTask file-run

" 运行项目
:AsyncTask project-run

" 构建项目
:AsyncTask project-build

" 停止任务
<F4>
```

---

## 🎨 主题与界面

### 主题

- **主题**：Alucard (基于 Dracula)
- **图标**：mini.icons 提供文件类型图标
- **状态栏**：mini.statusline 自定义状态信息
- **标签栏**：mini.tabline 显示缓冲区标签

### 界面优化

```lua
-- 光标居中
o.scrolloff = 999

-- 当前行高亮
o.cursorline = true

-- 缩进指示线
require "mini.indentscope".setup {}

-- 平滑滚动 (禁用滚动动画提升性能)
require 'mini.animate'.setup { scroll = { enable = false } }
```

---

## 🤖 AI 辅助

### Codeium (windsurf.vim)

```lua
-- 配置
g.codeium_disable_bindings = 1

-- 快捷键
map('i', '<C-f>', function()
    return vim.fn['codeium#Accept']()
end, { expr = true, silent = true })
```

### 使用 AI 补全

1. 在插入模式下开始输入
2. Codeium 会自动弹出建议
3. 按 `<C-f>` 接受建议
4. 按 `<C-n>`/`<C-p>` 浏览其他建议

---

## 🔩 自定义配置

### 添加新语言支持

1. 安装 Treesitter 语法：

```lua
-- 在 config.lua 中
require 'nvim-treesitter'.setup {
    ensure_installed = { "bash", "lua", "python", "rust" }, -- 添加新语言
    highlight = { enable = true }
}
```

2. 配置 LSP：

```lua
-- 添加 LSP 服务器
vim.lsp.enable {
    "clangd",
    "lua_ls",
    "bashls",
    "jsonls",
    "pylsp",
    "lemminx",
    "vala_ls",
    "rust_analyzer", -- 新增
}
```

### 添加新任务

在 `tasks.ini` 中添加：

```ini
[rust-run]
command:cargo=cargo run
cwd=$(VIM_FILEPARENT)
output=terminal
```

### 修改快捷键

```lua
-- 在 config.lua 中修改
map("n", "<C-p>", function()
    pick.builtin.files { tool = 'rg' }
end)
```

---

## 📝 更新日志

### v1.0.0 (2026-08-03)
- ✨ 初始版本发布
- 📦 集成 15+ mini.nvim 插件
- 🔧 完整的 LSP 支持 (7+ 语言)
- 📋 AsyncRun/AsyncTasks 任务系统
- 🎨 Dracula/Alucard 主题
- 🤖 Codeium AI 辅助
- 🔍 mini.pick 文件搜索
- ⚡ 分层加载策略优化启动速度

---

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

1. Fork 本仓库
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开 Pull Request

---

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情

---

## 📞 联系方式

- **作者**: [Your Name]
- **邮箱**: [your.email@example.com]
- **GitHub**: [https://github.com/yourusername](https://github.com/yourusername)

---

## 🙏 致谢

特别感谢以下项目：

- [mini.nvim](https://github.com/echasnovski/mini.nvim) - 优秀的模块化插件集合
- [asyncrun.vim](https://github.com/skywind3000/asyncrun.vim) - 强大的异步任务工具
- [Codeium](https://codeium.com/) - 免费的 AI 代码补全
- [Dracula Theme](https://draculatheme.com/) - 经典配色方案
- [Neovim](https://neovim.io/) - 现代化的 Vim 分支

---

**⭐ 如果这个配置对你有帮助，请给一个 Star！**
