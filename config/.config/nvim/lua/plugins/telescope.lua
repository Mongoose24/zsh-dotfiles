local telescope = require("telescope")
telescope.setup({
  extensions = {
    ["ui-select"] = { require("telescope.themes").get_dropdown() },
  },
})

pcall(telescope.load_extension, "fzf")
pcall(telescope.load_extension, "ui-select")

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
  group = vim.api.nvim_create_augroup("telescope-lsp-attach", { clear = true }),
  callback = function(event)
    local opts = { buffer = event.buf }
    map("n", "grr", builtin.lsp_references, vim.tbl_extend("force", opts, { desc = "Goto references" }))
    map("n", "gri", builtin.lsp_implementations, vim.tbl_extend("force", opts, { desc = "Goto implementation" }))
    map("n", "grd", builtin.lsp_definitions, vim.tbl_extend("force", opts, { desc = "Goto definition" }))
    map("n", "gO", builtin.lsp_document_symbols, vim.tbl_extend("force", opts, { desc = "Document symbols" }))
    map("n", "gW", builtin.lsp_dynamic_workspace_symbols, vim.tbl_extend("force", opts, { desc = "Workspace symbols" }))
    map("n", "grt", builtin.lsp_type_definitions, vim.tbl_extend("force", opts, { desc = "Goto type definition" }))
  end,
})
