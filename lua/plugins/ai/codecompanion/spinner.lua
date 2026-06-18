-- ── CodeCompanion → Snacks.notify integration ─────────────────────────────

local cc_icons = {
  request = '󰚩',
  done = '󰗡',
  error = '󰅚 ',
  cancelled = '󰜺',
  chat = '💬',
  tool = '🛠️',
  inline = '󰩵',
  mcp = '󰒋',
  model = '🧠',
  compact = '󰃣',
}

---@param adapter CodeCompanion.Adapter|nil
local function format_adapter(adapter)
  if not adapter then
    return 'CodeCompanion'
  end
  local name = adapter.name or 'CodeCompanion'
  local model = (adapter.defaults and adapter.defaults.model)
    or (adapter.schema and adapter.schema.model and adapter.schema.model.default)
    or ''
  return model ~= '' and (name .. ' / ' .. model) or name
end

local function codecompanion_snacks()
  local group = vim.api.nvim_create_augroup('dotfiles.codecompanion.snacks', { clear = true })
  local request_ids = {}
  local acp_state = {}
  local acp_config_versions = {}
  local tools_added = {}
  local tools_added_seen = {}

  local function cc_notify(msg, opts)
    Snacks.notify(
      msg,
      vim.tbl_extend('force', {
        title = 'CodeCompanion',
        level = 'info',
        timeout = 6000,
      }, opts or {})
    )
  end

  local function cc_debug_event(name, data)
    if not cc_debug_enabled then
      return
    end
    cc_notify('DEBUG ' .. name .. '\n' .. vim.inspect(data or {}), {
      title = 'CodeCompanion Debug',
      timeout = 6000,
    })
  end

  local function event_tool_name(data)
    data = data or {}
    return data.tool or data.name or data.tool_name or 'unknown'
  end

  local function reset_tools_added()
    tools_added = {}
    tools_added_seen = {}
  end

  local function add_tool_added(tool)
    if not tool or tool == '' then
      tool = 'unknown'
    end
    if tools_added_seen[tool] then
      return
    end
    tools_added_seen[tool] = true
    table.insert(tools_added, tool)
  end

  local function tools_added_message(prefix)
    prefix = prefix or (cc_icons.tool .. ' Tools added')
    local lines = { string.format('%s (%d):', prefix, #tools_added) }
    local limit = 10
    for i = 1, math.min(#tools_added, limit) do
      table.insert(lines, '• ' .. tools_added[i])
    end
    if #tools_added > limit then
      table.insert(lines, '… +' .. tostring(#tools_added - limit) .. ' more')
    end
    return table.concat(lines, '\n')
  end

  local function notify_model(bufnr, model)
    if not model or model == '' then
      return
    end

    if bufnr then
      local state = acp_state[bufnr] or {}
      if state.model == model then
        return
      end
      state.model = model
      acp_state[bufnr] = state
    end

    cc_notify(cc_icons.model .. ' Model → ' .. model, { title = 'CodeCompanion Chat' })
  end

  local function format_acp_config_value(opt)
    if not opt or not opt.currentValue then
      return nil
    end

    for _, item in ipairs(opt.options or {}) do
      if item.group then
        for _, value in ipairs(item.options or {}) do
          if value.value == opt.currentValue then
            return value.name or value.value
          end
        end
      elseif item.value == opt.currentValue then
        return item.name or item.value
      end
    end

    return opt.currentValue
  end

  local function get_live_acp_config_value(bufnr, category)
    local ok, codecompanion = pcall(require, 'codecompanion')
    if not ok then
      return nil
    end

    local chat = codecompanion.buf_get_chat(bufnr)
    local connection = chat and chat.acp_connection
    if not connection then
      return nil
    end

    for _, opt in ipairs(connection:get_config_options() or {}) do
      if opt.type == 'select' and (opt.category or opt.id) == category then
        return format_acp_config_value(opt)
      end
    end
  end

  local notify_acp_option

  local function notify_live_acp_config(bufnr)
    if not bufnr then
      return
    end

    acp_config_versions[bufnr] = (acp_config_versions[bufnr] or 0) + 1
    local version = acp_config_versions[bufnr]

    vim.defer_fn(function()
      if acp_config_versions[bufnr] ~= version then
        return
      end

      notify_acp_option(bufnr, 'mode', 'Mode', get_live_acp_config_value(bufnr, 'mode'))
      notify_acp_option(bufnr, 'thought_level', 'Thought level', get_live_acp_config_value(bufnr, 'thought_level'))
    end, 100)
  end

  notify_acp_option = function(bufnr, state_key, label, value)
    if not value or value == '' then
      return
    end

    if bufnr then
      local state = acp_state[bufnr] or {}
      if state[state_key] == value then
        return
      end
      state[state_key] = value
      acp_state[bufnr] = state
    end

    cc_notify(cc_icons.mcp .. ' ' .. label .. ' → ' .. value, { title = 'CodeCompanion Chat' })
  end

  -- ── Request (spinner) ──────────────────────────────────────────────────
  vim.api.nvim_create_autocmd('User', {
    pattern = 'CodeCompanionRequestStarted',
    group = group,
    callback = function(args)
      local id = 'cc_req_' .. tostring(args.data.id)
      request_ids[args.data.id] = id
      cc_notify(cc_icons.request .. ' Sending...', {
        id = id,
        title = format_adapter(args.data.adapter),
        timeout = false,
      })
    end,
  })

  vim.api.nvim_create_autocmd('User', {
    pattern = 'CodeCompanionRequestStreaming',
    group = group,
    callback = function(args)
      -- Intentionally quiet: RequestStarted already owns the spinner lifecycle.
      cc_debug_event('CodeCompanionRequestStreaming', args.data)
    end,
  })

  vim.api.nvim_create_autocmd('User', {
    pattern = 'CodeCompanionRequestFinished',
    group = group,
    callback = function(args)
      local id = request_ids[args.data.id]
      request_ids[args.data.id] = nil
      if not id then
        return
      end
      local status = args.data.status
      local msg, level
      if status == 'success' then
        msg, level = cc_icons.done .. ' Completed', 'info'
      elseif status == 'error' then
        msg, level = cc_icons.error .. ' Error', 'error'
      else
        msg, level = cc_icons.cancelled .. ' Cancelled', 'warn'
      end
      cc_notify(msg, { id = id, title = format_adapter(args.data.adapter), level = level, timeout = 6000 })
    end,
  })

  -- ── Chat ───────────────────────────────────────────────────────────────
  vim.api.nvim_create_autocmd('User', {
    pattern = 'CodeCompanionChatCreated',
    group = group,
    callback = function()
      cc_notify(cc_icons.chat .. ' Chat created', { title = 'CodeCompanion Chat' })
    end,
  })

  -- vim.api.nvim_create_autocmd('User', {
  --   pattern = 'CodeCompanionChatOpened',
  --   group = group,
  --   callback = function()
  --     cc_notify(cc_icons.chat .. ' Chat opened', { title = 'CodeCompanion Chat' })
  --   end,
  -- })

  -- vim.api.nvim_create_autocmd('User', {
  --   pattern = 'CodeCompanionChatHidden',
  --   group = group,
  --   callback = function()
  --     cc_notify(cc_icons.chat .. ' Chat hidden', { title = 'CodeCompanion Chat' })
  --   end,
  -- })
  --
  vim.api.nvim_create_autocmd('User', {
    pattern = 'CodeCompanionChatClosed',
    group = group,
    callback = function(args)
      local bufnr = args.data and args.data.bufnr
      if bufnr then
        acp_state[bufnr] = nil
        acp_config_versions[bufnr] = nil
      end
      cc_notify(cc_icons.chat .. ' Chat closed', { title = 'CodeCompanion Chat' })
    end,
  })

  vim.api.nvim_create_autocmd('User', {
    pattern = 'CodeCompanionChatStopped',
    group = group,
    callback = function(args)
      local bufnr = args.data and args.data.bufnr
      if bufnr then
        acp_state[bufnr] = nil
        acp_config_versions[bufnr] = nil
      end
      cc_notify(cc_icons.cancelled .. ' Chat stopped', { title = 'CodeCompanion Chat', level = 'warn' })
    end,
  })

  vim.api.nvim_create_autocmd('User', {
    pattern = 'CodeCompanionChatCompacting',
    group = group,
    callback = function()
      cc_notify(
        cc_icons.compact .. ' Compacting context...',
        { title = 'CodeCompanion Chat', timeout = false, id = 'cc_compacting' }
      )
    end,
  })

  vim.api.nvim_create_autocmd('User', {
    pattern = 'CodeCompanionChatCleared',
    group = group,
    callback = function()
      cc_notify(cc_icons.chat .. ' Chat cleared', { title = 'CodeCompanion Chat' })
    end,
  })

  vim.api.nvim_create_autocmd('User', {
    pattern = 'CodeCompanionChatRestored',
    group = group,
    callback = function()
      cc_notify(cc_icons.chat .. ' Chat restored', { title = 'CodeCompanion Chat' })
    end,
  })

  vim.api.nvim_create_autocmd('User', {
    pattern = 'CodeCompanionChatSubmitted',
    group = group,
    callback = function(args)
      -- Intentionally quiet: RequestStarted already reports submission.
      cc_debug_event('CodeCompanionChatSubmitted', args.data)
    end,
  })

  vim.api.nvim_create_autocmd('User', {
    pattern = 'CodeCompanionChatDone',
    group = group,
    callback = function(args)
      -- Intentionally quiet: RequestFinished already reports completion/error.
      cc_debug_event('CodeCompanionChatDone', args.data)
    end,
  })

  vim.api.nvim_create_autocmd('User', {
    pattern = 'CodeCompanionChatAdapter',
    group = group,
    callback = function(args)
      cc_debug_event('CodeCompanionChatAdapter', args.data)
      local adapter = args.data and args.data.adapter
      cc_notify('Adapter → ' .. format_adapter(adapter), { title = 'CodeCompanion Chat' })
    end,
  })

  vim.api.nvim_create_autocmd('User', {
    pattern = 'CodeCompanionChatModel',
    group = group,
    callback = function(args)
      cc_debug_event('CodeCompanionChatModel', args.data)
      local bufnr = args.data and args.data.bufnr
      local adapter = args.data and args.data.adapter
      local model = adapter and adapter.defaults and adapter.defaults.model
      if not model then
        return
      end

      notify_model(bufnr, model)
    end,
  })

  vim.api.nvim_create_autocmd('User', {
    pattern = 'CodeCompanionChatACPConfigChanged',
    group = group,
    callback = function(args)
      local data = args.data or {}
      cc_debug_event('CodeCompanionChatACPConfigChanged', data)
      local bufnr = data.bufnr
      if bufnr then
        local state = acp_state[bufnr] or {}
        state.saw_acp_config = true
        acp_state[bufnr] = state
      end

      notify_live_acp_config(bufnr)
    end,
  })

  vim.api.nvim_create_autocmd('User', {
    pattern = 'CodeCompanionChatACPModeChanged',
    group = group,
    callback = function(args)
      -- NOTE: upstream docs list this event, but current source does not emit it.
      -- Keeping handler for forward-compat and manual event firing.
      local data = args.data or {}
      cc_debug_event('CodeCompanionChatACPModeChanged', data)
      local mode = data.mode or 'unknown'
      notify_acp_option(data.bufnr, 'mode', 'ACP mode', mode)
    end,
  })

  -- ── Tools ──────────────────────────────────────────────────────────────
  -- vim.api.nvim_create_autocmd('User', {
  --   pattern = 'CodeCompanionToolsStarted',
  --   group = group,
  --   callback = function()
  --     reset_tools_added()
  --     cc_notify(cc_icons.tool .. ' Tools started', { title = 'CodeCompanion Tools', id = 'cc_tools', timeout = 6000 })
  --   end,
  -- })
  --
  -- vim.api.nvim_create_autocmd('User', {
  --   pattern = 'CodeCompanionToolsFinished',
  --   group = group,
  --   callback = function()
  --     local msg = '󰅩 Tools finished'
  --     if #tools_added > 0 then
  --       msg = tools_added_message('󰅩 Tools finished')
  --     end
  --     cc_notify(msg, { title = 'CodeCompanion Tools', id = 'cc_tools', timeout = 6000 })
  --   end,
  -- })
  --
  -- vim.api.nvim_create_autocmd('User', {
  --   -- Current source emits CodeCompanionChatToolAdded (docs still mention ToolAdded).
  --   pattern = { 'CodeCompanionChatToolAdded', 'CodeCompanionToolAdded' },
  --   group = group,
  --   callback = function(args)
  --     local tool = event_tool_name(args.data)
  --     add_tool_added(tool)
  --     cc_notify(tools_added_message(), {
  --       title = 'CodeCompanion Tools',
  --       id = 'cc_tools',
  --       timeout = 6000,
  --     })
  --   end,
  -- })
  --
  -- vim.api.nvim_create_autocmd('User', {
  --   pattern = 'CodeCompanionToolApprovalRequested',
  --   group = group,
  --   callback = function(args)
  --     local tool = event_tool_name(args.data)
  --     cc_notify(' Approval needed: ' .. tostring(tool), {
  --       title = 'CodeCompanion Tools',
  --       level = 'warn',
  --       timeout = false,
  --       id = 'cc_approval_' .. tostring(tool),
  --     })
  --   end,
  -- })
  --
  -- vim.api.nvim_create_autocmd('User', {
  --   pattern = 'CodeCompanionToolApprovalFinished',
  --   group = group,
  --   callback = function(args)
  --     local data = args.data or {}
  --     local tool = event_tool_name(data)
  --     local choice = data.choice and (' (' .. tostring(data.choice) .. ')') or ''
  --     cc_notify('Tool approval resolved: ' .. tostring(tool) .. choice, {
  --       title = 'CodeCompanion Tools',
  --       id = 'cc_approval_' .. tostring(tool),
  --       timeout = 6000,
  --     })
  --   end,
  -- })
  --
  -- vim.api.nvim_create_autocmd('User', {
  --   pattern = 'CodeCompanionToolStarted',
  --   group = group,
  --   callback = function(args)
  --     local tool = (args.data and args.data.tool) or 'unknown'
  --     cc_notify(cc_icons.tool .. ' ' .. tool, {
  --       title = 'CodeCompanion Tools',
  --       id = 'cc_tool_' .. tostring(tool),
  --       timeout = 6000,
  --     })
  --   end,
  -- })
  --
  -- vim.api.nvim_create_autocmd('User', {
  --   pattern = 'CodeCompanionToolFinished',
  --   group = group,
  --   callback = function(args)
  --     local tool = (args.data and args.data.tool) or 'unknown'
  --     local status = args.data and args.data.status
  --     local level = status == 'error' and 'error' or 'info'
  --     local icon = status == 'error' and cc_icons.error or '󰅩'
  --     cc_notify(icon .. ' ' .. tool, {
  --       title = 'CodeCompanion Tools',
  --       level = level,
  --       id = 'cc_tool_' .. tostring(tool),
  --       timeout = 6000,
  --     })
  --   end,
  -- })

  -- ── Inline ─────────────────────────────────────────────────────────────
  vim.api.nvim_create_autocmd('User', {
    pattern = 'CodeCompanionInlineStarted',
    group = group,
    callback = function()
      cc_notify(cc_icons.inline .. ' Inline started', { id = 'cc_inline', timeout = false })
    end,
  })

  vim.api.nvim_create_autocmd('User', {
    pattern = 'CodeCompanionInlineFinished',
    group = group,
    callback = function()
      cc_notify(cc_icons.inline .. ' Inline done', { id = 'cc_inline' })
    end,
  })

  -- ── MCP ────────────────────────────────────────────────────────────────
  vim.api.nvim_create_autocmd('User', {
    pattern = 'CodeCompanionMCPServerStart',
    group = group,
    callback = function(args)
      local server = (args.data and args.data.server) or 'unknown'
      cc_notify(cc_icons.mcp .. ' Starting: ' .. server, {
        title = 'CodeCompanion MCP',
        id = 'cc_mcp_' .. server,
        timeout = false,
      })
    end,
  })

  vim.api.nvim_create_autocmd('User', {
    pattern = 'CodeCompanionMCPServerReady',
    group = group,
    callback = function(args)
      local server = (args.data and args.data.server) or 'unknown'
      cc_notify(cc_icons.mcp .. ' Ready: ' .. server, {
        title = 'CodeCompanion MCP',
        id = 'cc_mcp_' .. server,
        timeout = 6000,
      })
    end,
  })

  vim.api.nvim_create_autocmd('User', {
    pattern = 'CodeCompanionMCPServerClosed',
    group = group,
    callback = function(args)
      local server = (args.data and args.data.server) or 'unknown'
      cc_notify(cc_icons.mcp .. ' Closed: ' .. server, {
        title = 'CodeCompanion MCP',
        level = 'warn',
        id = 'cc_mcp_' .. server,
        timeout = 6000,
      })
    end,
  })

  vim.api.nvim_create_autocmd('User', {
    pattern = 'CodeCompanionMCPServerToolsLoaded',
    group = group,
    callback = function(args)
      local server = (args.data and args.data.server) or 'unknown'
      local count = args.data and (args.data.count or (args.data.tools and #args.data.tools))
      local msg = cc_icons.mcp .. ' Tools loaded: ' .. server
      if count then
        msg = msg .. ' (' .. count .. ')'
      end
      cc_notify(msg, { title = 'CodeCompanion MCP', timeout = 6000 })
    end,
  })

  -- ── ACP ────────────────────────────────────────────────────────────────
  vim.api.nvim_create_autocmd('User', {
    pattern = 'CodeCompanionACPConnected',
    group = group,
    callback = function(args)
      local data = args.data or {}
      local adapter = data.adapter
      local suffix = adapter and (': ' .. tostring(adapter)) or ''
      cc_notify(cc_icons.mcp .. ' ACP connected' .. suffix, { title = 'CodeCompanion ACP' })
    end,
  })

  vim.api.nvim_create_autocmd('User', {
    pattern = 'CodeCompanionACPSessionPre',
    group = group,
    callback = function()
      cc_notify(
        cc_icons.mcp .. ' ACP session starting...',
        { title = 'CodeCompanion ACP', id = 'cc_acp_session', timeout = false }
      )
    end,
  })

  vim.api.nvim_create_autocmd('User', {
    pattern = 'CodeCompanionACPSessionPost',
    group = group,
    callback = function()
      cc_notify(
        cc_icons.mcp .. ' ACP session established',
        { title = 'CodeCompanion ACP', id = 'cc_acp_session', timeout = 6000 }
      )
    end,
  })

  vim.api.nvim_create_autocmd('User', {
    pattern = 'CodeCompanionACPChatRestored',
    group = group,
    callback = function()
      cc_notify(cc_icons.mcp .. ' ACP chat restored', { title = 'CodeCompanion ACP' })
    end,
  })

  -- ── Explicitly ignored events (tracked in debug mode only) ─────────────
  vim.api.nvim_create_autocmd('User', {
    pattern = {
      -- High-frequency internal events that would be notification spam.
      'CodeCompanionChatRefreshCache',
      'CodeCompanionContextChanged',
      'CodeCompanionDiffHunkChanged',
      -- CLI lifecycle is intentionally not surfaced in Snacks; CLI has its own UI.
      'CodeCompanionCLICreated',
      'CodeCompanionCLIOpened',
      'CodeCompanionCLIClosed',
      'CodeCompanionCLIHidden',
      'CodeCompanionCLISent',
      -- Completion-provider event, not user-actionable.
      'CodeCompanionACPCommandsUpdate',
    },
    group = group,
    callback = function(args)
      cc_debug_event(args.match, args.data)
    end,
  })
end

return {
  codecompanion_snacks = codecompanion_snacks,
}
