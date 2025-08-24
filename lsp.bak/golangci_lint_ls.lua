return {
  cmd = { 'golangci-lint-langserver' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  root_markers = { '.git', 'go.mod', 'go.sum', 'go.work' },
}
