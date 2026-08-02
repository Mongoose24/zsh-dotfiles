return {
	{
		"mbbill/undotree",
		init = function()
			vim.g.undotree_SetFocusWhenToggle = 1
			vim.g.undotree_DiffAutoOpen = 1
		end,
		config = function()
			vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<CR>", {
				desc = "Toggle UndoTree",
			})

			local group = vim.api.nvim_create_augroup("config-undotree-preview", { clear = true })
			vim.api.nvim_create_autocmd("FileType", {
				group = group,
				pattern = "undotree",
				callback = function(event)
					local previewing = false

					vim.api.nvim_create_autocmd("CursorMoved", {
						group = group,
						buffer = event.buf,
						callback = function()
							if previewing then
								return
							end

							previewing = true
							vim.schedule(function()
								if
									vim.api.nvim_buf_is_valid(event.buf)
									and vim.api.nvim_get_current_buf() == event.buf
								then
									vim.api.nvim_feedkeys(vim.keycode("<CR>"), "m", false)
								end
								previewing = false
							end)
						end,
					})
				end,
			})
		end,
	},
}
