-- Go build and test tasks
local files = require('overseer.files')

---@type overseer.TemplateDefinition
return {
  name = 'go',
  tags = { 'GO', 'BUILD', 'TEST' },
  condition = {
    callback = function(search)
      return files.exists(files.join(search.dir, 'go.mod'))
    end,
  },
  builder = function(params)
    local cmd = { 'go', params.subcommand }

    if params.subcommand == 'test' then
      vim.list_extend(cmd, { '-v', '-count=1' })
      if params.coverage then
        table.insert(cmd, '-coverprofile=coverage.out')
      end
      if params.race then
        table.insert(cmd, '-race')
      end
      if params.package ~= '' then
        table.insert(cmd, params.package)
      else
        table.insert(cmd, './...')
      end
    elseif params.subcommand == 'build' then
      if params.output ~= '' then
        vim.list_extend(cmd, { '-o', params.output })
      end
      if params.package ~= '' then
        table.insert(cmd, params.package)
      end
    elseif params.subcommand == 'run' then
      if params.file ~= '' then
        table.insert(cmd, params.file)
      else
        table.insert(cmd, '.')
      end
    end

    return {
      cmd = cmd,
      components = { 'build_test' },
    }
  end,
  params = {
    subcommand = {
      type = 'enum',
      default = 'test',
      choices = { 'test', 'build', 'run' },
      desc = 'Go subcommand',
    },
    package = {
      type = 'string',
      optional = true,
      default = '',
      desc = 'Package path (empty for current/all)',
    },
    coverage = {
      type = 'boolean',
      default = true,
      desc = 'Generate coverage report (test only)',
    },
    race = {
      type = 'boolean',
      default = false,
      desc = 'Enable race detector (test only)',
    },
    output = {
      type = 'string',
      optional = true,
      default = '',
      desc = 'Output binary name (build only)',
    },
    file = {
      type = 'string',
      optional = true,
      default = '',
      desc = 'File to run (run only, empty for .)',
    },
  },
  desc = 'Run Go command',
}
