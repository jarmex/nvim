-- Full-stack workflow: port-forward + Tilt + FE (parallel execution)
return {
  name = 'fullstack',
  tags = { 'FULLSTACK', 'DEV' },
  builder = function(params)
    local tasks = {}

    -- Port forwarding (long-running)
    if params.enable_port_forward then
      table.insert(tasks, {
        name = 'Port Forward',
        cmd = vim.split(params.port_forward_cmd, ' '),
        components = { 'long_running' },
      })
    end

    -- Backend (Tilt or custom)
    if params.enable_backend then
      table.insert(tasks, {
        name = 'Backend',
        cmd = vim.split(params.backend_cmd, ' '),
        components = { 'long_running' },
      })
    end

    -- Frontend (npm/nx)
    if params.enable_frontend then
      table.insert(tasks, {
        name = 'Frontend',
        cmd = vim.split(params.frontend_cmd, ' '),
        components = { 'long_running' },
      })
    end

    if #tasks == 0 then
      return { cmd = { 'echo', 'No tasks enabled' }, components = { 'default' } }
    elseif #tasks == 1 then
      return tasks[1]
    else
      -- Run all tasks in parallel
      return {
        name = 'Full-Stack Development',
        builder = function()
          local parallel_tasks = {}
          for _, task_def in ipairs(tasks) do
            local task = require('overseer').new_task(task_def)
            table.insert(parallel_tasks, task)
          end

          -- Start all tasks
          for _, task in ipairs(parallel_tasks) do
            task:start()
          end

          -- Return a dummy task that just tracks the parallel execution
          return {
            cmd = { 'echo', 'Full-stack environment started' },
            components = { 'default' },
          }
        end,
      }
    end
  end,
  params = {
    enable_port_forward = {
      type = 'boolean',
      default = true,
      desc = 'Enable port forwarding',
    },
    port_forward_cmd = {
      type = 'string',
      optional = true,
      default = 'kubectl port-forward svc/backend 8080:8080',
      desc = 'Port forward command',
    },
    enable_backend = {
      type = 'boolean',
      default = true,
      desc = 'Enable backend (Tilt)',
    },
    backend_cmd = {
      type = 'string',
      optional = true,
      default = 'tilt up',
      desc = 'Backend command',
    },
    enable_frontend = {
      type = 'boolean',
      default = true,
      desc = 'Enable frontend',
    },
    frontend_cmd = {
      type = 'string',
      optional = true,
      default = 'npm run dev',
      desc = 'Frontend command',
    },
  },
  desc = 'Start full-stack development environment (parallel)',
}
