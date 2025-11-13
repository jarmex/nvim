local config = require('codecompanion.config')

local Variable = {}

function Variable.new(args)
  local self = setmetatable({

    Chat = args.Chat,

    config = args.config,

    params = args.params,
  }, { __index = Variable })

  return self
end

---Return all of the visible lines in the editor's viewport

---@return nil

function Variable:output()
  local diff = vim.fn.system('git diff --cached')

  diff = string.format('```diff\n%s\n```', diff)

  self.Chat:add_message({

    role = config.constants.USER_ROLE,

    content = diff,
  }, { tag = 'variable', visible = true })
end

return Variable
