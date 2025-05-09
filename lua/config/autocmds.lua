local function augroup(name)
  return vim.api.nvim_create_augroup('jarmex_neovim_' .. name, { clear = true })
end

vim.api.nvim_create_autocmd({ 'TextYankPost' }, {
  group = augroup('general_settings'),
  pattern = '*',
  desc = 'Highlight text on yank',
  callback = function()
    vim.highlight.on_yank({ higroup = 'Visual', timeout = 200 })
    vim.highlight.on_yank({ higroup = 'Search', timeout = 100 })
  end,
})

-- -- resize splits if window got resized
-- vim.api.nvim_create_autocmd({ 'VimResized' }, {
--   group = augroup('resize_splits'),
--   callback = function()
--     local current_tab = vim.fn.tabpagenr()
--     vim.cmd('tabdo wincmd =')
--     vim.cmd('tabnext ' .. current_tab)
--   end,
-- })

vim.api.nvim_create_autocmd({ 'FileType' }, {
  group = augroup('filetype_settings'),
  pattern = { 'lua' },
  desc = 'fix gf functionality inside .lua files',
  callback = function()
    ---@diagnostic disable: assign-type-mismatch
    -- credit: https://github.com/sam4llis/nvim-lua-gf
    vim.opt_local.include = [[\v<((do|load)file|require|reload)[^''"]*[''"]\zs[^''"]+]]
    vim.opt_local.includeexpr = "substitute(v:fname,'\\.','/','g')"
    vim.opt_local.suffixesadd:prepend('.lua')
    vim.opt_local.suffixesadd:prepend('init.lua')

    for _, path in pairs(vim.api.nvim_list_runtime_paths()) do
      vim.opt_local.path:append(path .. '/lua')
    end
  end,
})

vim.api.nvim_create_autocmd({ 'FileType' }, {
  group = augroup('buffer_mappings'),
  pattern = {
    'spectre_panel',
    'qf',
    'help',
    'man',
    'floaterm',
    'lspinfo',
    'lir',
    'lsp-installer',
    'null-ls-info',
    'tsplayground',
    'DressingSelect',
    'Jaq',
    'neotest-output',
    'neotest-summary',
    'OverseerList',
    'dropbar_menu',
  },
  callback = function()
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = true })
    vim.opt_local.buflisted = false
  end,
})

vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '.env',
  group = augroup('__env'),
  callback = function(args)
    vim.diagnostic.enable(false, { bufnr = args.buf })
  end,
})

-- vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
--   pattern = '*.graphql,*.graphqls,*.gql',
--   callback = function()
--     vim.bo.filetype = 'graphql'
--   end,
--   once = false,
-- })

-- Define local variables
local autocmd = vim.api.nvim_create_autocmd

-- Check for spelling in text filetypes and enable wrapping, and set gj and gk keymaps
autocmd('FileType', {
  group = augroup('set_wrap'),
  pattern = {
    'gitcommit',
    'markdown',
    'text',
    'html',
    'plaintex',
  },
  desc = 'setlocal wrap and spell',
  callback = function()
    local opts = { noremap = true, silent = true }
    vim.opt_local.spell = true
    vim.opt_local.wrap = true
    vim.api.nvim_buf_set_keymap(0, 'n', 'j', 'gj', opts)
    vim.api.nvim_buf_set_keymap(0, 'n', 'k', 'gk', opts)
  end,
})
-- local mapfile = " "

-- Set up the autocommand for NeotestOutput filetype
-- Scroll to the bottom of the output panel
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'neotest-output-panel',
  group = vim.api.nvim_create_augroup('neotest-scroll', { clear = true }),
  callback = function()
    vim.cmd('norm G')
  end,
})

-- Set up the autocommand for TS filetype
-- Add missing imports and remove unused imports
vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('ts_fix_imports', { clear = true }),
  desc = 'Add missing imports and remove unused imports for TS',
  pattern = { '*.ts', '*.tsx', '*.js', '*.jsx' },
  callback = function(args)
    vim.cmd('TSToolsAddMissingImports sync')
    vim.cmd('TSToolsRemoveUnusedImports sync')
    if package.loaded['conform'] then
      require('conform').format({ bufnr = args.buf })
    end
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'go', 'gomod', 'gowork' },
  callback = function()
    -- set go specific options
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.colorcolumn = '120'
  end,
})

--------------------------------------------------------------------------------

-- AUTO-CLEANUP
vim.api.nvim_create_autocmd('FocusLost', {
  desc = 'User: Auto-cleanup. Once a week, on first `FocusLost`, delete older files.',
  once = true,
  callback = function()
    if os.date('%a') ~= 'Mon' or jit.os == 'windows' then
      return
    end
    vim.system({ 'find', vim.o.undodir, '-mtime', '+15d', '-delete' })
    vim.system({ 'find', vim.lsp.log.get_filename(), '-size', '+50M', '-delete' })
  end,
})

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- ADD NOTIFICATION TO LSP RENAME
local originalRenameHandler = vim.lsp.handlers['textDocument/rename']
vim.lsp.handlers['textDocument/rename'] = function(err, result, ctx, config)
  originalRenameHandler(err, result, ctx, config)
  if err or not result then
    return
  end

  -- count changes
  local changes = result.changes or result.documentChanges or {}
  local changedFiles = vim
    .iter(vim.tbl_keys(changes))
    :filter(function(file)
      return #changes[file] > 0
    end)
    :map(function(file)
      return '- ' .. vim.fs.basename(file)
    end)
    :totable()
  local changeCount = vim.iter(changes):fold(0, function(sum, _, change)
    return sum + #(change.edits or change)
  end)

  -- notification
  local pluralS = changeCount > 1 and 's' or ''
  local msg = ('[%d] instance%s'):format(changeCount, pluralS)
  if #changedFiles > 1 then
    local fileList = table.concat(changedFiles, '\n')
    msg = ('**%s in [%d] files**\n%s'):format(msg, #changedFiles, fileList)
  end
  vim.notify(msg, nil, { title = 'Renamed with LSP', icon = '󰑕' })

  -- save all
  if #changedFiles > 1 then
    vim.cmd('silent! wall')
  end
end
--------------------------------------------------------------------------------
