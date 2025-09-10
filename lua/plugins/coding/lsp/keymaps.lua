---@diagnostic disable: need-check-nil

local isTsToolOk, typeScriptTools = pcall(require, 'typescript-tools.api')
local debounce = require('helpers.utils').debounce
local autocmd = vim.api.nvim_create_autocmd

local function codelens(bufnr, client)
  if client:supports_method('textDocument/codeLens') then
    vim.lsp.codelens.refresh({ bufnr = bufnr })
    autocmd({ 'FocusGained', 'WinEnter', 'BufEnter', 'InsertLeave' }, {
      group = vim.api.nvim_create_augroup('CodeLens', { clear = false }),
      buffer = bufnr,
      callback = debounce(500, function(args0)
        vim.lsp.codelens.refresh({ bufnr = args0.buf })
      end),
    })
  end
end

local function hover_action()
  local winid = require('ufo').peekFoldedLinesUnderCursor()
  if not winid then
    vim.lsp.buf.hover({ border = 'rounded' })
  end
end

local function diagnostic_goto(next, severity)
  local count = next and 1 or -1
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    vim.diagnostic.jump({ count = count, float = true, severity = severity, wrap = true })
  end
end

local function rename()
  if pcall(require, 'inc_rename') then
    vim.api.nvim_feedkeys(':IncRename ' .. vim.fn.expand('<cword>'), 'n', false)
  else
    vim.lsp.buf.rename()
  end
end

local go_to_definition = function()
  local ft = vim.api.nvim_get_option_value('filetype', { buf = 0 })
  if ft == 'man' then
    vim.api.nvim_command(':Man ' .. vim.fn.expand('<cWORD>'))
  elseif ft == 'help' then
    vim.api.nvim_command(':help ' .. vim.fn.expand('<cword>'))
  else
    Snacks.picker.lsp_definitions()
  end
end

local function keymap(_bufnr)
  local function map(lhs, rhs, opts, mode)
    mode = mode or 'n'
    opts = opts or {}
    opts.silent = opts.silent or true
    opts.noremap = true
    opts.buffer = true
    opts.desc = string.format('Lsp: %s', opts.desc)
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  map('K', hover_action, { desc = 'Hover', nowait = true })

  map('lf', function()
    Snacks.picker.diagnostics_buffer()
  end, { desc = 'Find Diagnostics', nowait = true })

  map('gd', go_to_definition, { desc = 'Go to definition' })

  map('gr', function()
    Snacks.picker.lsp_references()
  end, { desc = 'References', nowait = true })

  map('gi', function()
    Snacks.picker.lsp_implementations()
  end, { desc = 'Goto Implementation' })

  map('gy', function()
    Snacks.picker.lsp_type_definitions()
  end, { desc = 'Goto Type Definition' })

  map('gh', function()
    vim.lsp.buf.hover({ border = vim.g.borderStyle })
  end, { desc = 'Hover' })

  map('gK', vim.lsp.buf.signature_help, { desc = 'Signature Help' })

  map('gl', "<cmd>lua vim.diagnostic.open_float(0,{border='rounded'})<CR>", { desc = 'Show diagnostics' })

  -- map('[d', diagnostic_goto(true), { desc = 'Next Diagnostic' })
  -- map(']d', diagnostic_goto(false), { desc = 'Next Diagnostic' })
  -- map('<leader>cd', "<cmd>lua vim.diagnostic.open_float({source='if_many'})<cr>", { desc = 'Diagnostic' })

  map('<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', { desc = 'Set loclist' })

  map('<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', { desc = '[W]orkspace [A]dd Folder' })
  map('<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', { desc = '[W]orkspace [R]emove Folder' })

  -- if client.supports_method(methods.textDocument_codeAction) then
  map('<leader>ca', vim.lsp.buf.code_action, { desc = 'Code Actions' }, { 'n', 'v' })
  -- end

  map('<leader>cr', rename, { desc = '[R]ename' })
  map('<leader>rn', vim.lsp.buf.rename, { desc = '[R]ename' })

  map('<leader>ci', '<cmd>LspInfo<cr>', { desc = 'Lsp Info' })
  map('<leader>ch', vim.lsp.codelens.refresh, { desc = 'CodeLens Refresh' })
  map('<leader>cl', vim.lsp.codelens.run, { desc = '[C]ode[L]ens Run' })
  map('<leader>th', function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  end, { desc = 'Toggle inlay hints' })

  map('<leader>gD', vim.lsp.buf.declaration, { desc = '[G]oto [D]eclaration' })
  map('grD', vim.lsp.buf.declaration, { desc = '[G]oto [D]eclaration' })

  -- Copy the diagnostic message under your cursor to the clipboard
  map('<leader>cd', function()
    local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
    local diags = vim.diagnostic.get(0, { lnum = lnum })
    if #diags > 0 then
      local msg = diags[1].message
      vim.fn.setreg('+', msg)
      print('✔ Diagnostic copied: ' .. msg:gsub('\n.*', ' …'))
    else
      print('No diagnostic on this line')
    end
  end, { desc = '[C]opy [D]iagnostic under cursor' })

  --- TypeScript Tools
  if not isTsToolOk then
    return
  end
  map('gs', typeScriptTools.organize_imports, { desc = 'Organize imports' })
  map('gI', typeScriptTools.add_missing_imports, { desc = 'Add missing imports' })
end

local function disable_global_keymaps()
  for _, bind in ipairs({ 'grn', 'gra', 'gri', 'grr' }) do
    pcall(vim.keymap.del, 'n', bind)
  end
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true }),
  callback = function(ctx)
    disable_global_keymaps()

    local bufnr = ctx.buf

    local client = vim.lsp.get_client_by_id(ctx.data.client_id)
    assert(client, 'No client found')

    if client.name == 'copilot' then
      return
    end

    if client.name == 'gopls' then
      if not client.server_capabilities.semanticTokensProvider then
        local semantic = client.config.capabilities.textDocument.semanticTokens
        client.server_capabilities.semanticTokensProvider = {
          full = true,
          legend = {
            tokenTypes = semantic.tokenTypes,
            tokenModifiers = semantic.tokenModifiers,
          },
          range = true,
        }
      end
    end
    keymap(bufnr)
    codelens(bufnr, client)
  end,
})
