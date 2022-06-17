hs.window.animationDuration = 0
hs.loadSpoon("Chains")

-- private details untracked in github
private = require("private")

scn = require("screens").init()
u = require("utils")
url = require("urls")
chain = spoon.Chains

local bind = hs.hotkey.bind
local browsers = {"Google Chrome", "Firefox"}

-- general geometry definitions
local ur = hs.geometry.unitrect
geos = {
  fs = ur(0.0, 0.0, 1.0, 1.0),
  llarge = ur(0.0, 0.0, 0.66, 1.0),
  lhalf = ur(0.0, 0.0, 0.5, 1.0),
  rlarge = ur(0.33, 0.0, 0.66, 1.0),
  rhalf = ur(0.5, 0.0, 0.5, 1.0),

  tlarge = ur(0.0, 0.0, 1.0, 0.66),
  thalf = ur(0.0, 0.0, 1.0, 0.5),
  blarge = ur(0.0, 0.34, 1.0, 0.67),
  bhalf = ur(0.0, 0.5, 1.0, 0.5),

  ltq = ur(0.0, 0.0, 0.5, 0.5),
  lbq = ur(0.0, 0.5, 0.5, 0.5),
  rtq = ur(0.5, 0.0, 0.5, 0.5),
  rbq = ur(0.5, 0.5, 0.5, 0.5),

  l3 = ur(0.0, 0.0, 0.33, 1.0),
  m3 = ur(0.33, 0.0, 0.33, 1.0),
  r3 = ur(0.66, 0.0, 0.33, 1.0),

  lt3 = ur(0.0, 0.0, 0.33, 0.5),
  mt3 = ur(0.33, 0.0, 0.33, 0.5),
  rt3 = ur(0.66, 0.0, 0.33, 0.5),

  lb3 = ur(0.0, 0.5, 0.33, 0.5),
  mb3 = ur(0.33, 0.5, 0.33, 0.5),
  rb3 = ur(0.66, 0.5, 0.33, 0.5),

  t3 = ur(0.0, 0.0, 1.0, 0.33),
  c3 = ur(0.0, 0.33, 1.0, 0.33),
  b3 = ur(0.0, 0.66, 1.0, 0.33),

  term = ur(0.0, 0.0, 0.29, 0.99),
  termr = ur(0.7, 0.0, 0.29, 0.99),
}

-- layouts for use with hs.layout.apply(), layoutWins(), and chain:link()
layouts = {
  -- hs.layout.apply() layouts
  laptop = {
    {"Slack", nil, scn.screens[1], geos["fs"], nil, nil},
    {"Google Chrome", nil, scn.screens[1], geos["fs"], nil, nil},
    {"Firefox", nil, scn.screens[1], geos["fs"], nil, nil},
    {"Terminal", nil, scn.screens[1], geos["lhalf"], nil, nil},
  },
  home3 = {
    {"zoom.us", nil, scn.screens[1], geos["l3"], nil, nil},
    {"Slack", nil, scn.screens[2], geos["blarge"], nil, nil},
  },
  v2 = {
    {"Slack", nil, scn.screens[2], geos["fs"], nil, nil},
    {"Terminal", nil, scn.screens[1], geos["t3"], nil, nil},
  },
  pcm2 = {
    {"Slack", nil, scn.screens[2], geos["fs"], nil, nil},
    {"Terminal", nil, scn.screens[1], geos["r3"], nil, nil},
  },
  code2 = {
    {"Slack", nil, scn.screens[2], geos["bhalf"], nil, nil},
    {"Terminal", nil, scn.screens[1], geos["l3"], nil, nil},
  },
  filemgmt = {
    {"Terminal", nil, scn.screens[1], geos["m3"], nil, nil},
  },

  -- layoutWins() layouts
  halves = {
    {geos["lhalf"], scn.screens[1]}, {geos["rhalf"], scn.screens[1]},
  },
  thirds = {
    {geos["l3"], scn.screens[1]}, {geos["m3"], scn.screens[1]},
    {geos["r3"], scn.screens[1]},
  },
  quads = {
    {geos["ltq"], scn.screens[1]}, {geos["rtq"], scn.screens[1]},
    {geos["lbq"], scn.screens[1]}, {geos["rbq"], scn.screens[1]},
  },
  sixths = {
    {geos["lt3"], scn.screens[1]}, {geos["mt3"], scn.screens[1]},
    {geos["rt3"], scn.screens[1]}, {geos["lb3"], scn.screens[1]},
    {geos["mb3"], scn.screens[1]}, {geos["rb3"], scn.screens[1]},
  },
  r3s = {
    {geos["m3"], scn.screens[1]}, {geos["r3"], scn.screens[1]},
  },

  -- chain sequences (see Chains.spoon)
  chain = {
    term = {geos["term"], geos["termr"]},
    left = {geos["lhalf"], geos["llarge"], geos["l3"]},
    right = {geos["rhalf"], geos["rlarge"], geos["r3"]},
    up = {geos["thalf"], geos["tlarge"], geos["t3"]},
    down = {geos["bhalf"], geos["blarge"], geos["b3"]},

    full_grid = {
      geos["ltq"], geos["rtq"], geos["lbq"], geos["rbq"],
      geos["l3"], geos["m3"], geos["r3"],
      geos["t3"], geos["c3"], geos["b3"],
      geos["lt3"], geos["mt3"], geos["rt3"],
      geos["lb3"], geos["mb3"], geos["rb3"]
    },
  },
}

