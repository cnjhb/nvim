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

local add, later, now = MiniDeps.add, MiniDeps.later, MiniDeps.now

now(function()
	add { source = "echasnovski/mini.notify" }
	local notify = require "mini.notify"
	notify.setup {}
	vim.notify = notify.make_notify {}
end)

now(function()
	add { source = "echasnovski/mini.tabline" }
	require "mini.tabline".setup {}
end)

now(function()
	add { source = "echasnovski/mini.statusline" }
	require "mini.statusline".setup {}
end)

now(function()
	add { source = "dracula/vim" }
	vim.cmd [[ colo dracula ]]
end)

later(function()
	add { source = "nvim-treesitter/nvim-treesitter" }
	require 'nvim-treesitter.configs'.setup {
		ensure_installed = { "bash" },
		highlight = {
			enable = true,
			disable = { "c", "lua" },
		},
	}
end)

later(function()
	add { source = "echasnovski/mini.icons" }
	require "mini.icons".setup {}
end)

later(function()
	add { source = 'skywind3000/asynctasks.vim', depends = { 'skywind3000/asyncrun.vim' }, }
	g.asyncrun_rootmarks = { '.build_root' }
	g.asyncrun_open = 6
	map('n', '<f5>', "<cmd>AsyncTask file-run<cr>")
	map('n', '<f6>', "<cmd>AsyncTask project-run<cr>")
	map('n', '<f7>', "<cmd>AsyncTask project-build<cr>")
end)

later(function()
	add { source = "skywind3000/vim-terminal-help" }
end)

later(function()
	add { source = "neovim/nvim-lspconfig" }
	vim.lsp.enable { 'clangd', "lua_ls", "bashls" }
	vim.lsp.inlay_hint.enable()

	map('n', '<space>f', function() vim.lsp.buf.format { async = true } end)
	map('n', '<space>r', vim.lsp.buf.references)
end)

later(function()
	add { source = "echasnovski/mini.animate" }
	require 'mini.animate'.setup { scroll = { enable = false } }
end)

later(function()
	add { source = "echasnovski/mini.pick" }
	local pick = require 'mini.pick'
	pick.setup {}
	map("n", "<C-p>", function() pick.builtin.files { tool = 'rg' } end)
end)

later(function()
	add { source = "echasnovski/mini.indentscope" }
	require "mini.indentscope".setup {}
end)

later(function()
	add { source = "echasnovski/mini.diff" }
	require "mini.diff".setup {}
end)


later(function()
	add { source = "echasnovski/mini.cursorword" }
	require "mini.cursorword".setup {}
end)

later(function()
	add { source = "echasnovski/mini.completion" }
	require "mini.completion".setup {}
end)

later(function()
	add("echasnovski/mini.snippets")
	require "mini.snippets".setup {}
end)

later(function()
	add { source = "Exafunction/windsurf.vim" }
	g.codeium_disable_bindings = 1
	map('i', '<C-f>', function () return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
end)
