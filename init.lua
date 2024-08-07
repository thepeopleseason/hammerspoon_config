hs.window.animationDuration = 0
hs.loadSpoon("Chains")

-- private details untracked in github
private = require("private")

scn = require("screens").init()
u = require("utils")
url = require("urls")
chain = spoon.Chains

hs.hotkey.setLogLevel('warning')
local bind = hs.hotkey.bind
local browsers = {"Google Chrome", "Firefox"}

-- general geometry definitions
local ur = hs.geometry.unitrect
geos = {
  fs = ur(0.0, 0.0, 1.0, 1.0),
  llarge = ur(0.0, 0.0, 0.666, 1.0),
  lhalf = ur(0.0, 0.0, 0.5, 1.0),
  rlarge = ur(0.333, 0.0, 0.666, 1.0),
  rhalf = ur(0.5, 0.0, 0.5, 1.0),

  tlarge = ur(0.0, 0.0, 1.0, 0.666),
  thalf = ur(0.0, 0.0, 1.0, 0.5),
  blarge = ur(0.0, 0.333, 1.0, 0.666),
  bhalf = ur(0.0, 0.5, 1.0, 0.5),

  ltq = ur(0.0, 0.0, 0.5, 0.5),
  lbq = ur(0.0, 0.5, 0.5, 0.5),
  rtq = ur(0.5, 0.0, 0.5, 0.5),
  rbq = ur(0.5, 0.5, 0.5, 0.5),

  l3 = ur(0.0, 0.0, 0.333, 1.0),
  m3 = ur(0.333, 0.0, 0.333, 1.0),
  r3 = ur(0.666, 0.0, 0.333, 1.0),

  lt3 = ur(0.0, 0.0, 0.333, 0.5),
  mt3 = ur(0.333, 0.0, 0.333, 0.5),
  rt3 = ur(0.666, 0.0, 0.333, 0.5),

  lt6 = ur(0.0, 0.0, 0.666, 0.5),
  rt6 = ur(0.333, 0.0, 0.666, 0.5),

  lb3 = ur(0.0, 0.5, 0.333, 0.5),
  mb3 = ur(0.333, 0.5, 0.333, 0.5),
  rb3 = ur(0.666, 0.5, 0.333, 0.5),

  lb6 = ur(0.0, 0.5, 0.666, 0.5),
  rb6 = ur(0.333, 0.5, 0.666, 0.5),

  t3 = ur(0.0, 0.0, 1.0, 0.333),
  c3 = ur(0.0, 0.333, 1.0, 0.333),
  b3 = ur(0.0, 0.666, 1.0, 0.333),

  term = ur(0.0, 0.0, 0.29, 0.99),
  termr = ur(0.7, 0.0, 0.29, 0.99),
}

-- layouts for use with hs.layout.apply(), placeWins(), and chain:link()
layouts = {
  -- hs.layout.apply() layouts
  laptop = {
    {"Slack", nil, scn.screens[1], geos["fs"], nil, nil},
    {"Google Chrome", nil, scn.screens[1], geos["fs"], nil, nil},
    {"Firefox", nil, scn.screens[1], geos["fs"], nil, nil},
    {"Terminal", nil, scn.screens[1], geos["lhalf"], nil, nil},
  },
  code2 = {
    {"Slack", nil, scn.screens[2], geos["bhalf"], nil, nil},
    {"Terminal", nil, scn.screens[1], geos["l3"], nil, nil},
  },
  filemgmt = {
    {"Terminal", nil, scn.screens[1], geos["m3"], nil, nil},
  },

  -- placeWins() layouts
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

    lu = {geos["lt3"], geos["lt6"], geos["ltq"]},
    up = {geos["thalf"], geos["tlarge"], geos["t3"]},
    ru = {geos["rt3"], geos["rt6"], geos["rtq"]},

    left = {geos["lhalf"], geos["llarge"], geos["l3"]},
    center = {geos["fs"], geos["m3"], geos["c3"]},
    right = {geos["rhalf"], geos["rlarge"], geos["r3"]},

    ld = {geos["lb3"], geos["lb6"], geos["lbq"]},
    down = {geos["bhalf"], geos["blarge"], geos["b3"]},
    rd = {geos["rb3"], geos["rb6"], geos["rbq"]},

    full_grid = {
      geos["l3"], geos["m3"], geos["r3"],
      geos["ltq"], geos["rtq"], geos["lbq"], geos["rbq"],
      geos["lt3"], geos["mt3"], geos["rt3"],
      geos["lb3"], geos["mb3"], geos["rb3"],
      geos["t3"], geos["c3"], geos["b3"]
    },
  },
}