-- window filter defaults
function getWF(app, filter)
  local wf=hs.window.filter
  filter = filter or {
    currentSpace=true,
    rejectTitles={"Voice", "MCCal", "Slack"},
    visible=true
  }

  if app then
    return wf.new(app):setOverrideFilter(filter)
  else
    return wf.new(false):setDefaultFilter(filter)
  end
end

local function moveOneSpace(dir)
  local win = hs.window.focusedWindow()
  local uuid = win:screen():getUUID()
  local spaceID = hs.spaces.activeSpaces()[uuid]
  local screenTable = hs.spaces.allSpaces()[uuid]
  local cIndex = hs.fnutils.indexOf(screenTable, spaceID)
  local nIdx
  if dir == "left" then
    nIdx = cIndex - 1
    if nIdx < 1 then nIdx = 1 end
  elseif dir == "right" then
    nIdx = cIndex + 1
    if nIdx > #screenTable then nIdx = #screenTable end
  end
  hs.spaces.moveWindowToSpace(win:id(), screenTable[nIdx])
end

local function layoutWins(wins, layout)
  for i, win in ipairs(wins) do
    local layout_index = i
    if layout_index > #layout then layout_index = #layout end
    win:moveToScreen(layout[layout_index][2])
    win:move(layout[layout_index][1])
  end
end

local function adjust(dim, amt)
  local win = hs.window.focusedWindow()
  local f = win:frame()
  f[dim] = f[dim] + amt
  win:setFrame(f)
end

local function pane(wins)
  if     #wins == 2 then layoutWins(wins, layouts["halves"])
  elseif #wins == 3 then layoutWins(wins, layouts["thirds"])
  elseif #wins == 4 then layoutWins(wins, layouts["quads"])
  elseif #wins >= 5 then layoutWins(wins, layouts["sixths"])
  end
end

-- common modifiers
local hyper = {"ctrl", "alt", "cmd"}
local hmain = {"cmd", "alt"}

-- resize modal bindings: hyper-r to enter mode
local resize = hs.hotkey.modal.new(hyper, 'r', "Resize mode")
resize:bind(nil, "left", function() adjust("w", -20) end)
resize:bind(nil, "right", function() adjust("w", 20) end)
resize:bind(nil, "up", function() adjust("h", -20) end)
resize:bind(nil, "down", function() adjust("h", 20) end)
resize:bind(nil, 'escape', function() resize:exit() hs.alert'Exited resize mode' end)
bind(hmain, "f", function() hs.window.focusedWindow():maximize() end)

-- nudge modal bindings: hyper-n to enter mode
-- (move windows 50 pixels in a given direction without resizing)
local nudge = hs.hotkey.modal.new(hyper, 'n', "Nudge mode")
nudge:bind(nil, "left", function() adjust("x", -50) end)
nudge:bind(nil, "right", function() adjust("x", 50) end)
nudge:bind(nil, "up", function() adjust("y", -50) end)
nudge:bind(nil, "down", function() adjust("y", 50) end)
nudge:bind(nil, 'escape', function() nudge:exit() hs.alert'Exited nudge mode' end)

-- throw bindings: move current window one screen to the left/right
bind(hyper, "left", function() hs.window.focusedWindow():moveOneScreenWest(false, true):focus() end)
bind(hyper, "right", function() hs.window.focusedWindow():moveOneScreenEast(false, true):focus() end)

