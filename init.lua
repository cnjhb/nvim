local vim = vim
if vim.loader.enable ~= nil then
	vim.loader.enable()
end

vim.lsp.log.set_level(vim.log.levels.OFF)

vim.pack.add { "https://github.com/nvim-mini/mini.misc" }
