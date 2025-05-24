return {
  root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'selene.toml', 'selene.yml', '.git' },
  filetypes = { 'lua' },
  capabilities = Helpers.lsp.create_capabilities(),
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        special = { reload = 'require' },
      },
      telemetry = { enable = false },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.fn.expand('$VIMRUNTIME/lua'),
          vim.fn.expand('$VIMRUNTIME/lua/vim/lsp'),
          vim.fn.stdpath('data') .. '/lazy/lazy.nvim/lua/lazy',
        },
      },
      codeLens = {
        enable = true,
      },
      completion = {
        workspaceWord = true,
        callSnippet = 'Both',
        enable = true,
        showWord = 'Disable',
        autoRequire = true,
        displayContext = 2,
      },
      diagnostics = {
        disable = { 'missing-fields' },
        groupSeverity = {
          strong = 'Warning',
          strict = 'Warning',
        },
        groupFileStatus = {
          ['ambiguity'] = 'Opened',
          ['await'] = 'Opened',
          ['codestyle'] = 'None',
          ['duplicate'] = 'Opened',
          ['global'] = 'Opened',
          ['luadoc'] = 'Opened',
          ['redefined'] = 'Opened',
          ['strict'] = 'Opened',
          ['strong'] = 'Opened',
          ['type-check'] = 'Opened',
          ['unbalanced'] = 'Opened',
          ['unused'] = 'Opened',
        },
        unusedLocalExclude = { '_*' },
        globals = { 'vim' },
      },
      misc = {
        parameters = {
          '--log-level=trace',
        },
      },
      doc = {
        privateName = { '^_' },
      },
      hint = {
        enable = true, -- enabled inlay hints
        setType = false,
        paramType = true,
        paramName = 'Disable',
        semicolon = 'Disable',
        arrayIndex = 'Disable',
      },
    },
  },
}
