hs.window.animationDuration = 0

hs.loadSpoon("Caffeine")
spoon.Caffeine:start()

scn = require("screens")

local function myScreens()
  if hs.screen(scn.dellScreen) then
    mc = require("monitor_control")
    mc.init()
    return { hs.screen(scn.dellScreen), hs.screen(scn.samsungScreen) }
  elseif hs.screen(scn.miamiScreen) then
    return { hs.screen(scn.miamiScreen), hs.screen(scn.mbpScreen) }
  else
    return { hs.screen(scn.mbpScreen), hs.screen(scn.mbpScreen) }
  end
end

local bind = hs.hotkey.bind
local fnutils = hs.fnutils
local geo = hs.geometry

local browsers = {"Google Chrome", "Firefox"}

local hostname = hs.host.localizedName()

-- general geometry definitions
geos = {
  fs = geo.unitrect(0.0, 0.0, 1.0, 1.0),
  llarge = geo.unitrect(0.0, 0.0, 0.66, 1.0),
  lhalf = geo.unitrect(0.0, 0.0, 0.5, 1.0),
  rlarge = geo.unitrect(0.33, 0.0, 0.66, 1.0),
  rhalf = geo.unitrect(0.5, 0.0, 0.5, 1.0),

  tlarge = geo.unitrect(0.0, 0.0, 1.0, 0.66),
  thalf = geo.unitrect(0.0, 0.0, 1.0, 0.5),
  blarge = geo.unitrect(0.0, 0.34, 1.0, 0.67),
  bhalf = geo.unitrect(0.0, 0.5, 1.0, 0.5),

  ltq = geo.unitrect(0.0, 0.0, 0.5, 0.5),
  lbq = geo.unitrect(0.0, 0.5, 0.5, 0.5),
  rtq = geo.unitrect(0.5, 0.0, 0.5, 0.5),
  rbq = geo.unitrect(0.5, 0.5, 0.5, 0.5),

  l3 = geo.unitrect(0.0, 0.0, 0.33, 1.0),
  m3 = geo.unitrect(0.33, 0.0, 0.33, 1.0),
  r3 = geo.unitrect(0.66, 0.0, 0.33, 1.0),

  lt3 = geo.unitrect(0.0, 0.0, 0.33, 0.5),
  mt3 = geo.unitrect(0.33, 0.0, 0.33, 0.5),
  rt3 = geo.unitrect(0.66, 0.0, 0.33, 0.5),

  lb3 = geo.unitrect(0.0, 0.5, 0.33, 0.5),
  mb3 = geo.unitrect(0.33, 0.5, 0.33, 0.5),
  rb3 = geo.unitrect(0.66, 0.5, 0.33, 0.5),

  t3 = geo.unitrect(0.0, 0.0, 1.0, 0.33),
  c3 = geo.unitrect(0.0, 0.33, 1.0, 0.33),
  b3 = geo.unitrect(0.0, 0.66, 1.0, 0.33),

  term = geo.unitrect(0.0, 0.0, 0.29, 0.99),
  termr = geo.unitrect(0.7, 0.0, 0.29, 0.99),
}

