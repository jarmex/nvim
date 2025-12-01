local extras = [[
  When replying with code, the code must:
- Follow idiomatic patterns and current best practices for the language/framework
- Prefer functional programming patterns: small typed functions, currying/partial application
- Favor composition over inheritance, explicit over implicit
- Functions under 20 lines, max 3 levels nesting
- Extract complex logic into focused helper functions
- Early returns to reduce nesting
- Use current, well-maintained libraries and avoid deprecated patterns
- Use descriptive variable names and small named functions to make code read like English
- Minimal comments, only when non-idiomatic patterns are used and explanation is needed

Extra information:
- current project that you're working on: %s
- current operating system: %s
]]

---@type CodeCompanion.Config
return {
  opts = {
    -- system_prompt = require('plugins.ai.codecompanion.systemprompts.my-default').main_system_prompt(),
    ---@param ctx CodeCompanion.SystemPrompt.Context
    system_prompt = function(ctx)
      return ctx.default_system_prompt .. string.format(extras, ctx.project_root or ctx.cwd, ctx.os or 'unknown')
    end,
    send_code = true,
  },
}
