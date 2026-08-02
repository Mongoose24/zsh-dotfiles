local tools = require("config.tools")
local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazy_path) then
	if not tools.executable("git") then
		error("lazy.nvim requires Git. Install Git, then restart Neovim.")
	end

	local output = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		"https://github.com/folke/lazy.nvim.git",
		lazy_path,
	})

	if vim.v.shell_error ~= 0 then
		error("Failed to install lazy.nvim:\n" .. output)
	end
end

vim.opt.rtp:prepend(lazy_path)

require("lazy").setup({
	spec = { { import = "plugins" } },
	defaults = {
		lazy = false,
		version = false,
	},
	install = {
		colorscheme = { "catppuccin", "habamax" },
	},
	checker = { enabled = false },
	change_detection = { notify = false },
})
