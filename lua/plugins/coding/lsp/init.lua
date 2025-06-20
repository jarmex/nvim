---@diagnostic disable: need-check-nil
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

local function disable_global_keymaps()
  for _, bind in ipairs({ 'grn', 'gra', 'gri', 'grr' }) do
    pcall(vim.keymap.del, 'n', bind)
  end
end

return {
  'neovim/nvim-lspconfig',
  lazy = false,
  event = { 'BufReadPost', 'BufNewFile', 'BufWritePre' }, -- "BufReadPre",
  dependencies = {
    { 'saghen/blink.cmp', enabled = vim.g.cmploader == 'blink.cmp' },
    { 'b0o/SchemaStore.nvim', lazy = true, version = false },
  },
  config = function()
    local default_server_config = {
      flags = { debounce_text_changes = 150 },
      single_file_support = true,
    }

    vim.lsp.config('*', default_server_config)

    require('lspconfig.ui.windows').default_options.border = vim.g.borderStyle

    vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
      silent = true,
      border = vim.g.borderStyle,
    })

    vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
      border = vim.g.borderStyle,
    })

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
        require('plugins.coding.lsp.keymaps').keymap(bufnr)
        codelens(bufnr, client)
      end,
    })

    local servers = require('plugins.coding.lsp.langs').load_servers()
    for server, config in pairs(servers) do
      vim.lsp.config(server, config)
      vim.lsp.enable(server)
    end
  end,
}
