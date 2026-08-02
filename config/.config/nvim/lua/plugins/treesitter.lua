local tools = require("config.tools")

local parsers = {
	"bash",
	"c",
	"diff",
	"html",
	"lua",
	"luadoc",
	"markdown",
	"markdown_inline",
	"query",
	"vim",
	"vimdoc",
}

local tree_sitter_supported = tools.tree_sitter_supported()
local has_parser_tools = tools.executable("curl")
	and tools.executable("tar")
	and tree_sitter_supported
	and tools.has_compiler()

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local treesitter = require("nvim-treesitter")
			vim.treesitter.language.register("bash", "sh")

			local function attach(buf)
				if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_buf_is_loaded(buf) then
					return
				end

				local language = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
				if not language or not vim.tbl_contains(treesitter.get_installed("parsers"), language) then
					return
				end

				if not vim.treesitter.language.add(language) then
					return
				end

				if not vim.treesitter.highlighter.active[buf] then
					vim.treesitter.start(buf, language)
				end

				local has_indents, indent_query = pcall(vim.treesitter.query.get, language, "indents")
				if has_indents and indent_query then
					vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			end

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("config-treesitter-attach", { clear = true }),
				callback = function(event)
					attach(event.buf)
				end,
			})

			if has_parser_tools then
				treesitter.install(parsers):await(function(err)
					if err then
						vim.schedule(function()
							vim.notify("Treesitter parser installation failed: " .. tostring(err), vim.log.levels.ERROR)
						end)
						return
					end

					vim.schedule(function()
						for _, buf in ipairs(vim.api.nvim_list_bufs()) do
							attach(buf)
						end
					end)
				end)
			else
				vim.schedule(function()
					vim.notify_once(
						"Treesitter parsers need curl, tar, tree-sitter 0.26.1+, and a C compiler. Run :checkhealth config.",
						vim.log.levels.WARN
					)
				end)
			end
		end,
	},
}
