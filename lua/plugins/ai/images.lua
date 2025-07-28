return {
  'HakonHarnes/img-clip.nvim',
  enabled = false,
  event = 'VeryLazy',
  cmd = 'PasteImage',
  opts = {
    filetypes = {
      codecompanion = {
        prompt_for_file_name = false,
        template = '[Image]($FILE_PATH)',
        use_absolute_path = true,
      },
      markdown = {
        relative_to_current_file = true,
      },
    },
  },
  keys = {
    -- suggested keymap
    { '<leader>pp', '<cmd>PasteImage<cr>', desc = 'Paste image from system clipboard' },
  },
}
