return {
  {
    'lewis6991/hover.nvim',
    opts = {
      init = function()
        require('hover.providers.lsp')
        require('hover.providers.man')
        require('hover.providers.dap')
        require('hover.providers.diagnostic')

        local peek_supported_capabilities = {
          vim.lsp.protocol.Methods.textDocument_declaration,
          vim.lsp.protocol.Methods.textDocument_implementation,
          vim.lsp.protocol.Methods.textDocument_definition,
        }
        require('hover').register({
          name = 'LSP Peek',
          enabled = function(bufnr)
            return vim.iter(vim.lsp.get_clients({ bufnr = bufnr })):any(
              ---@param cli vim.lsp.Client
              function(cli)
                return vim.iter(peek_supported_capabilities):any(function(method)
                  return cli:supports_method(method, bufnr)
                end)
              end
            )
          end,
          execute = function(opts, done)
            local finished = false
            for _, method in ipairs(peek_supported_capabilities) do
              if
                vim.iter(vim.lsp.get_clients({ bufnr = opts.bufnr })):any(
                  ---@param cli vim.lsp.Client
                  function(cli)
                    return cli:supports_method(method, opts.bufnr)
                  end
                )
              then
                vim.lsp.buf_request(opts.bufnr, method, function(client, _bufnr)
                  return vim.lsp.util.make_position_params(0, client.offset_encoding)
                end, function(err, result, context, config)
                  if result == nil or vim.tbl_isempty(result) then
                    if not finished then
                      finished = true
                      return pcall(done, false)
                    else
                      return
                    end
                  end
                  local loc = result
                  if vim.islist(result) then
                    loc = result[1]
                  end
                  loc.uri = loc.uri or loc.targetUri
                  loc.range = loc.range or loc.targetRange
                  if loc.uri == nil or loc.range == nil then
                    if not finished then
                      finished = true
                      return pcall(done, false)
                    else
                      return
                    end
                  end
                  local peek_bufnr = vim.uri_to_bufnr(loc.uri)
                  vim.fn.bufload(peek_bufnr)
                  vim.api.nvim_buf_call(peek_bufnr, function()
                    -- make sure the appropriate treesitter parser can be created
                    vim.cmd('filetype detect')
                  end)

                  local range = loc.range
                  local ft = vim.bo[peek_bufnr].filetype
                  local md_lines = {}
                  local peek_path = vim.fs.abspath(vim.api.nvim_buf_get_name(peek_bufnr))
                  local orig_path = vim.fs.abspath(vim.api.nvim_buf_get_name(opts.bufnr))
                  if orig_path ~= peek_path then
                    local cli = vim.lsp.get_client_by_id(context.client_id)
                    if cli and cli.config.root_dir then
                      peek_path = string.format([[%s]], vim.fs.normalize(peek_path)):gsub(
                        string.format([[%s/]], vim.fs.normalize(vim.fs.abspath(cli.config.root_dir))),
                        ''
                      )
                    end

                    peek_path = peek_path:gsub(string.format([[%s]], os.getenv('HOME') or ''), '~')
                    vim.list_extend(md_lines, { string.format('`%s`', peek_path) })
                  end
                  vim.list_extend(md_lines, {
                    '```' .. ft,
                    string.format(vim.bo[peek_bufnr].commentstring, method),
                  })
                  local line_num = math.ceil(vim.api.nvim_win_get_height(0) * 0.2)
                  local ts_node = vim.treesitter.get_node({
                    bufnr = peek_bufnr,
                    pos = { range.start.line, range.start.character },
                  })
                  if ts_node ~= nil then
                    local row_start, _, row_end, _ = vim.treesitter.get_node_range(ts_node)

                    while row_start == row_end and ts_node ~= nil do
                      -- find the closest multi_line parent node and treat it as the definition.
                      ts_node = ts_node:parent()
                      if ts_node:parent() == nil then
                        -- it's probably the root node. skip it.
                        break
                      end
                      row_start, _, row_end, _ = vim.treesitter.get_node_range(ts_node)
                    end

                    line_num = row_end - row_start + 1
                  end
                  vim.list_extend(
                    md_lines,
                    vim.api.nvim_buf_get_lines(peek_bufnr, range.start.line, range.start.line + line_num, false)
                  )
                  table.insert(md_lines, '```')
                  if not finished then
                    finished = true
                    return pcall(done, {
                      lines = md_lines,
                      filetype = 'markdown',
                    })
                  else
                    return
                  end
                end)
                return
              end
            end
          end,
        })
      end,
      preview_opts = {
        border = vim.g.borderStyle,
      },
      preview_window = false,
      title = true,
      mouse_providers = {
        'LSP',
      },
      mouse_delay = 1000,
    },
    keys = {
      {
        'K',
        function()
          return require('hover').hover()
        end,
        desc = 'Trigger hover.',
        mode = 'n',
        noremap = true,
      },
      {
        '[h',
        function()
          return require('hover').hover_switch('previous')
        end,
        desc = 'Previous hover provider.',
        mode = 'n',
        noremap = true,
      },
      {
        ']h',
        function()
          return require('hover').hover_switch('next')
        end,
        desc = 'Next hover provider.',
        mode = 'n',
        noremap = true,
      },
    },
  },
}
