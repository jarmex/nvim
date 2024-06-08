vim.opt_local.commentstring = "//%s"
vim.opt_local.expandtab = false
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.tabstop = 4

vim.keymap.set("n", "<space>td", "<cmd>GoDebug -t<CR>", { buffer = 0 })
