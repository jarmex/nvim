local function keymap(modes, lhs, rhs, opts)
  if not opts then
    opts = {}
  end
  if opts.unique == nil then
    opts.unique = true
  end
  vim.keymap.set(modes, lhs, rhs, opts)
end

-- Better window movement
-- Move to window using the <ctrl> hjkl keys
keymap('n', '<C-h>', '<C-w>h', { desc = 'Go to left window', noremap = true, unique = false })
keymap('n', '<C-j>', '<C-w>j', { desc = 'Go to lower window', noremap = true, unique = false })
keymap('n', '<C-k>', '<C-w>k', { desc = 'Go to upper window', noremap = true, unique = false })
keymap('n', '<C-l>', '<C-w>l', { desc = 'Go to right window', noremap = true, unique = false })

vim.keymap.set('n', 'Y', 'y$', { remap = true })
-- Remap for dealing with word wrap
keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })
keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- Jump history
-- keymap('n', '<C-h>', '<C-o>', { desc = '󱋿 Jump back' })
-- keymap('n', '<C-l>', '<C-i>', { desc = '󱋿 Jump forward', unique = false })

-- Diagnostics
keymap('n', 'ge', ']d', { desc = '󰋼 Next diagnostic', remap = true })
keymap('n', 'gE', '[d', { desc = '󰋼 Previous diagnostic', remap = true })

-- Undo
keymap('n', 'u', '<cmd>silent undo<CR>zv', { desc = '󰜊 Silent undo' })
keymap('n', 'U', '<cmd>silent redo<CR>zv', { desc = '󰛒 Silent redo' })
keymap('n', '<leader>ue', ':earlier ', { desc = '󰜊 Undo to earlier' })

-- Spelling
keymap('n', 'z.', '1z=', { desc = '󰓆 Fix spelling' }) -- works even with `spell=false`

-- Better viewing
keymap('n', 'n', 'nzzzv')
keymap('n', 'N', 'Nzzzv')
keymap('n', 'g,', 'g,zvzz')
keymap('n', 'g;', 'g;zvzz')
keymap('n', 'J', 'mzJ`z')
-- keymap('n', '<C-d>', '<C-d>zz')
-- keymap('n', '<C-u>', '<C-u>zz')
keymap('n', '=ap', "ma=ap'a")
keymap('n', '<leader>zr', '<cmd>LspRestart<cr>')

-- Better indent
keymap('v', '<', '<gv')
keymap('v', '>', '>gv')