-- layouts for use with hs.layout.apply(), layoutApp(), and chain()
layouts = {
  -- hs.layout.apply() layouts
  laptop = {
    {"Slack", nil, myScreens()[1], geos["fs"], nil, nil},
    {"Google Chrome", nil, myScreens()[1], geos["fs"], nil, nil},
    {"Firefox", nil, myScreens()[1], geos["fs"], nil, nil},
    {"Terminal", nil, myScreens()[1], geos["lhalf"], nil, nil},
  },
  home3 = {
    {"Slack", nil, myScreens()[2], geos["blarge"], nil, nil},
    {"zoom.us", nil, myScreens()[1], geos["l3"], nil, nil},
  },
  v2 = {
    {"Slack", nil, myScreens()[2], geos["fs"], nil, nil},
    {"Terminal", nil, myScreens()[1], geos["t3"], nil, nil},
  },
  pcm2 = {
    {"Slack", nil, myScreens()[2], geos["fs"], nil, nil},
    {"Terminal", nil, myScreens()[1], geos["r3"], nil, nil},
  },
  code2 = {
    {"Slack", nil, myScreens()[2], geos["bhalf"], nil, nil},
    {"Terminal", nil, myScreens()[1], geos["l3"], nil, nil},
  },
  filemgmt = {
    {"Terminal", nil, myScreens()[1], geos["m3"], nil, nil},
  },

  -- layoutApp() layouts
  halves = {
    {geos["lhalf"], myScreens()[1]}, {geos["rhalf"], myScreens()[1]},
  },
  thirds = {
    {geos["l3"], myScreens()[1]}, {geos["m3"], myScreens()[1]},
    {geos["r3"], myScreens()[1]},
  },
  quads = {
    {geos["ltq"], myScreens()[1]}, {geos["rtq"], myScreens()[1]},
    {geos["lbq"], myScreens()[1]}, {geos["rbq"], myScreens()[1]},
  },
  sixths = {
    {geos["lt3"], myScreens()[1]}, {geos["mt3"], myScreens()[1]},
    {geos["rt3"], myScreens()[1]}, {geos["lb3"], myScreens()[1]},
    {geos["mb3"], myScreens()[1]}, {geos["rb3"], myScreens()[1]},
  },
  r3s = {
    {geos["m3"], myScreens()[1]}, {geos["r3"], myScreens()[1]},
  },

  -- chain sequences (see chain() function below)
  chain = {
    term = { geos["term"], geos["termr"] },
    left = { geos["lhalf"], geos["llarge"], geos["l3"] },
    right = { geos["rhalf"], geos["rlarge"], geos["r3"] },
    up = { geos["thalf"], geos["tlarge"], geos["t3"] },
    down = { geos["bhalf"], geos["blarge"], geos["b3"] },

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
    rejectTitles={"Voice", "MCCal"},
    visible=true
  }

  if app then
    return wf.new(app):setOverrideFilter(filter)
  else
    return wf.new(false):setDefaultFilter(filter)
  end
end

-- chain functions: use the same keybinding to cycle through a sequence
-- of geometries.
local winChains = {}
local function winChainIter(t, id, op)
  if not (type(winChains[id]) == "table" and winChains[id][op]) then
    winChains[id] = {}
    winChains[id][op] = true
    winChains[id]["index"] = 0
  end

  local i, n = winChains[id]["index"], #t
  return function()
    i = i + 1
    if i > n then i = 1 end
    winChains[id]["index"] = i
    return t[i]
  end
end

local function chain(t, op, win)
  local win = win or hs.window.focusedWindow()
  local iter = winChainIter(t, win:id(), op)
  win:move(iter())
end

local function moveOneSpace(dir)
  local win = hs.window.focusedWindow()
  local uuid = win:screen():getUUID()
  local spaceID = hs.spaces.activeSpaces()[uuid]
  local screenTable = hs.spaces.allSpaces()[uuid]
  local cIndex = fnutils.indexOf(screenTable, spaceID)
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

local function layoutApp(wins, layout)
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
  if     #wins == 2 then layoutApp(wins, layouts["halves"])
  elseif #wins == 3 then layoutApp(wins, layouts["thirds"])
  elseif #wins == 4 then layoutApp(wins, layouts["quads"])
  elseif #wins >= 5 then layoutApp(wins, layouts["sixths"])
  end
end

local function switchAudio()
  local filter = { "S23C570", "ZoomAudioDevice" }
  local choiceList = fnutils.filter(
    hs.audiodevice.allOutputDevices(),
    function(el) return not fnutils.contains(filter, el:name()) end)

  local chooser = hs.chooser.new(
    function(choice)
      if choice then
        local dev = hs.audiodevice.findDeviceByName(choice["text"])
        if dev and dev:setDefaultOutputDevice() then
          hs.alert.show("🔈" .. dev:name())
        end
      end
    end)
  chooser:choices(
    fnutils.map(choiceList, function(el) return { ["text"] = el:name() } end))
  chooser:placeholderText("Choose audio output:"):rows(1):width(20):show()
end

function pingResult(object, message, seqnum, error)
  if message == "didFinish" then
    avg = tonumber(string.match(object:summary(), '/(%d+.%d+)/'))
    if avg == 0.0 then
      hs.alert.show("No network")
    elseif avg < 200.0 then
      hs.alert.show("Network good (" .. avg .. "ms)")
    elseif avg < 500.0 then
      hs.alert.show("Network poor(" .. avg .. "ms)")
    else
      hs.alert.show("Network bad(" .. avg .. "ms)")
    end
  end
end

-- testing
local scnChange = hs.screen.watcher.new(function() hs.reload() hs.alert'Config loaded' end)

-- common modifiers
local hyper = {"ctrl", "alt", "cmd"}
local hmain = {"cmd", "alt"}

-- resize bindings
local resize = hs.hotkey.modal.new(hyper, 'r', "Resize mode")
resize:bind(nil, "left", function () adjust("w", -20) end)
resize:bind(nil, "right", function () adjust("w", 20) end)
resize:bind(nil, "up", function () adjust("h", -20) end)
resize:bind(nil, "down", function () adjust("h", 20) end)
resize:bind(nil, 'escape', function() resize:exit() hs.alert'Exited resize mode' end)
bind(hmain, "f", function() hs.window.focusedWindow():maximize() end)

-- nudge bindings
local nudge = hs.hotkey.modal.new(hyper, 'n', "Nudge mode")
nudge:bind(nil, "left", function () adjust("x", -50) end)
nudge:bind(nil, "right", function () adjust("x", 50) end)
nudge:bind(nil, "up", function () adjust("y", -50) end)
nudge:bind(nil, "down", function () adjust("y", 50) end)
nudge:bind(nil, 'escape', function() nudge:exit() hs.alert'Exited nudge mode' end)

-- throw bindings
bind(hyper, "left", function() hs.window.focusedWindow():moveOneScreenWest(false, true) end)
bind(hyper, "right", function() hs.window.focusedWindow():moveOneScreenEast(false, true) end)
bind({"ctrl", "alt"}, "left", function() moveOneSpace("left") end)
bind({"ctrl", "alt"}, "right", function() moveOneSpace("right") end)

-- chain bindings
bind(hmain, "left", function() chain(layouts["chain"]["left"], "l") end)
bind(hmain, "right", function() chain(layouts["chain"]["right"], "r") end)
bind(hmain, "up", function () chain(layouts["chain"]["up"], "u") end)
bind(hmain, "down", function() chain(layouts["chain"]["down"], "d") end)
bind(hmain, "t", function() chain(layouts["chain"]["term"], "t") end)
bind({"ctrl", "shift"}, "right", function() chain(layouts["chain"]["full_grid"], "g") end)

-- layout bindings
bind(hmain, "q", function()
  layoutApp(getWF("zoom.us"):getWindows(), {{geos["l3"], myScreens()[1]}})
  wins = getWF():rejectApp("zoom.us"):rejectApp("Slack"):getWindows()
  if     #wins == 1 then layoutApp(wins, {{geos["rlarge"], myScreens()[1]}})
  elseif #wins  > 1 then layoutApp(wins, layouts["r3s"])
  end
end)
bind(hmain, "v", function() hs.layout.apply(layouts["v2"]) end)
bind(hmain, "m", function()
  hs.layout.apply(layouts["filemgmt"])
  layoutApp(getWF("Finder"):getWindows(),
            {{geos["lt3"], myScreens()[1]}, {geos["lb3"], myScreens()[1]}})
  layoutApp(getWF():rejectApp("Finder"):rejectApp("Slack")
            :rejectApp("Terminal"):getWindows(), layouts["r3s"])
end)
bind(hmain, "1", function() hs.layout.apply(layouts["laptop"]) end)
bind(hmain, "2", function() hs.layout.apply(layouts["pcm2"]) end)
bind(hmain, "3", function() hs.layout.apply(layouts["home3"])
       layoutApp(getWF("Terminal"):getWindows(),
                 {{geos["term"], myScreens()[1]}, {geos["termr"], myScreens()[1]}})
       layoutApp(getWF(browsers):getWindows(), layouts["halves"])
       layoutApp(getWF(browsers, {allowTitles={"Voice", "MCCal"}}):getWindows(),
                 {{geos["t3"], myScreens()[2]}})
     end)

bind(hmain, "h", function() layoutApp(getWF(browsers):getWindows(), layouts["halves"]) end)
bind(hmain, "4", function() layoutApp(getWF(browsers):getWindows(), layouts["quads"]) end)
bind(hmain, "9", function() pane(getWF(nil,{}):getWindows()) end)
bind(hyper, "9", function() pane(hs.window.focusedWindow():application():allWindows()) end)

-- utility bindings
bind(hyper, "d", function() hs.eventtap.keyStrokes(os.date('%Y-%m-%d')) end)
bind(hyper, "i", function() if mc.dellID then mc.switchMonitorInput() end end)
bind(hyper, "p", function() hs.application.launchOrFocus("PingID") end)

local utils = hs.hotkey.modal.new(hyper, 'u', "Utility mode")
utils:bind(nil, 'a', function() switchAudio() utils:exit() end)
utils:bind(nil, 'c', function() hs.toggleConsole() utils:exit() end)
utils:bind(nil, 'h', function() hs.alert(hostname) utils:exit() end)
utils:bind(nil, 'n', function()
  hs.network.ping.ping("8.8.8.8", 1, 0.01, 1.0, "any", pingResult)
  utils:exit()
end)
utils:bind(nil, 'escape', function() utils:exit() hs.alert'Exited utility mode' end)

bind(hmain, "0", 'Reload config', function() hs.reload() end)

hs.hotkey.showHotkeys(hmain, 'k')
hs.ipc.cliStatus() -- load IPC for commandline util
hs.alert'Config loaded'
