local vim = vim
if vim.loader.enable ~= nil then
	vim.loader.enable()
end

require('mini.deps').setup {}
