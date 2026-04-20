local vim = vim
local misc = require "mini.misc"
local add, later, now = vim.pack.add, function(f) misc.safely('later', f) end, function(f) misc.safely('now', f) end
local o, g, map = vim.o, vim.g, vim.keymap.set

o.relativenumber = true
o.scrolloff = 999
o.cursorline = true
o.termguicolors = true
o.encoding = "UTF-8"
o.lazyredraw = true
o.splitright = true
o.splitbelow = true
o.smartcase = true
o.ignorecase = true
o.fileencodings = "ucs-bom,utf-8,gb2312,default,latin1"

map("n", "<M-q>", "<cmd>q<cr>")
map("n", "<space>d", vim.diagnostic.setloclist)
vim.diagnostic.config {
	virtual_text = true
}

now(function()
	add { "https://github.com/nvim-mini/mini.notify" }
	local notify = require "mini.notify"
	notify.setup {}
	vim.notify = notify.make_notify {}
end)

now(function()
	add { "https://github.com/nvim-mini/mini.tabline" }
	require "mini.tabline".setup {}
end)

now(function()
	add { "https://github.com/nvim-mini/mini.statusline" }
	require "mini.statusline".setup {}
end)

now(function()
	add { "https://github.com/dracula/vim" }
	vim.cmd [[ colo dracula ]]
end)

later(function()
	add { "https://github.com/nvim-treesitter/nvim-treesitter" }
	require 'nvim-treesitter'.setup {
		ensure_installed = { "bash" },
		highlight = {
			enable = true,
			disable = { "c", "lua" },
		},
	}
end)

later(function()
	add { "https://github.com/nvim-treesitter/nvim-treesitter-context" }
	require 'treesitter-context'.setup {}
end)

later(function()
	add { "https://github.com/nvim-mini/mini.icons" }
	require "mini.icons".setup {}
end)

later(function()
	add { "https://github.com/skywind3000/asyncrun.vim" }
	add { "https://github.com/skywind3000/asynctasks.vim" }
	g.asyncrun_rootmarks = { '.build_root' }
	g.asyncrun_open = 6
	map('n', '<f4>', "<cmd>AsyncStop<cr>")
	map('n', '<f5>', "<cmd>AsyncTask file-run<cr>")
	map('n', '<f6>', "<cmd>AsyncTask project-run<cr>")
	map('n', '<f7>', "<cmd>AsyncTask project-build<cr>")
end)

later(function()
	add { "https://github.com/skywind3000/vim-terminal-help" }
end)

later(function()
	add { "https://github.com/neovim/nvim-lspconfig" }
	vim.lsp.enable {
		"clangd",
		"lua_ls",
		"bashls",
		"jsonls",
		"pylsp",
		"lemminx",
		"vala_ls",
	}
	vim.lsp.inlay_hint.enable()
	vim.lsp.config('clangd', {
		cmd = { 'clangd', '--fallback-style=Webkit' }
	})
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

	map('n', '<space>f', function() vim.lsp.buf.format { async = true } end)
	map('v', 'f', function() vim.lsp.buf.format { async = true } end)
	map('n', '<space>r', vim.lsp.buf.references)
end)

later(function()
	add { "https://github.com/nvim-mini/mini.animate" }
	require 'mini.animate'.setup { scroll = { enable = false } }
end)

later(function()
	add { "https://github.com/nvim-mini/mini.pick" }
	local pick = require 'mini.pick'
	pick.setup {}
	map("n", "<C-p>", function() pick.builtin.files { tool = 'rg' } end)
	map("n", "<leader>p", function()
		pick.builtin.grep_live { tool = 'rg' }
	end)
end)

later(function()
	add { "https://github.com/nvim-mini/mini.indentscope" }
	require "mini.indentscope".setup {}
end)

later(function()
	add { "https://github.com/nvim-mini/mini.diff" }
	require "mini.diff".setup {}
end)


later(function()
	add { "https://github.com/nvim-mini/mini.cursorword" }
	require "mini.cursorword".setup {}
end)

later(function()
	add { "https://github.com/nvim-mini/mini.completion" }
	require "mini.completion".setup {}
end)

later(function()
	add { "https://github.com/nvim-mini/mini.snippets" }
	require "mini.snippets".setup {}
end)

later(function()
	add { "https://github.com/Exafunction/windsurf.vim" }
	g.codeium_disable_bindings = 1
	map('i', '<C-f>', function() return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
end)

later(function()
	add { "https://github.com/nvim-mini/mini.cmdline" }
	require "mini.cmdline".setup()
end)

later(function()
	add { "https://github.com/nvim-mini/mini.clue" }
	require "mini.clue".setup()
end)