-- chain bindings: resize current window based on a list of geometries
bind(hmain, "left", function() chain:link(layouts["chain"]["left"], "l") end)
bind(hmain, "right", function() chain:link(layouts["chain"]["right"], "r") end)
bind(hmain, "up", function() chain:link(layouts["chain"]["up"], "u") end)
bind(hmain, "down", function() chain:link(layouts["chain"]["down"], "d") end)
bind(hmain, "t", function() chain:link(layouts["chain"]["term"], "t") end)

-- other bindings
bind({"ctrl", "shift"}, "left", function() moveOneSpace("left") end)
bind({"ctrl", "shift"}, "right", function() moveOneSpace("right") end)
bind({"ctrl", "shift"}, "up", function() chain:link(layouts["chain"]["full_grid"], "g") end)

-- functional layout bindings
bind(hmain, "q", function()
  layoutWins(getWF("zoom.us"):getWindows(), {{geos["l3"], scn.screens[1]}})
  wins = getWF():rejectApp("zoom.us"):getWindows()
  if     #wins == 1 then layoutWins(wins, {{geos["rlarge"], scn.screens[1]}})
  elseif #wins  > 1 then layoutWins(wins, layouts["r3s"])
  end
end)
bind(hmain, "v", function() hs.layout.apply(layouts["v2"]) end)
bind(hmain, "m", function()
  hs.layout.apply(layouts["filemgmt"])
  layoutWins(getWF("Finder"):getWindows(),
            {{geos["lt3"], scn.screens[1]}, {geos["lb3"], scn.screens[1]}})
  layoutWins(getWF():rejectApp("Finder")
            :rejectApp("Terminal"):getWindows(), layouts["r3s"])
end)
bind(hmain, "1", function() hs.layout.apply(layouts["laptop"]) end)
bind(hmain, "2", function() hs.layout.apply(layouts["pcm2"]) end)
bind(hmain, "3", function()
       layoutWins(getWF("Terminal"):getWindows(),
                 {{geos["term"], scn.screens[1]}, {geos["termr"], scn.screens[1]}})
       layoutWins(getWF(browsers):getWindows(), layouts["halves"])
       layoutWins(getWF(browsers, {allowTitles={"Voice", "MCCal"}}):getWindows(),
                 {{geos["t3"], scn.screens[2]}})
       hs.layout.apply(layouts["home3"])
     end)
bind(hmain, "9", function() pane(getWF(nil,{}):getWindows()) end)
bind(hyper, "9", function() pane(hs.window.focusedWindow():application():allWindows()) end)

-- browser organization
local w3 = hs.hotkey.modal.new(hyper, 'w', "Browser layouts")
w3:bind(nil, "2", function() layoutWins(getWF(browsers):getWindows(), layouts["halves"])
           w3.exit() end)
w3:bind(nil, "3", function() layoutWins(getWF(browsers):getWindows(), layouts["thirds"])
           w3.exit() end)
w3:bind(nil, "4", function() layoutWins(getWF(browsers):getWindows(), layouts["quads"])
           w3.exit() end)
w3:bind(nil, "5", function() layoutWins(getWF(browsers):getWindows(), layouts["sixths"])
           w3.exit() end)
w3:bind(nil, "escape", function() w3:exit() hs.alert'Exit browser layout mode' end)

-- watchers and utilities
local scnChange = hs.screen.watcher.new(
  function() hs.reload() hs.alert'Screen update, config reloaded' end):start()

bind(hyper, "d", function() hs.eventtap.keyStrokes(os.date('%Y-%m-%d')) end)
bind(hyper, "i", function() if scn.mainDdcID then scn.switchMonitorInput() end end)
bind(hyper, "p", function() hs.application.launchOrFocus(private.p_app) end)

local utils = hs.hotkey.modal.new(hyper, 'u', "Utility mode")
utils:bind(nil, 'a', function() u.switchAudio() utils:exit() end)
utils:bind(nil, 'c', function() hs.toggleConsole() utils:exit() end)
utils:bind(nil, 'h', function() hs.alert(hs.host.localizedName()) utils:exit() end)
utils:bind(nil, 'n', function()
  hs.network.ping.ping("8.8.8.8", 1, 0.01, 1.0, "any", u.pingResult)
  utils:exit()
end)
utils:bind(nil, "0", function() hs.reload() utils:exit() end)
utils:bind(nil, 'escape', function() utils:exit() hs.alert'Exited utility mode' end)

hs.hotkey.showHotkeys(hmain, 'k')

hs.ipc.cliStatus() -- load IPC for commandline util
hs.alert'Config loaded'

