local home = assert(vim.uv.os_homedir())

local obsidian_vaults = {
  personal = home .. '/vaults/jamesamo',
  work = home .. '/vaults/work',
}

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
  version = '*',
  ft = 'markdown',
  event = (function()
    local events = {}
    for _, path in pairs(obsidian_vaults) do
      table.insert(events, 'BufReadPre ' .. path .. '/*.md')
      table.insert(events, 'BufNewFile ' .. path .. '/*.md')
    end
    return events
  end)(),
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  cmd = {
    'ObsidianBacklinks',
    'ObsidianDailies',
    'ObsidianExtractNote',
    'ObsidianFollowLink',
    'ObsidianLink',
    'ObsidianLinkNew',
    'ObsidianLinks',
    'ObsidianNew',
    'ObsidianOpen',
    'ObsidianPasteImg',
    'ObsidianQuickSwitch',
    'ObsidianRename',
    'ObsidianSearch',
    'ObsidianTags',
    'ObsidianTemplate',
    'ObsidianTitles',
    'ObsidianToday',
    'ObsidianTomorrow',
    'ObsidianWorkspace',
    'ObsidianYesterday',
  },

  opts = function()
    local workspaces = {}
    for name, path in pairs(obsidian_vaults) do
      table.insert(workspaces, { name = name, path = path })
    end

    return {
      workspaces = workspaces,
      completion = {
        nvim_cmp = false,
        blink = true,
        -- Trigger completion at 2 chars.
        min_chars = 2,
      },
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
      daily_notes = {
        folder = 'Periodic/Days',
        date_format = '%Y/%Y-%m/%Y-%m-%d',
        -- Optional, if you want to change the date format for the ID of daily notes.
        -- date_format = "%Y-%m-%d",
        -- Optional, if you want to change the date format of the default alias of daily notes.
        -- alias_format = "%B %-d, %Y",
        template = 'note.md',
      },

      notes_subdir = 'inbox',
      new_notes_location = 'notes_subdir',
      disable_frontmatter = true,

      -- Optional, for templates (see below).
      templates = {
        subdir = 'templates',
        date_format = '%Y-%m-%d-%a',
        time_format = '%H:%M',
        substitutions = {
          yesterday = function()
            return os.date('%Y-%m-%d', journal_date_or_now() - 86400)
          end,
          tomorrow = function()
            return os.date('%Y-%m-%d', journal_date_or_now() + 86400)
          end,
          yesterday_journal = function()
            return os.date('Journal/%Y/%Y-%m/%Y-%m-%d', journal_date_or_now() - 86400)
          end,
          tomorrow_journal = function()
            return os.date('Journal/%Y/%Y-%m/%Y-%m-%d', journal_date_or_now() + 86400)
          end,
          month_abbr = function()
            return os.date('%b', journal_date_or_now())
          end,
          month = function()
            return os.date('%B', journal_date_or_now())
          end,
          year = function()
            return os.date('%Y', journal_date_or_now())
          end,
          weekday = function()
            return os.date('%A', journal_date_or_now())
          end,
          today_human = function()
            return os.date('%A, %B %d', journal_date_or_now())
          end,
          tomorrow_human = function()
            return os.date('%A, %B %d', journal_date_or_now() + 86400)
          end,
          yesterday_human = function()
            return os.date('%A, %B %d', journal_date_or_now() - 86400)
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
        checkboxes = {
          -- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
          -- [' '] = { char = '󰄱', hl_group = 'ObsidianTodo' },
          -- ['x'] = { char = '', hl_group = 'ObsidianDone' },
          -- ['>'] = { char = '', hl_group = 'ObsidianRightArrow' },
          -- ['~'] = { char = '󰰱', hl_group = 'ObsidianTilde' },
          -- Replace the above with this if you don't have a patched font:
          -- [" "] = { char = "☐", hl_group = "ObsidianTodo" },
          -- ["x"] = { char = "✔", hl_group = "ObsidianDone" },

          -- You can also add more custom ones...
        },
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
      mappings = {
        -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
        ['gf'] = {
          action = function()
            return require('obsidian').util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        ['<C-]>'] = {
          action = function()
            return require('obsidian').util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        -- Toggle check-boxes.
        ['<leader>cb'] = {
          action = function()
            return require('obsidian').util.toggle_checkbox()
          end,
          opts = { buffer = true },
        },
        -- Smart action depending on context, either follow link or toggle checkbox.
        ['<leader>cs'] = {
          action = function()
            return require('obsidian').util.smart_action()
          end,
          opts = { buffer = true, expr = true },
        },
      },
      attachments = {
        img_folder = 'Files',
      },
    }
  end,

  keys = {
    { '<leader>oo', ':cd /Users/jamesamo/vaults<cr>', desc = 'Open parent directory' },
    { '<leader>on', ':ObsidianTemplate note<cr> :lua vim.cmd([[1,/^\\S/s/^\\n\\{1,}//]])<cr>', desc = 'New Note' },
    -- { '<leader>of', ':s/\\(# \\)[^_]*_/\\1/ | s/-/ /g<cr>', desc = 'Fix Headers' },
    -- { '<leader>no', '<cmd>ObsidianOpen<cr>', desc = 'Open Obsidian' },
    -- { '<leader>nn', '<cmd>ObsidianNew<cr>', desc = 'New note' },
    { '<leader>os', '<cmd>ObsidianSearch<cr>', desc = 'Search notes' },
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
    -- vim.cmd.delcommand('Rename')
    -- vim.cmd.cabbrev({ 'Rename', 'ObsidianRename' })
    vim.cmd.cabbrev({ 'Today', 'ObsidianToday' })
    vim.cmd.cabbrev({ 'Yesterday', 'ObsidianYesterday' })
    vim.cmd.cabbrev({ 'Tomorrow', 'ObsidianTomorrow' })
    vim.cmd.cabbrev({ 'Daily', 'ObsidianTemplate JournalNvim' })

    vim.keymap.set(
      'n',
      '<C-c>',
      '<Cmd>ObsidianToggleCheckbox<CR>',
      { noremap = true, desc = '(Obsidian)Toggle checkbox' }
    )
  end,
}
