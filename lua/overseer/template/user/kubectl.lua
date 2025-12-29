-- Kubernetes port-forwarding and common kubectl tasks
---@type overseer.TemplateFileDefinition
return {
  name = 'kubectl',
  builder = function(params)
    local cmd = { 'kubectl' }

    if params.subcommand == 'port-forward' then
      vim.list_extend(cmd, {
        'port-forward',
        params.resource_type .. '/' .. params.resource_name,
        params.port_mapping,
      })
      if params.namespace ~= '' then
        vim.list_extend(cmd, { '-n', params.namespace })
      end
    elseif params.subcommand == 'logs' then
      vim.list_extend(cmd, { 'logs', '-f' })
      if params.namespace ~= '' then
        vim.list_extend(cmd, { '-n', params.namespace })
      end
      table.insert(cmd, params.pod_name)
    elseif params.subcommand == 'context' then
      vim.list_extend(cmd, { 'config', 'use-context', params.context_name })
    end

    return {
      cmd = cmd,
      components = {
        params.subcommand == 'port-forward' and 'long_running' or 'default',
      },
    }
  end,
  params = {
    subcommand = {
      type = 'enum',
      default = 'port-forward',
      choices = { 'port-forward', 'logs', 'context' },
      desc = 'kubectl subcommand',
    },
    resource_type = {
      type = 'enum',
      optional = true,
      default = 'svc',
      choices = { 'svc', 'pod', 'deployment' },
      desc = 'Resource type (port-forward only)',
    },
    resource_name = {
      type = 'string',
      optional = true,
      default = '',
      desc = 'Resource name (port-forward only)',
    },
    port_mapping = {
      type = 'string',
      optional = true,
      default = '8080:8080',
      desc = 'Port mapping local:remote (port-forward only)',
    },
    pod_name = {
      type = 'string',
      optional = true,
      default = '',
      desc = 'Pod name (logs only)',
    },
    context_name = {
      type = 'string',
      optional = true,
      default = '',
      desc = 'Context name (context only)',
    },
    namespace = {
      type = 'string',
      optional = true,
      default = '',
      desc = 'Kubernetes namespace',
    },
  },
  desc = 'Run kubectl command',
  tags = { 'K8S', 'KUBECTL' },
}
