---@class MySettings
local settings = {
  colors = {
    blue = "#61afef",
    green = "#98c379",
    red = "#e06c75",
    yellow = "#e5c07b",
  },
  icons = {
    diagnostics = {
      Error = " ",
      Warn = " ",
      Info = " ",
      Warning = " ",
      BoldHint = " ",
      Hint = "󰌶 ",
    },
    git = {
      added = " ",
      modified = " ",
      removed = " ",
      Git = "󰊢",
      GitAdd = "",
      GitBranch = "",
      GitChange = "",
      GitConflict = "",
      GitDelete = "",
      GitIgnored = "◌",
      GitRenamed = "➜",
      GitSign = "▎",
      GitStaged = "✓",
      GitUnstaged = "✗",
      GitUntracked = "★",
    },
    kinds = {
      Codeium = "",
      Array = " ",
      Boolean = " ",
      Class = " ",
      Color = " ",
      Constant = " ",
      Constructor = " ",
      Enum = " ",
      EnumMember = " ",
      Event = " ",
      Field = " ",
      File = " ",
      Folder = " ",
      Function = " ",
      Interface = " ",
      Key = " ",
      Keyword = " ",
      Method = " ",
      Module = " ",
      Namespace = " ",
      Null = "ﳠ ",
      Number = " ",
      Object = " ",
      Operator = " ",
      Package = " ",
      Property = " ",
      Reference = " ",
      Snippet = " ",
      String = " ",
      Struct = " ",
      Text = " ",
      TypeParameter = " ",
      Unit = " ",
      Value = " ",
      Variable = " ",
    },
    ui = {
      TargetOld = "󰀘",
      Target = "  ",
      ArrowLeft = "",
      ArrowRight = "",
      Bookmarks = "",
      BufferClose = "󰅖",
      FileReadOnly = "",
      FoldClosed = "",
      FoldOpened = "",
      FoldSeparator = " ",
      FolderClosed = "",
      FolderEmpty = "",
      FolderOpen = "",
      MacroRecording = "",
      Paste = "󰅌",
      Refresh = "",
      Search2 = "",
      Selected = "❯",
      Session = "󱂬",
      Sort = "󰒺",
      Spellcheck = "󰓆",
      Tab = "󰓩",
      TabClose = "󰅙",
      Terminal = "",
      Tree = "",
      Window = "",
      WordFile = "󰈭",
      DefaultFile = "󰈙",
      FileNew = "",
      FileModified = "",
      SearchResults = "󰅓",
      SearchIcon = "󱈆 ",
      ArrowCircleDown = "",
      ArrowCircleLeft = "",
      ArrowCircleRight = "",
      ArrowCircleUp = "",
      BoldArrowDown = "",
      BoldArrowLeft = "",
      BoldArrowRight = "",
      BoldArrowUp = "",
      BoldClose = "",
      BoldDividerLeft = "",
      BoldDividerRight = "",
      BoldLineLeft = "▎",
      BookMark = "",
      BoxChecked = "",
      Bug = "",
      Stacks = "",
      Scopes = "",
      Watches = "",
      DebugConsole = "",
      Calendar = "",
      Check = "",
      ChevronRight = ">",
      ChevronShortDown = "",
      ChevronShortLeft = "",
      ChevronShortRight = "",
      ChevronShortUp = "",
      Circle = "",
      Close = "",
      CloudDownload = "",
      Code = "",
      Comment = "",
      Dashboard = "",
      DividerLeft = "",
      DividerRight = "",
      DoubleChevronRight = "»",
      Ellipsis = "",
      EmptyFolder = "",
      EmptyFolderOpen = "",
      File = "",
      FileSymlink = "",
      Files = "",
      FindFile = "",
      FindText = "",
      Fire = "",
      Folder = "",
      FolderOpenSmall = "",
      FolderSymlink = "",
      Forward = "",
      Gear = "",
      History = "",
      Lightbulb = "",
      LineLeft = "▏",
      LineMiddle = "│",
      List = "",
      Lock = "",
      NewFile = "",
      Note = "",
      Package = "",
      Pencil = "",
      Plus = "",
      Project = "",
      Search = " ",
      SignIn = "",
      SignOut = "",
      Tab2 = "",
      Table = "",
      Target2 = "",
      Telescope = "",
      Text = "",
      Triangle = "契",
      TriangleShortArrowDown = "",
      TriangleShortArrowLeft = "",
      TriangleShortArrowRight = "",
      TriangleShortArrowUp = "",
    },
    lsp = {
      ActiveLSP = "",
      ActiveTS = " ",
      LSPLoaded = " ",
      LSPLoading1 = " ",
      LSPLoading2 = "󰀚 ",
      LSPLoading3 = " ",
    },
    dap = {
      DapBreakpoint = "",
      DapBreakpointCondition = "",
      DapBreakpointRejected = "",
      DapLogPoint = ".>",
      DapStopped = "󰁕", -- "",
      Debugger = "",
      Stopped = " ",
      Breakpoint = " ",
      BreakpointCondition = " ",
      LogPoint = "",
      Information = " ",
      BoldQuestion = "",
      Question = " ",
      Debug = " ",
      Trace = "✎ ",
      BreakpointRejected = " ",
      Diagnostic = "󰒡 ",
      DiagnosticError = "",
      DiagnosticHint = "󰌵",
      DiagnosticInfo = "󰋼 ",
      DiagnosticWarn = "",
    },
    testing = {
      Failed = "",
      Canceled = "",
      Success = "",
      Skipped = "",
      Running = "",
    },
  },
}

return settings