keymap('n', '<Leader>rw', ':%s/<c-r><c-w>//g<left><left>', { desc = 'Rename word under cursor' })
-- Paste over currently selected text without yanking it
-- keymap('v', 'p', '"_dP')
-- keymap('x', '<leader>p', [["_dP]])
keymap({ 'n', 'v' }, '<leader>y', [["+y]])
keymap('n', '<leader>Y', [["+Y]])

-- COMMAND & INSERT MODE
keymap({ 'i', 'c' }, '<C-a>', '<Home>')
-- keymap({ 'i', 'c' }, '<C-e>', '<End>')

-- navigation
keymap('i', '<M-Up>', '<C-\\><C-N><C-w>k')
keymap('i', '<M-Down>', '<C-\\><C-N><C-w>j')
keymap('i', '<M-Left>', '<C-\\><C-N><C-w>h')
keymap('i', '<M-Right>', '<C-\\><C-N><C-w>l')

-- Terminal Mappings
keymap('t', '<esc><esc>', '<c-\\><c-n>', { desc = 'Enter Normal Mode' })
keymap('t', '<C-h>', '<cmd>wincmd h<cr>', { desc = 'Go to left window' })
keymap('t', '<C-j>', '<cmd>wincmd j<cr>', { desc = 'Go to lower window' })
keymap('t', '<C-k>', '<cmd>wincmd k<cr>', { desc = 'Go to upper window' })
keymap('t', '<C-l>', '<cmd>wincmd l<cr>', { desc = 'Go to right window' })
keymap('t', '<C-/>', '<cmd>close<cr>', { desc = 'Hide Terminal' })
keymap('t', '<c-_>', '<cmd>close<cr>', { desc = 'which_key_ignore' })

-- Clear search with <esc>
keymap('n', '<leader><space>', ':nohlsearch<CR>', { desc = 'Clear hlsearch', nowait = true })
keymap({ 'n', 'i' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'Escape and clear hlsearch' })

-- buffers
keymap('n', '<leader>`', '<C-^>', { noremap = true, desc = 'Alternate buffers' })
keymap('n', '<leader>bo', '<cmd>b#<cr>', { desc = 'Switch to Other Buffer' })

-- lazy
keymap('n', '<leader>ll', '<cmd>Lazy<cr>', { desc = 'Lazy' })

-- windows
keymap('n', '<leader>ww', '<C-W>p', { desc = 'Other window', remap = true })
keymap('n', '<leader>wd', '<C-W>c', { desc = 'Delete window', remap = true })
keymap('n', '<leader>w-', '<C-W>s', { desc = 'Split window below', remap = true })
keymap('n', '<leader>w|', '<C-W>v', { desc = 'Split window right', remap = true })
-- keymap('n', '<leader>-', '<C-W>s', { desc = 'Split window below', remap = true })
-- keymap('n', '<leader>|', '<C-W>v', { desc = 'Split window right', remap = true })

keymap('x', 'K', ":m '<-2<CR>gv-gv")
keymap('x', 'J', ":m '>+1<CR>gv-gv")

-- OPTION TOGGLING
-- toggle inlay hints
-- keymap('n', '<leader>uh', function()
--   vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
-- end)

-- Resize windows using <ctrl> arrow keys
keymap('n', '<M-Up>', ':resize +2<CR>', { desc = 'Increase window height', silent = true })
keymap('n', '<M-Down>', ':resize -2<CR>', { desc = 'Decrease window height', silent = true })
keymap('n', '<M-Left>', ':vertical resize -2<CR>', { desc = 'Decrease window width', silent = true })
keymap('n', '<M-Right>', ':vertical resize +2<CR>', { desc = 'Increase window width', silent = true })

-- keymap('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })

-- Tabs
keymap('n', '<leader><tab>l', '<cmd>tablast<cr>', { desc = 'Last Tab' })
keymap('n', '<leader><tab>f', '<cmd>tabfirst<cr>', { desc = 'First Tab' })
keymap('n', '<leader><tab><tab>', '<cmd>tabnew<cr>', { desc = 'New Tab' })
keymap('n', '<leader><tab>]', '<cmd>tabnext<cr>', { desc = 'Next Tab' })
keymap('n', '<leader><tab>d', '<cmd>tabclose<cr>', { desc = 'Close Tab' })
keymap('n', '<leader><tab>[', '<cmd>tabprevious<cr>', { desc = 'Previous Tab' })
keymap('n', '[<tab>', '<cmd>tabprevious<cr>', { desc = 'Previous Tab', silent = true })
keymap('n', ']<tab>', '<cmd>tabnext<cr>', { desc = 'Next Tab', silent = true })

-- QUICKFIX
keymap('n', 'gq', '<cmd>silent cnext<CR>zv', { desc = '󰴩 Next quickfix' })
keymap('n', 'gQ', '<cmd>silent cprev<CR>zv', { desc = '󰴩 Prev quickfix' })
keymap('n', '<leader>qd', function()
  vim.cmd.cexpr('[]')
end, { desc = '󰚃 Delete qf-list' })

-- keymap('n', '<leader>qq', function()
--   local quickfixWinOpen = vim.fn.getqflist({ winid = true }).winid ~= 0
--   vim.cmd[quickfixWinOpen and 'cclose' or 'copen']()
-- end, { desc = ' Toggle quickfix window' })

-- -- FOLDING
-- keymap('n', 'zz', '<cmd>%foldclose<CR>', { desc = ' Close toplevel folds' })
-- keymap('n', 'zm', 'zM', { desc = ' Close all folds' })
-- keymap('n', 'zv', 'zv', { desc = '󰘖 Open until cursor visible' }) -- just for which-key
-- keymap('n', 'zr', 'zR', { desc = '󰘖 Open all folds' })
-- keymap('n', 'zo', 'zO', { desc = '󰘖 Open fold recursively' })
-- stylua: ignore
keymap("n", "zf", function() vim.opt.foldlevel = vim.v.count1 end, { desc = " Set fold level to {count}" })

-- keymap('n', '<leader>zs', function()
--   local modeline = vim.bo.commentstring:format('vim foldlevel=' .. vim.o.foldlevel)
--   vim.api.nvim_buf_set_lines(0, 0, 0, false, { modeline })
--   vim.api.nvim_win_set_cursor(0, { 1, #modeline })
-- end, { desc = '󰆓 Save foldlevel in modeline' })

-- keep the register clean
-- keymap({ 'n', 'x' }, 'x', '"_x')
-- keymap({ 'n', 'x' }, 'c', '"_c')
keymap('n', 'C', '"_C')
keymap('x', 'p', 'P')
keymap('n', 'dd', function()
  local lineEmpty = vim.trim(vim.api.nvim_get_current_line()) == ''
  return (lineEmpty and '"_dd' or 'dd')
end, { expr = true })

--------------------------------------------------------------------------------
-- LINE & CHARACTER MOVEMENT

keymap('n', '<Down>', [[<cmd>. move +1<CR>==]], { desc = '󰜮 Move line down' })
keymap('n', '<Up>', [[<cmd>. move -2<CR>==]], { desc = '󰜷 Move line up' })
keymap('n', '<Right>', [["zx"zp]], { desc = '➡️ Move char right' })
keymap('n', '<Left>', [["zdh"zph]], { desc = '⬅ Move char left' })
keymap('x', '<Up>', [[:move '<-2<CR>gv=gv]], { desc = '󰜷 Move selection up', silent = true })
keymap('x', '<Down>', [[:move '>+1<CR>gv=gv]], { desc = '󰜮 Move selection down', silent = true })
keymap('x', '<Right>', [["zx"zpgvlolo]], { desc = '➡️ Move selection right' })
keymap('x', '<left>', [["zxhh"zpgvhoho]], { desc = '⬅ Move selection left' })

--------------------------------------------------------------------------------
-- INSERT MODE
keymap('n', 'i', function()
  local lineEmpty = vim.trim(vim.api.nvim_get_current_line()) == ''
  return lineEmpty and '"_cc' or 'i'
end, { expr = true, desc = 'indented i on empty line' })

keymap('v', '<leader>64e', "c<c-r>=system('base64 --wrap=0',          @\")<cr><esc>", { desc = 'Base64 encode' })
keymap('v', '<leader>64d', "c<c-r>=system('base64 --wrap=0 --decode', @\")<cr><esc>", { desc = 'Base64 decode' })
