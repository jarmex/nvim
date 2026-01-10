---@module "lazy"

local api = vim.api
local fn = vim.fn

--- Jump to the next/previous fold
---@param direction 1|-1 `1` for next, `-1` for previous
---@param opts? {loop: boolean} whether to search from the other end when reaching top/bottom.
local function jump_to_fold(direction, opts)
  assert(math.abs(direction) == 1, 'direction should be 1 or -1.')

  opts = vim.tbl_deep_extend('force', { loop = true }, opts or {})
  return function()
    local curr_pos = fn.getpos('.')

    local line_count = api.nvim_buf_line_count(curr_pos[1])
    local curr_line = curr_pos[2]

    if fn.foldclosed(curr_line) ~= -1 then
      -- already in a fold. start the check from outside of the check
      if direction == 1 then
        curr_line = fn.foldclosedend(curr_line) + 1
      else
        curr_line = fn.foldclosed(curr_line) - 1
      end
    end

    -- make sure the while loop always stops
    local seen_lines = 0

    while seen_lines <= line_count do
      curr_line = curr_line + direction
      if fn.foldclosed(curr_line) ~= -1 then
        curr_pos[2] = curr_line
        return fn.setpos('.', curr_pos)
      end

      seen_lines = seen_lines + 1

      if opts.loop then
        if direction == 1 and curr_line == line_count then
          curr_line = 0
        elseif direction == -1 and curr_line == 1 then
          curr_line = line_count + 1
        end
      end
    end
    return vim.notify('No more folds.')
  end
end
---@type LazySpec[]
return {
  {
    'chrisgrieser/nvim-origami',
    event = 'VeryLazy',
    init = function()
      vim.opt.foldlevel = 99 -- disable vim's auto-fold
      vim.opt.foldlevelstart = 99
    end,
    ---@module "origami"
    ---@type Origami.config
    opts = {
      foldtext = { enabled = true, padding = 2, lineCount = { template = '󰘖 %d' } },
      useLspFoldsWithTreesitterFallback = { enabled = true },
      pauseFoldsOnSearch = true,
      autoFold = { enabled = true },
      foldKeymaps = { enabled = true },
    },
    keys = {
      {
        '[z',
        jump_to_fold(-1),
        mode = 'n',
        desc = 'Previous fold',
        noremap = true,
      },
      {
        ']z',
        jump_to_fold(1),
        mode = 'n',
        desc = 'Next fold',
        noremap = true,
      },
    },
  },
  -- folding fold area
  {
    'kevinhwang91/nvim-ufo',
    enabled = false,
    dependencies = { 'kevinhwang91/promise-async' },
    event = 'BufReadPost',
		-- stylua: ignore start
    keys = {
      { "zR", function() require("ufo").openFoldsExceptKinds {} end, desc = "󱃄 Open All Folds" },
      { "zM", function() require("ufo").closeAllFolds() end, },
      { "zr", function(...) require("ufo").openFoldsExceptKinds(...) end, },
      { "zm", function() require("ufo").closeAllFolds() end, desc = "󱃄 Close All Folds" },
      {
        'zk',
        function()
          local winid = require('ufo').peekFoldedLinesUnderCursor()
          if not winid then
            vim.lsp.buf.hover()
          end
        end,
        desc = "Preview fold or hover"
      },
      { "z1", function() require("ufo").closeFoldsWith(1) end, desc = "󱃄 Close L1 Folds" },
			{ "z2", function() require("ufo").closeFoldsWith(2) end, desc = "󱃄 Close L2 Folds" },
			{ "z3", function() require("ufo").closeFoldsWith(3) end, desc = "󱃄 Close L3 Folds" },
			{ "z4", function() require("ufo").closeFoldsWith(4) end, desc = "󱃄 Close L4 Folds" },
    },
    -- stylua: ignore end
    init = function()
      -- INFO fold commands usually change the foldlevel, which fixes folds, e.g.
      -- auto-closing them after leaving insert mode, however ufo does not seem to
      -- have equivalents for zr and zm because there is no saved fold level.
      -- Consequently, the vim-internal fold levels need to be disabled by setting
      -- them to 99.
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
    end,
    opts = function()
      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = ('  %d '):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, 'MoreMsg' })
        return newVirtText
      end
      return {
        open_fold_hl_timeout = 800,
        -- when opening the buffer, close these fold kinds
        -- use `:UfoInspect` to get available fold kinds from the LSP
        close_fold_kinds_for_ft = {
          default = { 'imports', 'comment' },
          json = { 'array' },
          c = { 'comment', 'region' },
        },
        preview = {
          win_config = {
            border = { '', '─', '', '', '', '─', '', '' },
            winhighlight = 'Normal:Folded',
            winblend = 0,
          },
          mappings = {
            scrollU = '<C-u>',
            scrollD = '<C-d>',
          },
        },
        provider_selector = function(_, ft, _)
          -- INFO some filetypes only allow indent, some only LSP, some only
          -- treesitter. However, ufo only accepts two kinds as priority,
          -- therefore making this function necessary :/
          local lspWithOutFolding = { 'markdown', 'sh', 'css', 'html', 'python', 'json' }
          if vim.tbl_contains(lspWithOutFolding, ft) then
            return { 'treesitter', 'indent' }
          end
          return { 'lsp', 'indent' }
        end,
        fold_virt_text_handler = handler,
      }
    end,
  },
}
