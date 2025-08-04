local day_format = '%A'
local date_format = '%Y-%m-%d'
local time_format = '%H:%M:%S'
local vault = {
  name = 'work',
  -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
  -- refer to `:h file-pattern` for more examples
  path = vim.fn.expand('~') .. '/vaults/jamesamo',
  -- Optional, override certain settings.
  overrides = {
    notes_subdir = 'notes',
  },
}

---If the current file is a journal, return the date of the journal as a timestamp
---Otherwise, return the current timestamp (os.time())
local journal_date_or_now = function()
  local file = vim.fn.expand('%')
  local match = vim.regex([[Journal/\d\{4}/\d\{4}-\d\{2}/\d\{4}-\d\{2\}-\d\{2}\.md$]]):match_str(file)
  if match == nil then
    return os.time()
  end
  local year, month, day = file:match('(%d+)-(%d+)-(%d+)')
  return os.time({ year = year, month = month, day = day })
end

return {
  -- 'epwalsh/obsidian.nvim',
  'obsidian-nvim/obsidian.nvim',
  enabled = true,
  lazy = true,
  version = '*',
  ft = 'markdown',
  event = vault.path and {
    ('BufReadPre %s/**.md'):format(vault.path),
    ('BufNewFile %s/**.md'):format(vault.path),
  } or nil,
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  cmd = 'Obsidian',
  -- cmd = {
  --   'ObsidianBacklinks',
  --   'ObsidianDailies',
  --   'ObsidianExtractNote',
  --   'ObsidianFollowLink',
  --   'ObsidianLink',
  --   'ObsidianLinkNew',
  --   'ObsidianLinks',
  --   'ObsidianNew',
  --   'ObsidianOpen',
  --   'ObsidianPasteImg',
  --   'ObsidianQuickSwitch',
  --   'ObsidianRename',
  --   'ObsidianSearch',
  --   'ObsidianTags',
  --   'ObsidianTemplate',
  --   'ObsidianTitles',
  --   'ObsidianToday',
  --   'ObsidianTomorrow',
  --   'ObsidianWorkspace',
  --   'ObsidianYesterday',
  -- },
  ---@type obsidian.config.ClientOpts|{}
  opts = {
    legacy_commands = false,
    checkbox = {
      order = { 'x', ' ' },
      create_new = false,
    },
    workspaces = { vault },

    -- optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
    ---@type obsidian.config.CompletionOpts|{}
    completion = {
      nvim_cmp = false,
      blink = true,
      -- Trigger completion at 2 chars.
      min_chars = 2,
    },

    -- optional, set preferred picker
    ---@type obsidian.config.PickerOpts|{}
    picker = {
      -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', 'mini.pick' or 'snacks.pick'.
      name = 'snacks.pick',
      -- Optional, configure key mappings for the picker. These are the defaults.
      -- Not all pickers support all mappings.
      note_mappings = {
        -- Create a new note from your query.
        new = '<C-x>',
        -- Insert a link to the selected note.
        insert_link = '<C-l>',
      },
      tag_mappings = {
        -- Add tag(s) to current note.
        tag_note = '<C-x>',
        -- Insert a tag at the current location.
        insert_tag = '<C-l>',
      },
    },

    footer = {
      enabled = false, -- turn it off
      -- separator = true, -- turn it off
      -- separator = "", -- insert a blank line
      format = 'words: {{words}}  ch: {{chars}}  props: {{properties}}  backlinks: {{backlinks}}',
      -- format = "({{backlinks}} backlinks)", -- limit to backlinks
      -- hl_group = "@property", -- Use another hl group
    },

    statusline = {
      format = 'words: {{words}}  ch: {{chars}}  props: {{properties}}  backlinks: {{backlinks}}',
    },

    ---@type obsidian.config.DailyNotesOpts|{}
    daily_notes = {
      folder = 'Periodic/Days',
      date_format = '%Y/%Y-%m/%Y-%m-%d',
      -- Optional, if you want to change the date format for the ID of daily notes.
      -- date_format = "%Y-%m-%d",
      -- Optional, if you want to change the date format of the default alias of daily notes.
      -- alias_format = "%B %-d, %Y",
      template = 'note.md',
      default_tags = { 'daily-notes' },
      -- Optional, if you want `Obsidian yesterday` to return the last work day or `Obsidian tomorrow` to return the next work day.
      workdays_only = false,
    },

    notes_subdir = 'inbox',
    new_notes_location = 'notes_subdir',
    disable_frontmatter = true,

    ---@type obsidian.config.TemplateOpts|{}
    templates = {
      subdir = 'templates',
      date_format = '%Y-%m-%d',
      time_format = '%H:%M',
      substitutions = {
        ['date:dddd'] = function()
          return tostring(os.date(day_format))
        end,
      },
    },

    follow_url_func = function(url)
      vim.fn.jobstart({ 'open', url })
    end,

    open = {
      func = function(uri)
        vim.ui.open(uri, { cmd = { 'open', '-a', '/Applications/Obsidian.app' } })
      end,
    },
    ui = {
      enable = false, -- set to false to disable all additional syntax features
      update_debounce = 200, -- update delay after a text change (in milliseconds)
      -- Define how various check-boxes are displayed
      bullets = {},
      external_link_icon = { char = '', hl_group = 'ObsidianExtLinkIcon' },
      -- Replace the above with this if you don't have a patched font:
      -- external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
      reference_text = { hl_group = 'ObsidianRefText' },
      highlight_text = { hl_group = 'ObsidianHighlightText' },
      tags = { hl_group = 'ObsidianTag' },
      hl_groups = {
        -- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
        ObsidianTodo = { bold = true, fg = '#f78c6c' },
        ObsidianDone = { bold = true, fg = '#89ddff' },
        ObsidianRightArrow = { bold = true, fg = '#f78c6c' },
        ObsidianTilde = { bold = true, fg = '#ff5370' },
        ObsidianRefText = { underline = true, fg = '#c792ea' },
        ObsidianExtLinkIcon = { fg = '#c792ea' },
        ObsidianTag = { italic = true, fg = '#89ddff' },
        ObsidianHighlightText = { bg = '#75662e' },
      },
    },
    attachments = {
      confirm_img_paste = false,
      img_text_func = function(client, path)
        path = client:vault_relative_path(path) or path
        local path_string = vim.uri_encode(vim.fs.basename(tostring(path)))
        return string.format('![%s](%s)', path.name, path_string)
      end,
      -- The default folder to place images in via `:ObsidianPasteImg`.
      -- If this is a relative path it will be interpreted as relative to the vault root.
      -- You can always override this per image by passing a full path to the command instead of just a filename.
      img_folder = 'Assets', -- This is the default
    },
  },

  keys = {
    -- { '<leader>oo', ':cd /Users/jamesamo/vaults<cr>', desc = 'Open parent directory' },
    { '<leader>on', ':Obsidian template note<cr> :lua vim.cmd([[1,/^\\S/s/^\\n\\{1,}//]])<cr>', desc = 'New Note' },
    -- { '<leader>of', ':s/\\(# \\)[^_]*_/\\1/ | s/-/ /g<cr>', desc = 'Fix Headers' },
    -- { '<leader>no', '<cmd>ObsidianOpen<cr>', desc = 'Open Obsidian' },
    -- { '<leader>nn', '<cmd>ObsidianNew<cr>', desc = 'New note' },
    { '<leader>os', '<cmd>Obsidian search<cr>', desc = 'Search notes' },
    -- { '<leader>nt', '<cmd>ObsidianTags<cr>', desc = 'List notes by tags' },
    -- { '<leader>nq', '<cmd>ObsidianQuickSwitch<cr>', desc = 'Quick switch in obsidian workspace' },
    -- { '<leader>nw', '<cmd>ObsidianWorkspace work<cr>', desc = 'Change to workspace work in obsidian' },
    -- { '<leader>np', '<cmd>ObsidianWorkspace personal<cr>', desc = 'Change to workspace home in obsidian' },
  },

  config = function(_, opts)
    require('obsidian').setup(opts)
    vim.keymap.set('n', 'gd', function()
      if require('obsidian').util.cursor_on_markdown_link() then
        return '<cmd>ObsidianFollowLink<CR>'
      else
        return 'gd'
      end
    end, { noremap = false, expr = true })

    vim.keymap.set(
      'n',
      '<C-space>',
      '<Cmd>Obsidian toggle_checkbox<CR>',
      { noremap = true, desc = '(Obsidian)Toggle checkbox' }
    )
  end,
}
