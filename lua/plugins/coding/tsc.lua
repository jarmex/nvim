return {
  'dmmulroy/tsc.nvim',
  ft = { 'typescript', 'typescriptreact' },
  enabled = false,
  opts = {
    auto_open_qflist = true,
    auto_close_qflist = true,
    auto_focus_qflist = false,
    auto_start_watch_mode = false,
    use_trouble_qflist = true,
    use_diagnostics = true,
    run_as_monorepo = false,
    enable_progress_notifications = false,
    enable_error_notifications = true,
    hide_progress_notifications_from_history = true,
    -- flags = {
    --   noEmit = true,
    --   watch = true,
    -- },
    -- bin_path = '~.bun/bin/tsgo',
    pretty_errors = false,
    -- bin_path = "~/.bun/bin/tsgo",
    flags = '--noEmit --pretty false', -- This just works
  },
}
