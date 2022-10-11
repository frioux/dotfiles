local json_modules = {'cjson', 'json', 'dkjson'}
local json

for i = 1, #json_modules do
  local success, mod = pcall(require, json_modules[i])
  if success then
    json = mod
    break
  end
end

assert(json, 'unable to load compatible JSON library (options are ' .. table.concat(json_modules, ', ') .. ')')

local window_buffer_max = 100

local window_buffer = require('ring_buffer')(window_buffer_max)

local function flush_window_buffer()
  for _, c in window_buffer:iterate() do
    print(json.encode(c))
  end

  window_buffer:clear()
end

local function record(c)
  local t = {
    message  = 'rule evaluation',
    when     = os.date '%Y-%m-%dT%H:%M:%S',
    name     = c.name,
    type     = c.type,
    class    = c.class,
    instance = c.instance,
    role     = c.role,
  }
  window_buffer:push(t)
end

return {
  flush_window_buffer = flush_window_buffer,
  record              = record,
}
