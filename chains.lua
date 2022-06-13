-- chain functions
-- use the same keybinding to cycle through a sequence of unitrects

local obj = {}

-- keep table of windows, operations, and their current indices
obj.windows = {}
function obj.winChainIter(t, id, op)
  -- new operation -> clear and create new tracking table
  if not (type(obj.windows[id]) == "table" and obj.windows[id][op]) then
    obj.windows[id] = {}
    obj.windows[id][op] = true
    obj.windows[id]["index"] = 0
  end

  local i, n = obj.windows[id]["index"], #t
  return function()
    i = i % n + 1
    obj.windows[id]["index"] = i
    return t[i]
  end
end

function obj.chain(t, op, win)
  local win = win or hs.window.focusedWindow()
  local iter = obj.winChainIter(t, win:id(), op)
  win:move(iter())
end

return obj
