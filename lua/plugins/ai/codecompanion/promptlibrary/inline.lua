return {
  interaction = 'inline',
  description = 'The default inline with nice context',
  opts = {
    alias = 'inline',
    user_prompt = true,
    ignore_system_prompt = false,
    contains_code = true,
  },
  prompts = {
    {
      role = 'user',
      content = [[#buffer]],
    },
  },
  -- references = {
  --   {
  --     type = "file",
  --     path = ".github/copilot-instructions.md",
  --   },
  -- },
}
