-- https://github.com/jinzhongjia/neovim-config/blob/b7b288406d2c86beb4dce342e345b294981e98e6/lua/plugins/ui.lua
local M = require('lualine.component'):extend()

M.processing = false
M.spinner_index = 1

local spinner_styles = {
  dots = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
  dots2 = { '⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷' },
  line = { '-', '\\', '|', '/' },
  star = { '✶', '✸', '✹', '✺', '✹', '✸' },
  bounce = { '⠁', '⠂', '⠄', '⡀', '⢀', '⠠', '⠐', '⠈' },
  box = { '▖', '▘', '▝', '▗' },
  arc = { '◜', '◠', '◝', '◞', '◡', '◟' },
  circle = { '◐', '◓', '◑', '◒' },
  square = { '◰', '◳', '◲', '◱' },
  triangle = { '◢', '◣', '◤', '◥' },
}

local spinner_state = {
  is_processing = false,
  current_index = 1,
  timer = nil,
  autocmd_created = false,
  last_status = 'finished', -- "started", "finished", "error"
  instances = {}, -- Track all instances
  update_scheduled = false,
}

local function stop_timer()
  if spinner_state.timer then
    spinner_state.timer:stop()
    spinner_state.timer:close()
    spinner_state.timer = nil
  end
end

local function debounced_redraw()
  if not spinner_state.update_scheduled then
    spinner_state.update_scheduled = true
    vim.defer_fn(function()
      vim.cmd('redrawstatus!')
      spinner_state.update_scheduled = false
    end, 10) -- 10ms Anti-shake delay
  end
end

-- Start a timer asynchronously
local function start_timer(interval, symbols_count)
  stop_timer()

  spinner_state.timer = vim.loop.new_timer()
  if spinner_state.timer then
    local callback = function()
      if spinner_state.is_processing then
        spinner_state.current_index = (spinner_state.current_index % symbols_count) + 1
        debounced_redraw()
      else
        vim.schedule(function()
          stop_timer()
        end)
      end
    end

    -- Use vim.schedule_wrap to ensure execution in the main thread
    spinner_state.timer:start(0, interval, vim.schedule_wrap(callback))
  end
end

local spinner_symbols = {
  '⠋',
  '⠙',
  '⠹',
  '⠸',
  '⠼',
  '⠴',
  '⠦',
  '⠧',
  '⠇',
  '⠏',
}
local spinner_symbols_len = 10

-- Initializer
function M:init(options)
  M.super.init(self, options)

  -- Configuration Options
  self.style = options.style or 'dots'
  self.interval = options.interval or 80 -- Animation update interval (milliseconds)
  self.show_when_done = options.show_when_done or false
  self.done_icon = options.done_icon or '✓'
  self.error_icon = options.error_icon or '✗'
  self.fade_out = options.fade_out or false
  self.fade_delay = options.fade_delay or 2000 --Fade out delay after completion (milliseconds)
  self.smooth = options.smooth ~= false -- Smooth animation, enabled by default

  -- Allow custom symbols
  if options.symbols then
    self.symbols = options.symbols
  else
    self.symbols = spinner_styles[self.style] or spinner_styles.dots
  end

  table.insert(spinner_state.instances, self)

  -- Create the autocommand only once to avoid duplication
  if not spinner_state.autocmd_created then
    local group = vim.api.nvim_create_augroup('CodeCompanionHooks', { clear = true })

    vim.api.nvim_create_autocmd({ 'User' }, {
      pattern = 'CodeCompanionRequest*',
      group = group,
      callback = function(request)
        -- Get the configuration of the first instance
        local instance = spinner_state.instances[1]
        if not instance then
          return
        end

        if request.match == 'CodeCompanionRequestStarted' then
          vim.schedule(function()
            spinner_state.is_processing = true
            spinner_state.last_status = 'started'
            spinner_state.current_index = 1
            start_timer(instance.interval, #instance.symbols)
          end)
        elseif request.match == 'CodeCompanionRequestFinished' then
          vim.schedule(function()
            spinner_state.is_processing = false

            -- Set the status based on the request result
            if request.data and request.data.status == 'error' then
              spinner_state.last_status = 'error'
            else
              spinner_state.last_status = 'finished'
            end

            -- If fadeout is set, asynchronous delay clears the state
            if instance.fade_out and instance.show_when_done then
              vim.defer_fn(function()
                spinner_state.last_status = nil
                debounced_redraw()
              end, instance.fade_delay)
            end

            debounced_redraw()
          end)
        end
      end,
    })

    -- Cleaning up resources
    vim.api.nvim_create_autocmd({ 'VimLeavePre', 'VimSuspend' }, {
      group = group,
      callback = function()
        stop_timer()
        spinner_state.instances = {}
      end,
    })

    spinner_state.autocmd_created = true
  end
end
function M:init_old(options)
  M.super.init(self, options)

  local group = vim.api.nvim_create_augroup('CodeCompanionHooks', {})

  vim.api.nvim_create_autocmd({ 'User' }, {
    pattern = 'CodeCompanionRequest*',
    group = group,
    callback = function(request)
      if request.match == 'CodeCompanionRequestStarted' then
        self.processing = true
      elseif request.match == 'CodeCompanionRequestFinished' then
        self.processing = false
      end
    end,
  })
end

function M:update_status()
  if spinner_state.is_processing then
    local idx = ((spinner_state.current_index - 1) % #self.symbols) + 1
    return self.symbols[idx]
  elseif self.show_when_done and spinner_state.last_status then
    if spinner_state.last_status == 'error' then
      return self.error_icon
    elseif spinner_state.last_status == 'finished' then
      return self.done_icon
    end
  end
  return nil
end

-- Function that runs every time statusline is updated
function M:update_status_old()
  if self.processing then
    self.spinner_index = (self.spinner_index % spinner_symbols_len) + 1
    return spinner_symbols[self.spinner_index]
  else
    return nil
  end
end

return M
