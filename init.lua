local vim = vim
if vim.loader.enable ~= nil then
	vim.loader.enable()
end

vim.lsp.log.set_level(vim.log.levels.OFF)

vim.pack.add { "https://github.com/nvim-mini/mini.misc" }

-- clangd needs to be registered before the first C file is opened: the
-- FileType event fires before `later()` (VimEnter) callbacks run, so
-- `nvim foo.c` would otherwise never attach a client.
vim.lsp.config('clangd', {
	cmd = { 'clangd', '--fallback-style=Webkit', '--background-index' },
	filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
	root_markers = { 'compile_commands.json', '.clangd', '.clang-tidy', '.git' },
})
vim.lsp.enable('clangd')

