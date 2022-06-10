hs.window.animationDuration = 0

hs.loadSpoon("Caffeine")
spoon.Caffeine:start()

-- define constants
-- screens
local laptopScreen = "Built-in Retina Display"
local vScreen = "S23C570"
local dellScreen = "DELL U3419W"
local miamiScreen = "HP S2031"

local function primaryScreen()
  if hs.screen(dellScreen) then
    return hs.screen(dellScreen)
  elseif hs.screen(miamiScreen) then
    return hs.screen(miamiScreen)
  else
    return nil
  end
end

-- keys
local hyper = {"ctrl", "alt", "cmd"}
local bind = hs.hotkey.bind

-- applications
local browsers = {"Google Chrome", "Firefox"}

-- general geometry definitions
geos = {
  fs = hs.geometry.unitrect(0.0, 0.0, 1.0, 1.0),
  llarge = hs.geometry.unitrect(0.0, 0.0, 0.66, 1.0),
  lhalf = hs.geometry.unitrect(0.0, 0.0, 0.5, 1.0),
  rlarge = hs.geometry.unitrect(0.33, 0.0, 0.66, 1.0),
  rhalf = hs.geometry.unitrect(0.5, 0.0, 0.5, 1.0),

  tlarge = hs.geometry.unitrect(0.0, 0.0, 1.0, 0.66),
  thalf = hs.geometry.unitrect(0.0, 0.0, 1.0, 0.5),
  blarge = hs.geometry.unitrect(0.0, 0.34, 1.0, 0.67),
  bhalf = hs.geometry.unitrect(0.0, 0.5, 1.0, 0.5),

  ltq = hs.geometry.unitrect(0.0, 0.0, 0.5, 0.5),
  lbq = hs.geometry.unitrect(0.0, 0.5, 0.5, 0.5),
  rtq = hs.geometry.unitrect(0.5, 0.0, 0.5, 0.5),
  rbq = hs.geometry.unitrect(0.5, 0.5, 0.5, 0.5),

  l3 = hs.geometry.unitrect(0.0, 0.0, 0.33, 1.0),
  m3 = hs.geometry.unitrect(0.33, 0.0, 0.33, 1.0),
  r3 = hs.geometry.unitrect(0.66, 0.0, 0.33, 1.0),

  lt3 = hs.geometry.unitrect(0.0, 0.0, 0.33, 0.5),
  mt3 = hs.geometry.unitrect(0.33, 0.0, 0.33, 0.5),
  rt3 = hs.geometry.unitrect(0.66, 0.0, 0.33, 0.5),

  lb3 = hs.geometry.unitrect(0.0, 0.5, 0.33, 0.5),
  mb3 = hs.geometry.unitrect(0.33, 0.5, 0.33, 0.5),
  rb3 = hs.geometry.unitrect(0.66, 0.5, 0.33, 0.5),

  t3 = hs.geometry.unitrect(0.0, 0.0, 1.0, 0.33),
  c3 = hs.geometry.unitrect(0.0, 0.33, 1.0, 0.33),
  b3 = hs.geometry.unitrect(0.0, 0.66, 1.0, 0.33),

  term = hs.geometry.unitrect(0.0, 0.0, 0.29, 0.99),
  termr = hs.geometry.unitrect(0.7, 0.0, 0.29, 0.99),
}

