--------------------------------------------------------------------------------
-- DIAGNOSTICS
--------------------------------------------------------------------------------
vim.diagnostic.config({
  signs = {
    text = { '', '▲', '●', '' }, -- Error, Warn, Info, Hint
  },
  virtual_text = {
    spacing = 2,
    severity = {
      min = vim.diagnostic.severity.WARN, -- leave out Info & Hint
    },
    format = function(diag)
      local msg = diag.message:gsub('%.$', '')
      return msg
    end,
    suffix = function(diag)
      if not diag then
        return ''
      end
      local codeOrSource = (tostring(diag.code or diag.source or ''))
      if codeOrSource == '' then
        return ''
      end
      return (' [%s]'):format(codeOrSource:gsub('%.$', ''))
    end,
  },
  float = {
    max_width = 70,
    header = '',
    prefix = function(_, _, total)
      return (total > 1 and '• ' or ''), 'Comment'
    end,
    suffix = function(diag)
      local source = (diag.source or ''):gsub(' ?%.$', '')
      local code = diag.code and ': ' .. diag.code or ''
      return ' ' .. source .. code, 'Comment'
    end,
    format = function(diag)
      local msg = diag.message:gsub('%.$', '')
      return msg
    end,
  },
})
