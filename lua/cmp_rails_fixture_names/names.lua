local has_scan, scan = pcall(require, 'plenary.scandir')
if not has_scan then
  vim.notify('Need the plenary plugin installed for cmp-rails-fixture-names to work')
  return
end

local M = {}

function M.fixture_types(type)
  if not M.loaded_fixtures then
    M.loaded_fixtures = {}

    for _, fixture_dir in pairs(M.fixture_dirs()) do
      for _, file in pairs(M.fixture_files()) do
        local formatted_type = file:match(fixture_dir .. '/(.+)%.yml$')
        M.loaded_fixtures[formatted_type:gsub('/', '_')] = file
      end
    end
  end

  return M.loaded_fixtures[type]
end

function M.fixture_files()
  return scan.scan_dir(
    M.fixture_dirs(),
    { search_pattern = '.yml', respect_gitignore = true, silent = true }
  )
end

function M.fixture_dirs()
  local fixture_dirs = { './test/fixtures', './spec/fixtures' }

  fixture_dirs = vim.tbl_filter(function(dir)
    return vim.fn.isdirectory(dir) == 1
  end, fixture_dirs)

  return fixture_dirs
end

function M.valid_type(type)
  if type == nil or type == '' then
    return false
  end

  return M.fixture_types(type) ~= nil
end

function M.all(type)
  local filename = M.fixture_types(type)
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

function M.documentation(type, name)
  local filename = M.fixture_types(type)
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

return M
