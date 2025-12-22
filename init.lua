local vim = vim
if vim.loader.enable ~= nil then
	vim.loader.enable()
end

vim.lsp.log.set_level(vim.log.levels.OFF)

require('mini.deps').setup {}
