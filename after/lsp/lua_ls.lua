return {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        special = { reload = 'require' },
      },
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
      },
      diagnostics = {
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
