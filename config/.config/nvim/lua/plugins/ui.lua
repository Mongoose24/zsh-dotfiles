require("guess-indent").setup({})

require("gitsigns").setup({
  signs = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
  },
})

require("which-key").setup({
  delay = 0,
  icons = { mappings = vim.g.have_nerd_font },
  spec = {
    { "<leader>s", group = "Search", mode = { "n", "v" } },
    { "<leader>t", group = "Toggle" },
    { "<leader>h", group = "Git hunk", mode = { "n", "v" } },
    { "gr", group = "LSP actions", mode = { "n" } },
  },
})

require("catppuccin").setup({
  flavour = "mocha",
  transparent_background = true,
  float = { transparent = true, solid = false },
  integrations = {
    fidget = true,
    mason = true,
    native_lsp = {
      enabled = true,
      virtual_text = {
        errors = { "italic" },
        hints = { "italic" },
        warnings = { "italic" },
        information = { "italic" },
      },
    },
    lualine = {},
    telescope = { enabled = true },
    which_key = true,
  },
})
vim.cmd.colorscheme("catppuccin")

require("todo-comments").setup({ signs = false })

if vim.g.have_nerd_font then
  require("mini.icons").setup()
  MiniIcons.mock_nvim_web_devicons()
end

require("mini.ai").setup({
  mappings = { around_next = "aa", inside_next = "ii" },
  n_lines = 500,
})
require("mini.surround").setup()

local catppuccin_colors = require("catppuccin.palettes").get_palette("mocha")
local lualine_theme = require("catppuccin.utils.lualine")("mocha")

for _, mode in ipairs({ "normal", "insert", "terminal", "command", "visual", "replace", "inactive" }) do
  for _, section in ipairs({ "b", "c" }) do
    if lualine_theme[mode] and lualine_theme[mode][section] then
      lualine_theme[mode][section].bg = catppuccin_colors.mantle
    end
  end
end

require("lualine").setup({
  options = {
    theme = lualine_theme,
    icons_enabled = vim.g.have_nerd_font,
    component_separators = "",
    section_separators = "",
    globalstatus = true,
  },
  sections = {
    lualine_a = { { "mode", icon = "" } },
    lualine_b = {
      { "branch", icon = "" },
      { "diff", symbols = { added = " ", modified = " ", removed = " " } },
      "diagnostics",
    },
    lualine_c = { { "filename", path = 1 } },
    lualine_x = {
      { "encoding", icon = "󰈙" },
      { "fileformat", icon = "" },
      "filetype",
    },
    lualine_y = { { "progress", icon = "󰦗" } },
    lualine_z = { { "location", icon = "󰍎" } },
  },
})