-- layouts for use with hs.layout.apply(), layoutApp(), and chain()
layouts = {
  -- hs.layout.apply() layouts
  laptop = {
    {"Slack", nil, laptopScreen, geos["fs"], nil, nil},
    {"Google Chrome", nil, laptopScreen, geos["fs"], nil, nil},
    {"Firefox", nil, laptopScreen, geos["fs"], nil, nil},
    {"Terminal", nil, laptopScreen, geos["term"], nil, nil},
  },
  home3 = {
    {"Slack", nil, vScreen, geos["blarge"], nil, nil},
    {"zoom.us", nil, primaryScreen(), geos["l3"], nil, nil},
  },
  v2 = {
    {"Slack", nil, laptopScreen, geos["fs"], nil, nil},
    {"Terminal", nil, primaryScreen(), geos["t3"], nil, nil},
  },
  pcm2 = {
    {"Slack", nil, laptopScreen, geos["fs"], nil, nil},
    {"Terminal", nil, primaryScreen(), geos["r3"], nil, nil},
  },
  code2 = {
    {"Slack", nil, laptopScreen, geos["bhalf"], nil, nil},
    {"Terminal", nil, primaryScreen(), geos["l3"], nil, nil},
  },
  filemgmt = {
    {"Terminal", nil, primaryScreen(), geos["m3"], nil, nil},
  },

  -- layoutApp() layouts
  halves = {
    {geos["lhalf"], primaryScreen()}, {geos["rhalf"], primaryScreen()},
  },
  thirds = {
    {geos["l3"], primaryScreen()}, {geos["m3"], primaryScreen()},
    {geos["r3"], primaryScreen()},
  },
  quads = {
    {geos["ltq"], primaryScreen()}, {geos["rtq"], primaryScreen()},
    {geos["lbq"], primaryScreen()}, {geos["rbq"], primaryScreen()},
  },
  sixths = {
    {geos["lt3"], primaryScreen()}, {geos["mt3"], primaryScreen()},
    {geos["rt3"], primaryScreen()}, {geos["lb3"], primaryScreen()},
    {geos["mb3"], primaryScreen()}, {geos["rb3"], primaryScreen()},
  },
  r3s = {
    {geos["m3"], primaryScreen()}, {geos["r3"], primaryScreen()},
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

-- get current id for dell, if available
local dellID = nil
if hs.screen(dellScreen) then
  hs.task.new(
    "/Users/jhsiao/devel/dotfiles/bin/dell_id",
    function(exitCode, output, err)
      dellID = string.gsub(output, "%s", "")
    end
  ):start():waitUntilExit()
end

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

local function round(x, places)
  local places = places or 0
  local x = x * 10^places
  return (x + 0.5 - (x + 0.5) % 1) / 10^places
end

local function currentWindowRect(win)
  local win = win or hs.window.focusedWindow()
  local ur, r = win:screen():toUnitRect(win:frame()), round
  return {r(ur.x,2), r(ur.y,2), r(ur.w,2), r(ur.h,2)} -- an hs.geometry.unitrect table
end

local function nextPosition(t, urect)
  local nIdx = 1
  local cIdx = hs.fnutils.indexOf(t, hs.geometry.unitrect(urect))
  if cIdx then
    nIdx = cIdx + 1
    if nIdx > #t then nIdx = 1 end
  end
  return t[nIdx]
end

local function chain(t, win)
  local win = win or hs.window.focusedWindow()
  win:move(nextPosition(t, currentWindowRect(win)))
end

local function moveOneSpaceEW(dir)
  local win = hs.window.focusedWindow()
  local uuid = win:screen():getUUID()
  local spaceID = hs.spaces.activeSpaces()[uuid]
  local screenTable = hs.spaces.allSpaces()[uuid]
  local cIndex = hs.fnutils.indexOf(screenTable, spaceID)
  local nIdx
  if dir == "west" then
    nIdx = cIndex - 1
    if nIdx < 1 then nIdx = 1 end
  elseif dir == "east" then
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

local function gridify(app_table)
  if     #app_table == 2 then layoutApp(app_table, layouts["halves"])
  elseif #app_table == 3 then layoutApp(app_table, layouts["thirds"])
  elseif #app_table == 4 then layoutApp(app_table, layouts["quads"])
  elseif #app_table >= 5 then layoutApp(app_table, layouts["sixths"])
  end
end

local function switchAudio()
  local filter = { "S23C570", "ZoomAudioDevice" }
  local choiceList = hs.fnutils.filter(
    hs.audiodevice.allOutputDevices(),function(el) return not hs.fnutils.contains(filter, el:name()) end)

  local chooser = hs.chooser.new(
    function(choice)
      if choice then
        local dev = hs.audiodevice.findDeviceByName(choice["text"])
        if dev:setDefaultOutputDevice() then hs.alert.show("🔈" .. device:name()) end
      end
    end)
  chooser:rows(3)
  chooser:choices(
    hs.fnutils.map(choiceList, function(el) return { ["text"] = el:name() } end)):show()
end

local function switchMonitorInput()
  local cInput = "27"
  local nInput

  hs.task.new(
    "/Users/jhsiao/devel/dotfiles/bin/current_input",
    function(exitCode, output, err) cInput = string.gsub(output, "%s", "") end
  ):start():waitUntilExit()

  if cInput == "27" then
    nInput = "17" -- switch to HDMI 1
    spoon.Caffeine:setState(true)
  else
    nInput = "27" -- switch to USB-C
    spoon.Caffeine:setState(false)
  end
  hs.execute("/usr/local/bin/m1ddc display " .. dellID .. " set input " .. nInput)
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

-- resize bindings
bind({"ctrl", "alt"}, "left", function () adjust("w", -20) end)
bind({"ctrl", "alt"}, "right", function () adjust("w", 20) end)
bind({"ctrl", "alt"}, "up", function () adjust("h", -20) end)
bind({"ctrl", "alt"}, "down", function () adjust("h", 20) end)
bind({"cmd", "alt"}, "f", function() hs.window.focusedWindow():maximize() end)

-- nudge bindings
bind({"ctrl", "alt", "shift"}, "left", function () adjust("x", -50) end)
bind({"ctrl", "alt", "shift"}, "right", function () adjust("x", 50) end)
bind({"ctrl", "alt", "shift"}, "up", function () adjust("y", -50) end)
bind({"ctrl", "alt", "shift"}, "down", function () adjust("y", 50) end)

-- throw bindings
bind(hyper, "left", function() hs.window.focusedWindow():moveOneScreenWest() end)
bind(hyper, "right", function() hs.window.focusedWindow():moveOneScreenEast() end)
bind({"ctrl", "cmd", "shift"}, "left", function() moveOneSpaceEW("west") end)
bind({"ctrl", "cmd", "shift"}, "right", function() moveOneSpaceEW("east") end)

-- chain bindings
bind({"cmd", "alt"}, "left", function() chain(layouts["chain"]["left"]) end)
bind({"cmd", "alt"}, "right", function() chain(layouts["chain"]["right"]) end)
bind({"cmd", "alt"}, "up", function () chain(layouts["chain"]["up"]) end)
bind({"cmd", "alt"}, "down", function() chain(layouts["chain"]["down"]) end)
bind({"cmd", "alt"}, "t", function() chain(layouts["chain"]["term"]) end)
bind({"ctrl", "shift"}, "right", function() chain(layouts["chain"]["full_grid"]) end)

-- layout bindings
bind({"cmd", "alt"}, "q", function()
  layoutApp(getWF("zoom.us"):getWindows(), {{geos["l3"], primaryScreen()}})
  wins = getWF():rejectApp("zoom.us"):rejectApp("Slack"):getWindows()
  if     #wins == 1 then layoutApp(wins, {{geos["rlarge"], primaryScreen()}})
  elseif #wins  > 1 then layoutApp(wins, layouts["r3s"])
  end
end)
bind({"cmd", "alt"}, "v", function() hs.layout.apply(layouts["v2"]) end)
bind({"cmd", "alt"}, "m", function()
  hs.layout.apply(layouts["filemgmt"])
  layoutApp(getWF("Finder"):getWindows(),
            {{geos["lt3"], primaryScreen()}, {geos["lb3"], primaryScreen()}})
  layoutApp(getWF():rejectApp("Finder"):rejectApp("Slack")
            :rejectApp("Terminal"):getWindows(), layouts["r3s"])
end)
bind({"cmd", "alt"}, "1", function() hs.layout.apply(layouts["laptop"]) end)
bind({"cmd", "alt"}, "2", function() hs.layout.apply(layouts["pcm2"]) end)
bind({"cmd", "alt"}, "3",
     function() hs.layout.apply(layouts["home3"])
       layoutApp(getWF("Terminal"):getWindows(),
                 {{geos["term"], primaryScreen()}, {geos["termr"], primaryScreen()}})
       layoutApp(getWF(browsers):getWindows(), layouts["halves"])
       layoutApp(getWF(browsers, {allowTitles={"Voice", "MCCal"}}):getWindows(),
                 {{ geos["t3"], vScreen }})
     end)

bind({"cmd", "alt"}, "h",
     function() layoutApp(getWF(browsers):getWindows(), layouts["halves"]) end)
bind({"cmd", "alt"}, "4",
     function() layoutApp(getWF(browsers):getWindows(), layouts["quads"]) end)
bind({"cmd", "alt"}, "9", function() gridify(getWF():getWindows()) end)
bind(hyper, "9", function() gridify(hs.window.focusedWindow():application():allWindows()) end)

-- utility bindings
bind(hyper, "d", function() hs.eventtap.keyStrokes(os.date('%Y-%m-%d')) end)
bind(hyper, "a", function() switchAudio("External Headphones") end)

bind(hyper, "i", function() if dellID then switchMonitorInput() end end)
bind(hyper, "p", function() hs.application.launchOrFocus("PingID") end)
bind(hyper, "n", function() hs.network.ping.ping("8.8.8.8", 1, 0.01, 1.0, "any", pingResult) end)

bind({"cmd", "alt"}, "0", function() hs.reload() end)

hs.ipc.cliStatus() -- load IPC for commandline util
hs.alert.show("Config loaded")
