-- chain functions
-- use the same keybinding to cycle through a sequence of unitrects

local chains = {}

-- keep table of windows, operations, and their current indices
chains.windows = {}
function chains.winChainIter(t, id, op)
  -- new operation -> clear and create new tracking table
  if not (type(chains.windows[id]) == "table" and chains.windows[id][op]) then
    chains.windows[id] = {}
    chains.windows[id][op] = true
    chains.windows[id]["index"] = 0
  end

  local i, n = chains.windows[id]["index"], #t
  return function()
    i = i % n + 1
    chains.windows[id]["index"] = i
    return t[i]
  end
end

function chains.chain(t, op, win)
  local win = win or hs.window.focusedWindow()
  print(t, op, win:id())
  local iter = chains.winChainIter(t, win:id(), op)
  win:move(iter())
end

return chains
