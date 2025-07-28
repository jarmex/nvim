local icons = require('helpers.icons')

local function on_attach(bufnr)
  local api = require('nvim-tree.api')
  local luv = vim.loop

  local function opts(desc)
    return {
      desc = 'nvim-tree: ' .. desc,
      buffer = bufnr,
      noremap = true,
      silent = true,
      nowait = true,
    }
  end
  local function add_reference(chat, path)
    local filemod = require('codecompanion.strategies.chat.slash_commands.file')
    local slash_command = filemod.new({
      Chat = chat,
      config = {},
      context = {},
      opts = {},
    })
    slash_command:output({
      path = path,
    })
  end

  -- Function to recursively add files in a directory to chat references
  local function traverse_directory(path, chat)
    local handle, err = luv.fs_scandir(path)
    if not handle then
      return print('Error scanning directory: ' .. err)
    end

    while true do
      local name, type = luv.fs_scandir_next(handle)
      if not name then
        break
      end

      local item_path = path .. '/' .. name
      if type == 'file' then
        -- add the file to references
        add_reference(chat, item_path)
      elseif type == 'directory' then
        -- recursive call for a subdirectory
        traverse_directory(item_path, chat)
      end
    end
  end
  -- Attach default mappings
  api.config.mappings.default_on_attach(bufnr)

  vim.keymap.set('n', 'Y', api.fs.copy.filename, opts('Copy Name'))
  vim.keymap.set('n', 'y', api.fs.copy.relative_path, opts('Copy Relative Path'))
  vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
  vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
  vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Close Directory'))
  vim.keymap.set('n', 'v', api.node.open.vertical, opts('Open: Vertical Split'))
  vim.keymap.set('n', 'o', api.node.open.horizontal, opts('Open: Horizontal Split'))
  vim.keymap.set('n', 'd', api.fs.trash, opts('Trash'))
  -- CodeCompanion integration
  vim.keymap.set('n', 'c', function()
    local node = api.tree.get_node_under_cursor()
    local path = node.absolute_path
    local codecompanion = require('codecompanion')
    local chat = codecompanion.last_chat()

    -- create chat if none exists
    if chat == nil then
      chat = codecompanion.chat()
    end

    local attr = luv.fs_stat(path)
    if attr and attr.type == 'directory' then
      -- Recursively traverse the directory
      traverse_directory(path, chat)
    else
      -- if already added, ignore
      -- for _, ref in ipairs(chat.refs) do
      --   if ref.path == path then
      --     return print('Already added')
      --   end
      -- end
      add_reference(chat, path)
    end
  end, { buffer = bufnr, desc = 'Add or Pin file to Chat' })
end

return {
  -- file explorer
  {
    'nvim-tree/nvim-tree.lua',
    -- lazy = false,
    event = 'UIEnter',
    keys = {
      { '<leader>e', '<cmd>NvimTreeToggle<cr>', desc = 'Nvim Tree' },
    },
    opts = {
      actions = { open_file = { quit_on_open = true } },
      diagnostics = {
        enable = true,
        icons = {
          hint = icons.diagnostics.Hint,
          info = icons.diagnostics.Information,
          warning = icons.diagnostics.Warning,
          error = icons.diagnostics.Error,
        },
        show_on_dirs = true,
      },
      disable_netrw = true,
      filters = { dotfiles = true, custom = { 'node_modules', '^.git$' } },
      live_filter = {
        prefix = '[FILTER]: ',
        always_show_folders = false, -- Turn into false from true by default
      },
      hijack_cursor = true,
      on_attach = on_attach,
      renderer = {
        add_trailing = false,
        group_empty = true,
        highlight_git = true,
        highlight_opened_files = 'none',
        root_folder_modifier = ':~',
        indent_markers = {
          enable = false,
          icons = { corner = icons.ui.Corner, edge = icons.ui.Edge, none = icons.ui.Edge },
        },
        icons = {
          webdev_colors = true,
          git_placement = 'before',
          padding = ' ',
          symlink_arrow = icons.ui.Arrow,
          show = { file = true, folder = true, folder_arrow = true, git = true },
          glyphs = {
            folder = icons.nvim_tree.folder,
          },
        },
        special_files = { 'Cargo.toml', 'Makefile', 'README.md', 'go.mod' },
      },
      select_prompts = true,
      update_focused_file = {
        enable = true,
        update_root = false,
        ignore_list = { 'fzf', 'help', 'git', 'snacks' },
      },
      view = {
        adaptive_size = true,
        width = 40,
        signcolumn = 'no',
      },
    },
    config = function(_, opts)
      local nvim_tree = require('nvim-tree')
      local Snacks = require('snacks')

      local prev = { new_name = '', old_name = '' } -- Prevents duplicate events
      vim.api.nvim_create_autocmd('User', {
        pattern = 'NvimTreeSetup',
        callback = function()
          local events = require('nvim-tree.api').events
          events.subscribe(events.Event.NodeRenamed, function(data)
            if prev.new_name ~= data.new_name or prev.old_name ~= data.old_name then
              data = data
              Snacks.rename.on_rename_file(data.old_name, data.new_name)
            end
          end)
        end,
      })

      nvim_tree.setup(opts)
    end,
  },
}
