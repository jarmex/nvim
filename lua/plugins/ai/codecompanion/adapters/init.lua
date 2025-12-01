---@module "codecompanion"
---@type CodeCompanion.Config
return {
  http = require('plugins.ai.codecompanion.adapters.http'),
  acp = require('plugins.ai.codecompanion.adapters.acp'),
}
