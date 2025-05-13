return {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl', 'gosum' },
  root_markers = { '.git', 'go.mod', 'go.sum' },
  settings = {
    -- main readme: https://github.com/golang/tools/blob/master/gopls/doc/features/README.md
    --
    -- for all options, see:
    -- https://github.com/golang/tools/blob/master/gopls/doc/vim.md
    -- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
    -- for more details, also see:
    -- https://github.com/golang/tools/blob/master/gopls/internal/settings/settings.go
    -- https://github.com/golang/tools/blob/master/gopls/README.md
    env = {
      GOEXPERIMENT = 'rangefunc',
    },
    gopls = {
      -- https://github.com/golang/tools/blob/master/gopls/internal/settings/settings.go
      gofumpt = false, -- handled by conform instead.
      codelenses = {
        gc_details = true, -- Show a code lens toggling the display of gc's choices.
        generate = true, -- show the `go generate` lens.
        regenerate_cgo = true,
        run_govulncheck = true,
        test = true,
        tidy = true,
        upgrade_dependency = true,
        vendor = true,
      },
      hints = { -- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      -- https://github.com/golang/tools/blob/master/gopls/doc/inlayHints.md
      -- check if this works?
      ['ui.inlayhint.hints'] = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeValuesTypes = true,
      },
      analyses = {
        fieldalignment = false,
        nilness = true,
        unusedparams = true,
        unusedwrite = true,
        useany = true,
        shadow = true,
        unusedvariable = true,
        fillreturns = true,
        nonewvars = true,
        undeclaredname = true,
        unreachable = true,
      },
      usePlaceholders = true,
      completeUnimported = true,
      directoryFilters = { '-**/node_modules', '-**/.git', '-.vscode', '-.idea', '-.vscode-test' },
      -- https://github.com/golang/tools/blob/master/gopls/internal/settings/settings.go
      semanticTokens = false, -- disabling this enables treesitter injections (for sql, json etc)
      symbolMatcher = 'fuzzy',
      buildFlags = { '-tags', 'integration' },
      diagnosticsDelay = '500ms',
      matcher = 'Fuzzy',

      -- diagnostic options
      -- https://github.com/golang/tools/blob/master/gopls/internal/settings/settings.go
      staticcheck = true,
      vulncheck = 'imports',
      analysisProgressReporting = true,
    },
  },
}
