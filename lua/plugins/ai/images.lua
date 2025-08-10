return {
  'HakonHarnes/img-clip.nvim',
  enabled = false,
  event = 'VeryLazy',
  cmd = { 'PasteImage' },
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
    { '<leader>#', '<cmd>PasteImage<cr>', desc = 'Paste image from system clipboard' },
    {
      '<leader>#/',
      function()
        Snacks.picker.files({
          ft = { 'jpg', 'jpeg', 'png', 'webp' },
          confirm = function(self, item, _)
            self:close()
            require('img-clip').paste_image({}, './' .. item.file) -- ./ is necessary for img-clip to recognize it as path
          end,
        })
      end,
      desc = 'Image',
    },
  },
}
