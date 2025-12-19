-- https://github.com/d7omdev/nvim/blob/master/lua/plugins/codecompanion.lua

return {
  interaction = 'chat',
  description = 'Fix the LSP diagnostics',
  opts = {
    default_prompt = true,
    alias = 'lsp-fix',
    modes = { 'n', 'v' },
    slash_cmd = 'lsp-fix',
    auto_submit = true,
    user_prompt = false,
    stop_context_insertion = true,
  },
  prompts = {
    {
      role = 'system',
      content = [[You are a skilled developer who helps fix LSP diagnostics. Use the buffer context and provide solutions with code snippets where necessary.]],
      opts = {
        visible = false,
      },
    },
    {
      role = 'system',
      content = function(context)
        -- Get diagnostics for the current line
        local diagnostics = require('codecompanion.helpers.actions').get_diagnostics(
          context.start_line,
          context.start_line, -- Target the current line
          context.bufnr
        )

        local diagnostic_message = diagnostics[1] and diagnostics[1].message or 'No diagnostics found'

        -- Include the buffer using the `#buffer` variable
        return 'Diagnostic message: '
          .. diagnostic_message
          .. '\n\nHere is the buffer context:\n'
          .. '#buffer:'
          .. context.start_line - 5
          .. '-'
          .. context.start_line + 5
      end,
      opts = {
        contains_code = true,
      },
    },
  },
}
