local function ring_buffer_next(s, offset)
  -- we need to track offset rather than the raw pos itself because otherwise our terminating
  -- condition would be "are we past the write cursor", but that's the case at the start and
  -- we don't know if we've lapped ourselves!
  if offset > #s then
    return
  end

  local pos = s.write_cursor + offset
  if pos > #s then
    pos = pos - #s
  end

  return offset + 1, s[pos]
end

local function ring_buffer(size)
  local buf = {
    size         = size,
    write_cursor = 0,
  }

  function buf:push(value)
    assert(value ~= nil)

    self.write_cursor = (self.write_cursor % self.size) + 1
    self[self.write_cursor] = value
  end

  function buf:iterate()
    assert(self.write_cursor <= #self)

    return ring_buffer_next, self, 1
  end

  function buf:clear()
    local size = #self
    for i = 1, size do
      buf[i] = nil
    end
    self.write_cursor = 0
  end

  return buf
end

return ring_buffer
