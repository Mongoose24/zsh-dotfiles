vim.g.undotree_SetFocusWhenToggle = 1
vim.g.undotree_DiffAutoOpen = 1

vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<CR>", {
  desc = "Toggle UndoTree",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "undotree",
  callback = function(event)
    local previewing = false

    vim.api.nvim_create_autocmd("CursorMoved", {
      buffer = event.buf,
      callback = function()
        if previewing then
          return
        end

        previewing = true
        vim.schedule(function()
          if vim.api.nvim_buf_is_valid(event.buf) and vim.api.nvim_get_current_buf() == event.buf then
            vim.api.nvim_feedkeys(vim.keycode("<CR>"), "m", false)
          end
          previewing = false
        end)
      end,
    })
  end,
})
