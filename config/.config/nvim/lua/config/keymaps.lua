vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic list" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move to the upper window" })

-- Migration-friendly terminal and mouse mappings.
vim.keymap.set("x", "<C-S-c>", '"+y', { desc = "Copy selection to system clipboard" })
vim.keymap.set("x", "<LeftRelease>", '<LeftRelease>"+y', {
	desc = "Copy mouse selection to system clipboard",
})
vim.keymap.set("n", "<M-a>", "i", { desc = "Enter Insert mode" })
vim.keymap.set("i", "<M-a>", "<Esc>", { desc = "Return to Normal mode" })

local function reject_arrow_key()
	vim.api.nvim_echo({ { "No arrows for you! Use h, j, k, or l.", "WarningMsg" } }, false, {})
end

for _, mode in ipairs({ "n", "v" }) do
	for _, key in ipairs({ "<Left>", "<Down>", "<Up>", "<Right>" }) do
		vim.keymap.set(mode, key, reject_arrow_key, { desc = "Arrow keys disabled" })
	end
end
