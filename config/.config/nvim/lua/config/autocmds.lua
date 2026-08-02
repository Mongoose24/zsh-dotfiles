vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("config-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})
