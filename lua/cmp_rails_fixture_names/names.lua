local has_scan, scan = pcall(require, 'plenary.scandir')
if not has_scan then
  vim.notify('Need the plenary plugin installed for cmp-rails-fixture-names to work')
  return
end

local rails_fixture_names = {}

local success, types = pcall(function()
  local fixture_dirs = { './test/fixtures', './spec/fixtures' }

  local fixture_dirs = vim.tbl_filter(function(dir)
    return vim.fn.isdirectory(dir) == 1
  end, fixture_dirs)

  local files = scan.scan_dir(fixture_dirs, { search_pattern = '.yml', respect_gitignore = true,
    silent = true })

  local types = {}
  for _, file in pairs(files) do
    for _, fixture_dir in pairs(fixture_dirs) do
      local type = file:match(fixture_dir .. '/(.+)%.yml$')
      types[type:gsub('/', '_')] = file
    end
  end

  return types
end)
if not success then
  return
end

function rails_fixture_names.valid_type(type)
  if type == nil or type == '' then
    return false
  end

  return types[type] ~= nil
end

function rails_fixture_names.all(type)
  local filename = types[type]
  local file = io.open(filename, 'r')

  local names = {}

  for line in file:lines() do
    local name = line:match('^([a-z_]+):')
    if name then
      table.insert(names, name)
    end
  end

  io.close(file)

  return names
end

function rails_fixture_names.documentation(type, name)
  local filename = types[type]
  local file = io.open(filename, 'r')

  local documentation = ''
  local matched = false

  for line in file:lines() do
    if not matched then
      matched = line:match('^' .. name .. ':')
      if matched then
        documentation = name .. ':\n'
      end
    else
      if (line == nil) or (line == '') or (line == '--') or (not line:match('^  ')) then
        matched = false
      else
        documentation = documentation .. line .. '\n'
      end
    end
  end

  io.close(file)

  return documentation
end

return rails_fixture_names
