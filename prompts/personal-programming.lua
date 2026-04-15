-- from: https://github.com/3ZsForInsomnia/dotfiles/blob/main/neovim/.config/nvim/lua/config/prompts/personal-programming.lua
local prompt_dir = vim.fn.fnamemodify(debug.getinfo(1, 'S').source:sub(2), ':h')
local prompt_path = prompt_dir .. '/personal-programming.md'

local function read_prompt()
  local f = io.open(prompt_path, 'r')
  if not f then
    error('Could not read personal-programming.md at: ' .. prompt_path)
  end
  local content = f:read('*a')
  f:close()
  return content
end

return {
  prompt_path = prompt_path,
  main_prompt = read_prompt,
  selectable_prompt = {
    strategy = 'chat',
    description = 'Help me get shit done with (mostly) code',
    opts = { is_slash_cmd = true, auto_submit = false, short_name = 'personal_programming' },
    prompts = {
      {
        role = 'user',
        content = function()
          return read_prompt()
        end,
      },
    },
  },
}
