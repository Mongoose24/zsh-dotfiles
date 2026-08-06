vim.loader.enable()

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = vim.env.NVIM_NERD_FONT ~= "0"

vim.opt.termguicolors = true
vim.opt.guicursor = ""
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.breakindent = true
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.confirm = true

local state_dir = vim.fn.stdpath("state")
local swap_dir = state_dir .. "/swap"
local undo_dir = state_dir .. "/undo"
vim.fn.mkdir(swap_dir, "p")
vim.fn.mkdir(undo_dir, "p")

vim.opt.directory = { swap_dir .. "//" }
vim.opt.swapfile = true
vim.opt.backup = false
vim.opt.undodir = undo_dir
vim.opt.undofile = true

local tools = require("config.tools")
local system = vim.uv.os_uname().sysname
local has_local_clipboard = false

if system == "Darwin" then
	has_local_clipboard = tools.executable("pbcopy") and tools.executable("pbpaste")
elseif system == "Linux" then
	if vim.env.WAYLAND_DISPLAY and tools.executable("wl-copy") and tools.executable("wl-paste") then
		has_local_clipboard = true
	elseif vim.env.DISPLAY and (tools.executable("xclip") or tools.executable("xsel")) then
		has_local_clipboard = true
	end
end

-- Keep the option empty on remote/headless hosts so Neovim can use OSC 52.
if has_local_clipboard then
	vim.opt.clipboard = "unnamedplus"

	vim.keymap.set({ "n", "v" }, "d", '"_d')
	vim.keymap.set({ "n", "v" }, "c", '"_c')
  	vim.keymap.set({ "n", "v" }, "x", '"_x')
end
