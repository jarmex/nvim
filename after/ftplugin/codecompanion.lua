vim.o.cursorline = false

local opts = { desc = 'Move by display line' }
vim.keymap.set({ 'n', 'v' }, 'j', 'gj', opts)
vim.keymap.set({ 'n', 'v' }, 'k', 'gk', opts)
-- vim.keymap.set({ 'n', 'v' }, '0', 'g0', { desc = 'Go to start of display line' })
-- vim.keymap.set({ 'n', 'v' }, '$', 'g$', { desc = 'Go to end of display line' })
