return {
	{
		"stevearc/conform.nvim",
		opts = {
			notify_on_error = true,
			default_format_opts = { lsp_format = "fallback" },
			formatters_by_ft = {
				lua = { "stylua" },
			},
		},
		config = function(_, opts)
			local conform = require("conform")
			conform.setup(opts)

			vim.keymap.set({ "n", "v" }, "<leader>f", function()
				conform.format({ async = true, lsp_format = "fallback" })
			end, { desc = "Format buffer or selection" })
		end,
	},
}
