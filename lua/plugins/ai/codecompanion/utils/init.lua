local M = {}

function M.get_git_root()
  local result = vim.system({ 'git', 'rev-parse', '--show-toplevel' }, { text = true }):wait()
  local output = vim.split(vim.trim(result.stdout or ''), '\n', { plain = true })
  if result.code ~= 0 or not output[1] or output[1] == '' then
    return nil, 'Not inside a Git repository. Could not determine the project root.'
  end
  return output[1]
end

return M
