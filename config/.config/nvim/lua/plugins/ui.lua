return {
	{
		"folke/which-key.nvim",
		opts = {
			delay = 0,
			icons = { mappings = vim.g.have_nerd_font },
			spec = {
				{ "<leader>s", group = "Search", mode = { "n", "v" } },
				{ "<leader>t", group = "Toggle" },
				{ "gr", group = "LSP actions", mode = "n" },
			},
		},
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				transparent_background = true,
				float = { transparent = true, solid = false },
				lsp_styles = {
					virtual_text = {
						errors = { "italic" },
						hints = { "italic" },
						warnings = { "italic" },
						information = { "italic" },
					},
				},
				integrations = {
					fidget = true,
					mason = true,
					telescope = { enabled = true },
					which_key = true,
				},
			})
			vim.cmd.colorscheme("catppuccin")
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "catppuccin/nvim" },
		config = function()
			local catppuccin_colors = require("catppuccin.palettes").get_palette("mocha")
			local lualine_theme = require("catppuccin.utils.lualine")("mocha")

			for _, mode in ipairs({ "normal", "insert", "terminal", "command", "visual", "replace", "inactive" }) do
				for _, section in ipairs({ "b", "c" }) do
					if lualine_theme[mode] and lualine_theme[mode][section] then
						lualine_theme[mode][section].bg = catppuccin_colors.mantle
					end
				end
			end

			local function icon(glyph)
				return vim.g.have_nerd_font and glyph or nil
			end

			local diff_symbols = vim.g.have_nerd_font and { added = " ", modified = " ", removed = " " }
				or { added = "+ ", modified = "~ ", removed = "- " }

			require("lualine").setup({
				options = {
					theme = lualine_theme,
					icons_enabled = vim.g.have_nerd_font,
					component_separators = "",
					section_separators = "",
					globalstatus = true,
				},
				sections = {
					lualine_a = { { "mode", icon = icon("") } },
					lualine_b = {
						{ "branch", icon = icon("") },
						{ "diff", symbols = diff_symbols },
						"diagnostics",
					},
					lualine_c = { { "filename", path = 1 } },
					lualine_x = {
						{ "encoding", icon = icon("󰈙") },
						{ "fileformat", icon = icon("") },
						"filetype",
					},
					lualine_y = { { "progress", icon = icon("󰦗") } },
					lualine_z = { { "location", icon = icon("󰍎") } },
				},
			})
		end,
	},
}
