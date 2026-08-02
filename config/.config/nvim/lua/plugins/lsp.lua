return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"saghen/blink.cmp",
			{
				"j-hui/fidget.nvim",
				opts = {
					progress = { suppress_on_insert = true },
				},
			},
			{
				"mason-org/mason.nvim",
				opts = {
					ui = { border = "rounded" },
				},
			},
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		config = function()
			local servers = {
				lua_ls = {
					on_init = function(client)
						client.server_capabilities.documentFormattingProvider = false

						if client.workspace_folders then
							local path = client.workspace_folders[1].name
							if
								path ~= vim.fn.stdpath("config")
								and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
							then
								return
							end
						end

						local library = vim.api.nvim_get_runtime_file("", true)
						vim.list_extend(library, {
							"${3rd}/luv/library",
							"${3rd}/busted/library",
						})

						local settings = vim.tbl_deep_extend("force", client.settings or client.config.settings or {}, {
							Lua = {
								runtime = {
									version = "LuaJIT",
									path = { "lua/?.lua", "lua/?/init.lua" },
								},
								workspace = {
									checkThirdParty = false,
									library = library,
								},
							},
						})
						client.settings = settings
						client.config.settings = settings
						client:notify("workspace/didChangeConfiguration", { settings = settings })
					end,
					settings = {
						Lua = {
							format = { enable = false },
						},
					},
				},
			}

			local server_names = vim.tbl_keys(servers)
			require("mason-lspconfig").setup({ automatic_enable = false })

			local blink = require("blink.cmp")
			for name, server in pairs(servers) do
				server.capabilities = blink.get_lsp_capabilities(server.capabilities)
				vim.lsp.config(name, server)
				vim.lsp.enable(name)
			end

			local system_tools = require("config.tools")
			local server_executables = { lua_ls = "lua-language-server" }

			local function attach_installed_servers()
				local pending = false
				for _, name in ipairs(server_names) do
					if system_tools.executable(server_executables[name]) then
						local config = vim.lsp.config[name]
						for _, buf in ipairs(vim.api.nvim_list_bufs()) do
							if
								vim.api.nvim_buf_is_loaded(buf)
								and vim.bo[buf].buftype == ""
								and vim.tbl_contains(config.filetypes or {}, vim.bo[buf].filetype)
								and #vim.lsp.get_clients({ bufnr = buf, name = name }) == 0
							then
								vim.api.nvim_exec_autocmds("FileType", { buffer = buf, modeline = false })
							end
						end
					else
						pending = true
					end
				end
				return pending
			end

			local attempts = 0
			local function retry_pending_servers()
				attempts = attempts + 1
				if attach_installed_servers() and attempts < 60 then
					vim.defer_fn(retry_pending_servers, 1000)
				end
			end

			vim.api.nvim_create_autocmd("User", {
				group = vim.api.nvim_create_augroup("config-mason-tools", { clear = true }),
				pattern = "MasonToolsUpdateCompleted",
				callback = function()
					attach_installed_servers()
				end,
			})
			vim.defer_fn(retry_pending_servers, 3000)

			local mason_tools = vim.list_extend(vim.deepcopy(server_names), { "stylua" })
			require("mason-tool-installer").setup({
				ensure_installed = mason_tools,
				run_on_start = true,
				start_delay = 3000,
				debounce_hours = 24,
			})

			local attach_group = vim.api.nvim_create_augroup("config-lsp-attach", { clear = true })
			local highlight_group = vim.api.nvim_create_augroup("config-lsp-highlight", { clear = true })

			vim.api.nvim_create_autocmd("LspAttach", {
				group = attach_group,
				callback = function(event)
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if not client then
						return
					end

					vim.keymap.set("n", "grD", vim.lsp.buf.declaration, {
						buffer = event.buf,
						desc = "LSP: Goto declaration",
					})

					if client:supports_method("textDocument/documentHighlight", event.buf) then
						vim.api.nvim_clear_autocmds({ group = highlight_group, buffer = event.buf })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_group,
							callback = vim.lsp.buf.document_highlight,
						})
						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_group,
							callback = vim.lsp.buf.clear_references,
						})
						vim.api.nvim_create_autocmd("LspDetach", {
							buffer = event.buf,
							group = highlight_group,
							callback = function(detach_event)
								local detached_client = detach_event.data.client_id
								vim.schedule(function()
									if not vim.api.nvim_buf_is_valid(detach_event.buf) then
										return
									end

									for _, other in ipairs(vim.lsp.get_clients({ bufnr = detach_event.buf })) do
										if
											other.id ~= detached_client
											and other:supports_method(
												"textDocument/documentHighlight",
												detach_event.buf
											)
										then
											return
										end
									end

									vim.api.nvim_buf_call(detach_event.buf, vim.lsp.buf.clear_references)
									vim.api.nvim_clear_autocmds({ group = highlight_group, buffer = detach_event.buf })
								end)
							end,
						})
					end

					if client:supports_method("textDocument/inlayHint", event.buf) then
						vim.keymap.set("n", "<leader>th", function()
							local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })
							vim.lsp.inlay_hint.enable(not enabled, { bufnr = event.buf })
						end, {
							buffer = event.buf,
							desc = "LSP: Toggle inlay hints",
						})
					end
				end,
			})
		end,
	},
}
