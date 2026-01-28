---@type vim.lsp.Config
return {
  settings = {
    cucumber = {
      glue = {
        -- DEFAULTS
        -- Cucumber-JVM
        'src/test/**/*.java',
        -- Cucumber-Js
        'features/**/*.ts',
        'features/**/*.tsx',
        'features/**/*.js',
        'features/**/*.jsx',
        'step-definitions/**/*.ts',
        -- TODO: Modify regex pattern to match `feature(s)`
        'test/feature/**/*.ts',
        'test/features/**/*.ts',
        -- Behat
        'features/**/*.php',
        -- Behave
        'features/**/*.py',
        -- Pytest-BDD
        'tests/**/*.py',
        -- Cucumber Rust
        'tests/**/*.rs',
        'features/**/*.rs',
        -- Cucumber-Ruby
        'features/**/*.rb',
        -- SpecFlow
        '*specs*/**/*.cs',
        -- Godog
        'features/**/*_test.go',
        -- MY SETTINGS
        -- TODO: Refactor directory structure of redstone-sidecar so tests aren't placed here, but in test/ instead
        'modules/**/*steps.ts',
      },
    },
  },
}
