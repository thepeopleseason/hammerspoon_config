--- === Chains ===
---
--- Use a single keybinding for multiple operations in sequence
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
---
--- hs.hotkey.bind({"cmd","alt"}, "down",
---   function() Chains.op({ function() hs.alert('First function') end,
---                          function() hs.alert('Second function') end,
---                          function() hs.alert('Third function') end,
---                        }, "down")()
---   end)
--- ```

local obj = {}

-- Metadata
obj.name = "Chains"
obj.version = "1.2"
obj.author = "James Hsiao <matchstick@gmail.com>"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.chains = {}  -- a table of windows, current ops, and indices

-- Internal iterator function to track
local function _chainIterator(t, id, op)
  -- for any new operation -> clear and create new tracking table
  if not (type(obj.chains[id]) == "table" and obj.chains[id][op]) then
    obj.chains[id] = {}
    obj.chains[id][op] = true
    obj.chains[id]["index"] = 0
  end

  local i, n = obj.chains[id]["index"], #t
  return function()
    i = i % n + 1
    obj.chains[id]["index"] = i
    return t[i]
  end
end

--- Chains:link()
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
  local axApp = hs.axuielement.applicationElement(win:application())
  local wasEnhanced = axApp.AXEnhancedUserInterface
  if wasEnhanced then
    axApp.AXEnhancedUserInterface = false
  end
  win:move(iter()):focus()
  if wasEnhanced then
    axApp.AXEnhancedUserInterface = wasEnhanced
  end
end

--- Chains:op()
--- Method
--- Return the next function in sequence from a table
---
--- Parameters
--- * funcTable - a table consisting of individual functions in a sequence
--- * operation - a string to uniquely identify the operation
---
--- Returns:
--- * an anonymous function to be executed
function obj:op(funcTable, operation)
  local iter = _chainIterator(funcTable, operation, operation)
  return iter()
end

return obj
