return {
	{
		"NMAC427/guess-indent.nvim",
		opts = {},
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
	{
		"nvim-mini/mini.nvim",
		config = function()
			if vim.g.have_nerd_font then
				local icons = require("mini.icons")
				icons.setup()
				icons.mock_nvim_web_devicons()
			end

			require("mini.ai").setup({
				mappings = { around_next = "aN", inside_next = "iN" },
				n_lines = 500,
			})
			require("mini.surround").setup()
		end,
	},
}
