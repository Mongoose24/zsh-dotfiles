local packer = require("packer")

packer.init({
  compile_path = vim.fn.stdpath("config") .. "/plugin/packer_compiled.lua",
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "rounded" })
    end,
  },
})

packer.startup(function(use)
  use("wbthomason/packer.nvim")

  use("NMAC427/guess-indent.nvim")
  use("lewis6991/gitsigns.nvim")
  use("folke/which-key.nvim")
  use("catppuccin/nvim")
  use("nvim-lualine/lualine.nvim")
  use("folke/todo-comments.nvim")
  use("nvim-mini/mini.nvim")
  use("mbbill/undotree")

  use("nvim-lua/plenary.nvim")
  use("nvim-telescope/telescope.nvim")
  use("nvim-telescope/telescope-ui-select.nvim")
  use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })

  use("j-hui/fidget.nvim")
  use("neovim/nvim-lspconfig")
  use("mason-org/mason.nvim")
  use("mason-org/mason-lspconfig.nvim")
  use("WhoIsSethDaniel/mason-tool-installer.nvim")

  use("stevearc/conform.nvim")
  use({ "L3MON4D3/LuaSnip", run = "make install_jsregexp" })
  use({ "saghen/blink.cmp", branch = "v1" })
  use({ "nvim-treesitter/nvim-treesitter", branch = "main" })
end)
