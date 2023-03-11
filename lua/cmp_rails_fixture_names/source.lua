local M = {}

M.new = function()
  return setmetatable({}, { __index = M })
end

M.is_available = function()
  local current_buffer_path = vim.fn.expand('%')

  return vim.startswith(current_buffer_path, 'test/')
    or vim.startswith(current_buffer_path, 'spec/')
end

M.get_trigger_characters = function()
  return { ':' }
end

M.complete = function(_, request, callback)
  local input = string.sub(request.context.cursor_before_line, request.offset - 1)
  local prefix = string.sub(request.context.cursor_before_line, 1, request.offset - 1)
  local names = require('cmp_rails_fixture_names.names')

  local type = prefix:match('(%g+)%(%:$')

  if vim.startswith(input, ':') and names.valid_type(type) then
    local items = {}
    for _, name in ipairs(names.all(type)) do
      local cmp_item = {
        filterText = ':' .. name,
        label = ':' .. name,
        documentation = names.documentation(type, name),
        textEdit = {
          newText = ':' .. name,
          range = {
            start = {
              line = request.context.cursor.row - 1,
              character = request.context.cursor.col - 1 - #input,
            },
            ['end'] = {
              line = request.context.cursor.row - 1,
              character = request.context.cursor.col - 1,
            },
          },
        },
      }

      table.insert(items, cmp_item)
    end
    callback({
      items = items,
      isIncomplete = true,
    })
  else
    callback({ isIncomplete = true })
  end
end

return M
