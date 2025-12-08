-- Nx monorepo task template provider with dynamic project discovery
local files = require('overseer.files')

---@type overseer.TemplateFileProvider
return {
  cache_key = function(opts)
    return vim.fs.joinpath(opts.dir, 'nx.json')
  end,

  condition = {
    callback = function(search)
      -- Only show if nx.json exists
      return files.exists(files.join(search.dir, 'nx.json'))
    end,
  },

  generator = function(opts, cb)
    local tasks = {}
    local cwd = opts.dir

    -- Run nx show projects to get all available projects
    vim.system({ 'npx', 'nx', 'show', 'projects' }, { cwd = cwd, text = true }, function(result)
      if result.code ~= 0 then
        -- Fallback: just provide generic nx commands without project list
        table.insert(tasks, {
          name = 'nx',
          params = {
            subcommand = {
              type = 'enum',
              default = 'build',
              choices = { 'build', 'test', 'lint', 'serve', 'e2e' },
              desc = 'Nx command',
            },
            project = {
              type = 'string',
              desc = 'Project name',
            },
            extra_args = {
              type = 'string',
              optional = true,
              desc = 'Extra arguments',
            },
          },
          builder = function(params)
            local cmd = { 'npx', 'nx', params.subcommand, params.project }
            if params.extra_args and params.extra_args ~= '' then
              vim.list_extend(cmd, vim.split(params.extra_args, ' '))
            end
            return {
              cmd = cmd,
              components = { 'build_test' },
            }
          end,
        })
        cb(tasks)
        return
      end

      -- Parse project list
      local projects = {}
      for line in result.stdout:gmatch('[^\n]+') do
        local project = vim.trim(line)
        if project ~= '' then
          table.insert(projects, project)
        end
      end

      -- Create tasks for common nx commands
      local commands = { 'build', 'test', 'lint', 'serve', 'e2e' }

      for _, cmd_name in ipairs(commands) do
        for _, project in ipairs(projects) do
          table.insert(tasks, {
            name = string.format('nx %s %s', cmd_name, project),
            tags = { 'NX', cmd_name:upper() },
            params = {
              extra_args = {
                type = 'string',
                optional = true,
                desc = 'Extra arguments',
              },
            },
            builder = function(params)
              local cmd = { 'npx', 'nx', cmd_name, project }
              if params.extra_args and params.extra_args ~= '' then
                vim.list_extend(cmd, vim.split(params.extra_args, ' '))
              end
              return {
                cmd = cmd,
                components = { 'build_test' },
              }
            end,
          })
        end
      end

      -- Also add a generic "custom command" task
      table.insert(tasks, {
        name = 'nx (custom)',
        tags = { 'NX' },
        params = {
          subcommand = {
            type = 'enum',
            default = 'build',
            choices = { 'build', 'test', 'lint', 'serve', 'e2e', 'run' },
            desc = 'Nx command',
          },
          project = {
            type = 'enum',
            default = projects[1] or '',
            choices = projects,
            desc = 'Project name',
          },
          target = {
            type = 'string',
            optional = true,
            desc = "Target (for 'run' command)",
          },
          extra_args = {
            type = 'string',
            optional = true,
            desc = 'Extra arguments',
          },
        },
        builder = function(params)
          local cmd = { 'npx', 'nx' }
          if params.subcommand == 'run' and params.target then
            vim.list_extend(cmd, { 'run', params.project .. ':' .. params.target })
          else
            vim.list_extend(cmd, { params.subcommand, params.project })
          end
          if params.extra_args and params.extra_args ~= '' then
            vim.list_extend(cmd, vim.split(params.extra_args, ' '))
          end
          return {
            cmd = cmd,
            components = { 'build_test' },
          }
        end,
      })

      cb(tasks)
    end)
  end,
}
