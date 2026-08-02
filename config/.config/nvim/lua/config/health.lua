local M = {}
local tools = require("config.tools")

local function check_executable(command, required, reason)
	if tools.executable(command) then
		vim.health.ok(("`%s` is available"):format(command))
	elseif required then
		vim.health.error(("`%s` is required: %s"):format(command, reason))
	else
		vim.health.warn(("`%s` is recommended: %s"):format(command, reason))
	end
end

function M.check()
	vim.health.start("Configuration")

	if vim.fn.has("nvim-0.12") == 1 then
		vim.health.ok("Neovim 0.12+ is available")
	else
		vim.health.error("Neovim 0.12+ is required")
	end

	check_executable("git", true, "plugin installation and Git integrations")
	check_executable("curl", true, "Treesitter and Mason downloads")
	check_executable("tar", true, "Treesitter and Mason archives")
	check_executable("unzip", true, "Mason package archives")

	local tree_sitter_supported, tree_sitter_version = tools.tree_sitter_supported()
	if tree_sitter_supported then
		vim.health.ok(("Tree-sitter CLI %s is available"):format(tree_sitter_version))
	elseif tree_sitter_version then
		vim.health.error(("Tree-sitter CLI 0.26.1+ is required; found %s"):format(tree_sitter_version))
	else
		vim.health.error("Tree-sitter CLI 0.26.1+ is required")
	end

	if tools.has_compiler() then
		vim.health.ok("A C compiler is available")
	else
		vim.health.error("A C compiler is required for Treesitter parsers")
	end

	check_executable("make", false, "Telescope FZF and LuaSnip's optional regexp support")
	check_executable("rg", false, "Telescope live grep and TODO searches")

	if tools.executable("fd") then
		vim.health.ok("`fd` is available")
	elseif tools.executable("fdfind") then
		vim.health.ok("`fdfind` is available (Debian fallback configured)")
	else
		vim.health.warn("`fd` or `fdfind` is recommended for faster file search")
	end

	local clipboard = vim.opt.clipboard:get()
	if vim.tbl_contains(clipboard, "unnamedplus") then
		vim.health.ok("A local system clipboard provider is enabled")
	elseif vim.env.SSH_CONNECTION or vim.env.SSH_TTY then
		vim.health.info("Local clipboard integration is disabled; Neovim may use OSC 52 over SSH")
	else
		vim.health.warn("No local clipboard provider detected; install wl-clipboard, xclip, or xsel")
	end

	if vim.g.have_nerd_font then
		vim.health.info("Nerd Font icons are enabled; set NVIM_NERD_FONT=0 for ASCII fallbacks")
	else
		vim.health.info("Nerd Font icons are disabled through NVIM_NERD_FONT=0")
	end
end

return M
