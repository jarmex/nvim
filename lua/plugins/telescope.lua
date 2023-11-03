local helper = require("helper")
local settings = require("settings")
return {
  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    cmd = "Telescope",
    version = false, -- telescope did only one release, so use HEAD for now
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-symbols.nvim",
      "nvim-telescope/telescope-project.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "kkharji/sqlite.lua",
      "benfowler/telescope-luasnip.nvim",
      "nvim-telescope/telescope-frecency.nvim",
      {
        -- fuzzy finder
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
      {
        "debugloop/telescope-undo.nvim",
        config = function()
          require("telescope").load_extension("undo")
        end,
      },
    },
    keys = {
      { "<leader>fp", "<CMD>Telescope project display_type=full<CR>",                        desc = "Find project" },
      { "<leader>T",  "<cmd>Telescope<cr>",                                                  desc = "Open Telescope" },
      { "<leader>rr", "<cmd>Telescope resume<cr>",                                           desc = "Telescope Resume" },
      { "<leader>bb", "<cmd>Telescope buffers sort_mru=true ignore_current_buffer=true<cr>", desc = "Switch Buffer" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>",                                       desc = "Find Files" },
      { "<leader>fe", "<cmd>Telescope file_browser<cr>",                                     desc = "Browse Files" },
      { "<leader>fg", "<cmd>Telescope git_files<cr>",                                        desc = "Find Git Files" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>",                                         desc = "Recent" },
      { "<leader>:",  "<cmd>Telescope commands<cr>",                                         desc = "Commands" },
      { "<leader>fC", "<cmd>Telescope command_history<cr>",                                  desc = "Command History" },
      { "<leader>fM", "<cmd>Telescope man_pages<cr>",                                        desc = "Man Pages" },
      { "<leader>fa", "<cmd>Telescope autocommands<cr>",                                     desc = "Auto Commands" },
      { "<leader>fb", "<cmd>Telescope current_buffer_fuzzy_find<cr>",                        desc = "Buffer" },
      { "<leader>fl", "<cmd>Telescope symbols<cr>",                                          desc = "Symbols" },
      {
        "<leader>sg",
        "<cmd>Telescope live_grep<cr>",
        desc =
        "Find in Files (Grep)"
      },
      {
        "<leader>sG",
        helper.telescope("live_grep", { cwd = false }),
        desc =
        "Find in Files (Grep)"
      },
      {
        "<leader>sh",
        "<cmd>Telescope grep_string<cr>",
        desc =
        "Search word under cursor"
      },
      {
        "<leader>sH",
        helper.telescope("grep_string", { cwd = false }),
        desc =
        "Search word under cursor (cwd)"
      },
      { "<leader>fk", "<cmd>Telescope keymaps<cr>",                         desc = "Key Maps" },
      { "<leader>ft", "<cmd>Telescope builtin include_extensions=true<cr>", desc = "Telescope" },
      { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>",            desc = "Goto Symbol" },
      {
        "<leader>/",
        "<leader>sg",
        desc =
        "Find in Files (Grep)",
        remap = true
      },
      { "<leader>sW", helper.telescope("grep_string", { cwd = false }), desc = "Word (cwd)" },
    },
    opts = function()
      local actions = require("telescope.actions")
      return {
        defaults = {
          theme = "ivy",
          prompt_prefix = "~> ",
          preview = {
            filesize_limit = 1, -- in MB, do not preview big files for performance
            msg_bg_fillchar = " ",
          },
          selection_caret = " ",
          layout_strategy = "horizontal",
          layout_config = {
            prompt_position = "top",
          },
          selection_strategy = "reset",
          sorting_strategy = "ascending",
          scroll_strategy = "cycle",
          color_devicons = true,
          file_ignore_patterns = {
            "%.git/",
            "%.git$",        -- git dir in submodules
            "node_modules/", -- node
            "venv/",         -- python
            "%.app/",        -- internals of mac apps
            "%.pxd",         -- Pixelmator
            "%.plist",       -- Alfred
            "%.harpoon",     -- harpoon/projects
            "/INFO ",        -- custom info files
            "%.png",
            "%.gif",
            "%.jpe?g",
            "%.icns",
            "%.zip",
            "%.sqlite3",
            "%.svg",
            "%.otf",
            "%.ttf",
            "%.lock",
          },
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--trim", -- this added to trim results
          },
          -- sorting_strategy = 'ascending',
          mappings = {
            i = {
              ["<ESC>"] = actions.close,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<PageUp>"] = actions.results_scrolling_up,
              ["<PageDown>"] = actions.results_scrolling_down,
            },
            n = {
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<PageUp>"] = actions.results_scrolling_up,
              ["<PageDown>"] = actions.results_scrolling_down,
            },
          },
        },
        pickers = {
          buffers = {
            prompt_prefix = "﬘ ",
            ignore_current_buffer = true,
            sort_lastused = true,
            -- theme = "ivy",
            previewer = false,
            -- initial_mode = "normal",
            sort_mru = true,
            prompt_title = false,
            results_title = false,
            theme = "cursor",
            layout_config = { cursor = { width = 0.5 } },
          },
          git_files = {
            theme = "ivy",
          },
          find_files = {
            theme = "ivy",
            find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
          },
          grep_string = {
            theme = "ivy",
          },
          live_grep = {
            -- cwd = "%:p:h",
            prompt_title = "Search in Folder",
            theme = "ivy",
            prompt_prefix = settings.icons.ui.SearchIcon,
            -- @usage don't include the filename in the search results
            only_sort_text = true,
          },
        },
        extensions = {
          frecency = {
            show_scores = false,
            show_unindexed = false,
            ignore_patterns = {
              "*.git/*",
              "*/tmp/*",
              "*/node_modules/*",
              "*/vendor/*",
            },
          },
          project = {
            base_dirs = {
              '~/Projects'
            }
          },
          file_browser = {
            theme = "ivy",
            hijack_netrw = true,
            path = "%:p:h",
            cwd_to_path = true,
            path_display = { truncate = 3 },
            prompt_prefix = " ",
            depth = false,
            hidden = true,
            display_stat = false,
            git_status = false,
            group = true,
            hide_parent_dir = true,
            select_buffer = true,
            mappings = {
              i = {
                -- mappings should be consistent with nvim-ghengis mappings
                ["<D-n>"] = require("telescope._extensions.file_browser.actions").create,
                ["<C-r>"] = require("telescope._extensions.file_browser.actions").rename,
                ["<D-BS>"] = require("telescope._extensions.file_browser.actions").remove,
                ["<D-b>"] = require("telescope._extensions.file_browser.actions").toggle_browser,
              },
            },
          },
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
          },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("dap")
      telescope.load_extension("fzf")
      telescope.load_extension("project")
      telescope.load_extension("file_browser")
      telescope.load_extension("frecency")
    end
  },
}
