return {
  strategy = 'chat',
  description = 'Act as an expert Lua developer.',
  opts = {
    alias = 'lua_role',
    is_slash_cmd = true,
    auto_submit = false,
    ignore_system_prompt = true,
  },
  prompts = {
    {
      role = 'system',
      content = [[
You are an expert Lua developer.
Use a lua version that is compatible with the neovim editor (i.e 5.1).
When giving code examples show the generated output.]],

      opts = { visible = true },
    },
    {
      role = 'user',
      content = [[]],
    },
  },
}
