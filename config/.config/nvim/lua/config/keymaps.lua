vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic list" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move to the upper window" })
vim.keymap.set("x", "<C-S-c>", '"+y', { desc = "Copy selection to system clipboard" })
vim.keymap.set("x", "<LeftRelease>", '<LeftRelease>"+y', {
  desc = "Copy mouse selection to system clipboard",
})

local function exit_insert_mode()
  local insert_col = vim.fn.col(".")
  local line_end_col = vim.fn.col("$")

  vim.cmd("stopinsert")

  if insert_col > 1 and insert_col < line_end_col then
    vim.cmd("normal! l")
  end
end

vim.keymap.set("n", "<M-a>", "a", { desc = "Append in Insert mode" })
vim.keymap.set("i", "<M-a>", exit_insert_mode, { desc = "Return to Normal mode" })
vim.keymap.set("i", "<Esc>", exit_insert_mode, { desc = "Return to Normal mode" })

local function reject_arrow_key()
  vim.api.nvim_echo({ { "No arrows for you! Use h, j, k, or l.", "WarningMsg" } }, false, {})
end

for _, mode in ipairs({ "n", "v", "i" }) do
  for _, key in ipairs({ "<Left>", "<Down>", "<Up>", "<Right>" }) do
    vim.keymap.set(mode, key, reject_arrow_key, { desc = "Arrow keys disabled" })
  end
end

vim.diagnostic.config({
  update_in_insert = false,
  severity_sort = true,
  float = { border = "rounded", source = "if_many" },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },
  virtual_text = true,
  virtual_lines = false,
  jump = {
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float({
        bufnr = bufnr,
        scope = "cursor",
        focus = false,
      })
    end,
  },
})
