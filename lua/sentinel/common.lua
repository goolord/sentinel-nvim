local M = {}

_G.sentinel = {}
_G.sentinel.providers = {}

function M.register_provider(opts)
    _G.sentinel.providers[opts.name] = opts
end

-- Function to retrieve console output
function os.capture(cmd, raw)
  local f = assert(io.popen(table.concat(cmd, ' '), 'r'))
  local s = assert(f:read('*a'))
  f:close()
  if raw then return s end
  s = string.gsub(s, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  return s
end

function M.unlines(str)
    local lines = {}
    for s in str:gmatch("[^\r\n]+") do
        table.insert(lines, s)
    end
    return lines
end

return M
