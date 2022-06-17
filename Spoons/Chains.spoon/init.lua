--- === Chains ===
---
--- Use a single keybinding repeated to resize a window differently in sequence
---
--- Inspired by the default keybindings in
--- [Spectacle](https://github.com/eczarny/spectacle) and the
--- `chain` function of [Slate](https://github.com/jigish/slate)
---
--- Example usage:
--- ```
--- hs.hotkey.bind({"cmd","alt"}, "up",
---   function() Chains.link({ hs.geometry.unitrect(0.0, 0.0, 0.5, 0.5),
---                            hs.geometry.unitrect(0.0, 0.5, 0.5, 0.5),
---                            hs.geometry.unitrect(0.5, 0.0, 0.5, 0.5),
---                            hs.geometry.unitrect(0.5, 0.5, 0.5, 0.5) }, "quads")
--- end)
--- ```

local obj = {}

-- Metadata
obj.name = "Chains"
obj.version = "1.0"
obj.author = "James Hsiao <matchstick@gmail.com>"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.windows = {}  -- a table of windows, current ops, and indices

-- Internal iterator function to track
local function _chainIterator(t, id, op)
  -- for any new operation -> clear and create new tracking table
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

--- Chains:chain()
--- Method
--- Move the focused window in sequence through a list of unitrect tables
---
--- Parameters
--- * rectTable - a table consisting of individual unitrects in a sequence
--- * operation - a string to uniquely identify the operation
---
--- Returns:
--- * None
function obj:link(rectTable, operation)
  local win = hs.window.focusedWindow()
  local iter = _chainIterator(rectTable, win:id(), operation)
  win:move(iter()):focus()
end

return obj
