local required_plugins = {
  "guess-indent.nvim",
  "gitsigns.nvim",
  "which-key.nvim",
  "nvim",
  "lualine.nvim",
  "todo-comments.nvim",
  "mini.nvim",
  "undotree",
  "plenary.nvim",
  "telescope.nvim",
  "telescope-ui-select.nvim",
  "telescope-fzf-native.nvim",
  "fidget.nvim",
  "nvim-lspconfig",
  "mason.nvim",
  "mason-lspconfig.nvim",
  "mason-tool-installer.nvim",
  "conform.nvim",
  "LuaSnip",
  "blink.cmp",
  "nvim-treesitter",
}

local missing_plugin = false
for _, plugin in ipairs(required_plugins) do
  if vim.fn.isdirectory(vim.fn.stdpath("data") .. "/site/pack/packer/start/" .. plugin) == 0 then
    missing_plugin = true
    break
  end
end

if missing_plugin then
  vim.schedule(function()
    vim.notify("Run :PackerSync to install Neovim plugins.", vim.log.levels.WARN)
  end)
  return
end

require("plugins.ui")
require("plugins.undotree")
require("plugins.telescope")
require("plugins.lsp")
require("plugins.formatting")
require("plugins.completion")
require("plugins.treesitter")
