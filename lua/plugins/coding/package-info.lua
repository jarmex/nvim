return {
  {
    'vuki656/package-info.nvim',
    event = { 'BufRead package.json' },
    dependencies = 'MunifTanjim/nui.nvim',
    opts = {
      autostart = false,
      hide_up_to_date = true,
      package_manager = 'pnpm',
      icons = {
        enable = true, -- Whether to display icons
        style = {
          up_to_date = '|  ', -- Icon for up to date dependencies
          outdated = '|  ', -- Icon for outdated dependencies
          invalid = '|  ', -- Icon for invalid dependencies
        },
      },
    },
    keys = {
      {
        '<leader>ni',
        '<cmd>lua require("package-info").show()<cr>',
        mode = { 'n' },
        desc = 'Show package info',
        silent = true,
        noremap = true,
      },
      {
        '<leader>np',
        '<cmd>lua require("package-info").change_version()<cr>',
        mode = { 'n' },
        desc = 'Change package version',
        silent = true,
        noremap = true,
      },
    },
  },
}
