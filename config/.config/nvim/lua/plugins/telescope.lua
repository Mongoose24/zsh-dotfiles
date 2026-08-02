local tools = require("config.tools")
local has_build_tools = tools.executable("make") and tools.has_compiler()

return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = has_build_tools,
			},
		},
		config = function()
			local find_command
			if tools.executable("fd") then
				find_command = { "fd", "--type", "f", "--strip-cwd-prefix" }
			elseif tools.executable("fdfind") then
				find_command = { "fdfind", "--type", "f", "--strip-cwd-prefix" }
			end

			local telescope = require("telescope")
			telescope.setup({
				pickers = {
					find_files = { find_command = find_command },
				},
				extensions = {
					["ui-select"] = { require("telescope.themes").get_dropdown() },
				},
			})

			if has_build_tools then
				local loaded, err = pcall(telescope.load_extension, "fzf")
				if not loaded then
					vim.schedule(function()
						vim.notify("Telescope FZF is unavailable: " .. tostring(err), vim.log.levels.WARN)
					end)
				end
			end

			local ui_select_loaded, ui_select_err = pcall(telescope.load_extension, "ui-select")
			if not ui_select_loaded then
				vim.schedule(function()
					vim.notify("Telescope ui-select is unavailable: " .. tostring(ui_select_err), vim.log.levels.WARN)
				end)
			end

			local builtin = require("telescope.builtin")
			local map = vim.keymap.set

			map("n", "<leader>sh", builtin.help_tags, { desc = "Search help" })
			map("n", "<leader>sk", builtin.keymaps, { desc = "Search keymaps" })
			map("n", "<leader>sf", builtin.find_files, { desc = "Search files" })
			map("n", "<leader>ss", builtin.builtin, { desc = "Select Telescope picker" })
			map({ "n", "v" }, "<leader>sw", builtin.grep_string, { desc = "Search current word" })
			map("n", "<leader>sg", builtin.live_grep, { desc = "Search by grep" })
			map("n", "<leader>sd", builtin.diagnostics, { desc = "Search diagnostics" })
			map("n", "<leader>sr", builtin.resume, { desc = "Resume search" })
			map("n", "<leader>s.", builtin.oldfiles, { desc = "Search recent files" })
			map("n", "<leader>sc", builtin.commands, { desc = "Search commands" })
			map("n", "<leader><leader>", builtin.buffers, { desc = "Find existing buffers" })

			map("n", "<leader>/", function()
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end, { desc = "Search current buffer" })

			map("n", "<leader>s/", function()
				builtin.live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end, { desc = "Search open files" })

			map("n", "<leader>sn", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config"), follow = true })
			end, { desc = "Search Neovim files" })

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("config-telescope-lsp-attach", { clear = true }),
				callback = function(event)
					local opts = { buffer = event.buf }
					map("n", "grr", builtin.lsp_references, vim.tbl_extend("force", opts, { desc = "Goto references" }))
					map(
						"n",
						"gri",
						builtin.lsp_implementations,
						vim.tbl_extend("force", opts, { desc = "Goto implementation" })
					)
					map(
						"n",
						"grd",
						builtin.lsp_definitions,
						vim.tbl_extend("force", opts, { desc = "Goto definition" })
					)
					map(
						"n",
						"gO",
						builtin.lsp_document_symbols,
						vim.tbl_extend("force", opts, { desc = "Document symbols" })
					)
					map(
						"n",
						"gW",
						builtin.lsp_dynamic_workspace_symbols,
						vim.tbl_extend("force", opts, { desc = "Workspace symbols" })
					)
					map(
						"n",
						"grt",
						builtin.lsp_type_definitions,
						vim.tbl_extend("force", opts, { desc = "Goto type definition" })
					)
				end,
			})
		end,
	},
}