-- window filter defaults
function getWF(app, filter)
  local wf=hs.window.filter
  filter = filter or {
    currentSpace=true,
    rejectTitles={"Voice", "MCCal", "Slack", "DAKboard", private.p_app},
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
  hs.spaces.gotoSpace(screenTable[nIdx])
end

local function moveScreen(dir)
  local win = hs.window.focusedWindow()
  local axApp = hs.axuielement.applicationElement(win:application())
  local wasEnhanced = axApp.AXEnhancedUserInterface
  if wasEnhanced then
    axApp.AXEnhancedUserInterface = false
  end
  if dir == "left" then
    win:moveOneScreenWest(false, true)
  elseif dir == "right" then
    win:moveOneScreenEast(false, true)
  end
  if wasEnhanced then
    axApp.AXEnhancedUserInterface = wasEnhanced
  end
  win:focus()
end

local function placeWins(wins, layout)
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
  if     #wins == 2 then placeWins(wins, layouts["halves"])
  elseif #wins == 3 then placeWins(wins, layouts["thirds"])
  elseif #wins == 4 then placeWins(wins, layouts["quads"])
  elseif #wins >= 5 then placeWins(wins, layouts["sixths"])
  end
end

local function twoScreen(utilGeo, slackGeo, browserGeo)
  placeWins(getWF("Terminal"):getWindows(),
            {{geos["term"], scn.screens[1]}, {geos["termr"], scn.screens[1]}})
  placeWins(getWF(browsers):getWindows(), browserGeo)
  placeWins(getWF(browsers, {allowTitles={"Voice", "MCCal"}}):getWindows(),
            {{geos[utilGeo], scn.screens[2]}})
  placeWins(getWF("Slack", {}):getWindows(), {{geos[slackGeo], scn.screens[2]}})
end

-- function chain sequences
twoScreen_chain = {
  function() twoScreen("tlarge", "blarge", layouts["halves"]) end,
  function() twoScreen("blarge", "tlarge", layouts["halves"]) end,
  function() twoScreen("fs", "fs", {{geos["llarge"], scn.screens[1]}}) end,
}

browser_chain = {
  function() placeWins(getWF(browsers):getWindows(), layouts["halves"]) end,
  function() placeWins(getWF(browsers):getWindows(), layouts["thirds"]) end,
  function() placeWins(getWF(browsers):getWindows(), layouts["quads"]) end,
  function() placeWins(getWF(browsers):getWindows(), layouts["sixths"]) end,
}

-- common modifiers
local hyper = {"ctrl", "alt", "cmd"}
local hmain = {"cmd", "alt"}

-- resize modal bindings: hyper-r to enter mode
local resize = hs.hotkey.modal.new(hyper, 'r', "Resize mode")
resize:bind(nil, 'left', function() adjust("w", -20) end)
resize:bind(nil, 'right', function() adjust("w", 20) end)
resize:bind(nil, 'up', function() adjust("h", -20) end)
resize:bind(nil, 'down', function() adjust("h", 20) end)
resize:bind(nil, 'escape', function() resize:exit() hs.alert'Exited resize mode' end)

-- nudge modal bindings: hyper-n to enter mode
-- (move windows 50 pixels in a given direction without resizing)
local nudge = hs.hotkey.modal.new(hyper, 'n', 'Nudge mode')
nudge:bind(nil, 'left', function() adjust("x", -50) end)
nudge:bind(nil, 'right', function() adjust("x", 50) end)
nudge:bind(nil, 'up', function() adjust("y", -50) end)
nudge:bind(nil, 'down', function() adjust("y", 50) end)
nudge:bind(nil, 'escape', function() nudge:exit() hs.alert'Exited nudge mode' end)

-- throw bindings: move current window one screen to the left/right
bind(hyper, 'left', function() moveScreen("left") end)
bind(hyper, 'right', function() moveScreen("right") end)

-- resize chain bindings: resize current window based on a list of geometries
bind(hmain, 'pad7', function() chain:link(layouts["chain"]["lu"], "lu") end)
bind(hmain, 'home', function() chain:link(layouts["chain"]["lu"], "lu") end)
bind(hmain, 'pad8', function() chain:link(layouts["chain"]["up"], "u") end)
bind(hmain, 'up', function() chain:link(layouts["chain"]["up"], "u") end)
bind(hmain, 'pad9', function() chain:link(layouts["chain"]["ru"], "ru") end)
bind(hmain, 'pageup', function() chain:link(layouts["chain"]["ru"], "ru") end)
bind(hmain, 'left', function() chain:link(layouts["chain"]["left"], "l") end)
bind(hmain, 'pad4', function() chain:link(layouts["chain"]["left"], "l") end)
bind(hmain, 'pad5', function() chain:link(layouts["chain"]["center"], "c") end)
bind(hmain, 'forwarddelete', function() chain:link(layouts["chain"]["center"], "c") end)
bind(hmain, 'f', function() chain:link(layouts["chain"]["center"], "c") end)
bind(hmain, 'right', function() chain:link(layouts["chain"]["right"], "r") end)
bind(hmain, 'pad6', function() chain:link(layouts["chain"]["right"], "r") end)
bind(hmain, 'pad1', function() chain:link(layouts["chain"]["ld"], "ld") end)
bind(hmain, 'end', function() chain:link(layouts["chain"]["ld"], "ld") end)
bind(hmain, 'down', function() chain:link(layouts["chain"]["down"], "d") end)
bind(hmain, 'pad2', function() chain:link(layouts["chain"]["down"], "d") end)
bind(hmain, 'pad3', function() chain:link(layouts["chain"]["rd"], "rd") end)
bind(hmain, 'pagedown', function() chain:link(layouts["chain"]["rd"], "rd") end)
bind(hmain, 't', function() chain:link(layouts["chain"]["term"], "t") end)

-- other bindings
bind({'ctrl', 'alt'}, 'left', function() moveOneSpace("left") end)
bind({'ctrl', 'alt'}, 'right', function() moveOneSpace("right") end)
bind({'ctrl', 'alt'}, 'up', function() chain:link(layouts["chain"]["full_grid"], "g") end)
bind({'ctrl', 'alt'}, 'down', function() hs.window.focusedWindow():sendToBack() end)

-- functional layout bindings
bind(hmain, 'q', function()
  placeWins(getWF("zoom.us"):getWindows(), {{geos["l3"], scn.screens[1]}})
  wins = getWF():rejectApp("zoom.us"):getWindows()
  if     #wins == 1 then placeWins(wins, {{geos["rlarge"], scn.screens[1]}})
  elseif #wins  > 1 then placeWins(wins, layouts["r3s"])
  end
end)
bind(hmain, 'm', function()
  hs.layout.apply(layouts["filemgmt"])
  placeWins(getWF("Finder"):getWindows(),
            {{geos["lt3"], scn.screens[1]}, {geos["lb3"], scn.screens[1]}})
  placeWins(getWF():rejectApp("Finder"):rejectApp("PingID")
            :rejectApp("Terminal"):getWindows(), layouts["r3s"])
end)

bind(hmain, '1', function() hs.layout.apply(layouts["laptop"]) end)
bind(hmain, '2', function() chain:op(twoScreen_chain, '2')() end)
bind(hmain, '9', function() pane(getWF(nil,{}):getWindows()) end)
bind(hyper, '9', function() pane(hs.window.focusedWindow():application():allWindows()) end)
bind(hmain, 'w', function() chain:op(browser_chain, 'w')() end)

-- watchers and utilities
local utils = hs.hotkey.modal.new(hyper, 'u', "Utility mode")
utils:bind(nil, 'a', function() u.switchAudio() utils:exit() end)
utils:bind(nil, 'c', function() hs.toggleConsole() utils:exit() end)
utils:bind(nil, 'd', function() hs.alert(scn.screenList) utils:exit() end)
utils:bind(nil, 'h', function() hs.alert(hs.host.localizedName()) utils:exit() end)
utils:bind(nil, 'i', function()
  if scn.mainDdcID then scn.switchMonitorInput() end
  utils:exit()
end)
utils:bind(nil, 'n', function()
  hs.network.ping.ping("8.8.8.8", 1, 0.01, 1.0, "any", u.pingResult)
  utils:exit()
end)
utils:bind(nil, '0', function() hs.reload() utils:exit() end)
utils:bind(nil, 'escape', function() utils:exit() hs.alert'Exited utility mode' end)

bind(hyper, 'd', function() hs.eventtap.keyStrokes(os.date('%Y-%m-%d')) end)
bind(hyper, 'i', function() if scn.mainDdcID then scn.switchMonitorInput(true) end end)
bind(hyper, 'm', function() hs.application.launchOrFocus("monitorControl") end)
bind(hyper, 'p', function() private.focus_p() end)
bind(hyper, 'v', function() private.toggle_v() end)

hs.hotkey.showHotkeys(hmain, 'k')

hs.ipc.cliStatus() -- load IPC for commandline util
hs.alert'Config loaded'

