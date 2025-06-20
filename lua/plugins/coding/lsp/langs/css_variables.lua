-- DOCS https://github.com/vunguyentuan/vscode-css-variables
--------------------------------------------------------------------------------

return {
  -- Add `biome.jsonc` as root marker for Obsidian snippet folders
  root_markers = { 'biome.jsonc', '.git', 'package.json' },
  filetypes = { 'css', 'scss', 'less' },
  settings = {
    cssVariables = {
      lookupFiles = { '**/*.less', '**/*.scss', '**/*.sass', '**/*.css' },
      blacklistFolders = {
        '**/.cache',
        '**/.DS_Store',
        '**/.git',
        '**/.hg',
        '**/.next',
        '**/.svn',
        '**/bower_components',
        '**/CVS',
        '**/dist',
        '**/node_modules',
        '**/tests',
        '**/tmp',
      },
    },
  },
}
