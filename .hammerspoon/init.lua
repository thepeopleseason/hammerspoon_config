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

  lthird = hs.geometry.unitrect(0.0, 0.0, 0.33, 1.0),
  mthird = hs.geometry.unitrect(0.33, 0.0, 0.33, 1.0),
  rthird = hs.geometry.unitrect(0.66, 0.0, 0.33, 1.0),

  ltthird = hs.geometry.unitrect(0.0, 0.0, 0.33, 0.5),
  mtthird = hs.geometry.unitrect(0.33, 0.0, 0.33, 0.5),
  rtthird = hs.geometry.unitrect(0.66, 0.0, 0.33, 0.5),

  lbthird = hs.geometry.unitrect(0.0, 0.5, 0.33, 0.5),
  mbthird = hs.geometry.unitrect(0.33, 0.5, 0.33, 0.5),
  rbthird = hs.geometry.unitrect(0.66, 0.5, 0.33, 0.5),

  tthird = hs.geometry.unitrect(0.0, 0.0, 1.0, 0.33),
  cthird = hs.geometry.unitrect(0.0, 0.33, 1.0, 0.33),
  bthird = hs.geometry.unitrect(0.0, 0.66, 1.0, 0.33),

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
  zoombrowse = {
    {"zoom.us", nil, primaryScreen(), geos["lthird"], nil, nil},
  },
  home3 = {
    {"Slack", nil, vScreen, geos["blarge"], nil, nil},
    {"zoom.us", nil, primaryScreen(), geos["lthird"], nil, nil},
  },
  v2 = {
    {"Slack", nil, laptopScreen, geos["fs"], nil, nil},
    {"Terminal", nil, primaryScreen(), geos["tthird"], nil, nil},
  },
  pcm2 = {
    {"Slack", nil, laptopScreen, geos["fs"], nil, nil},
    {"Terminal", nil, primaryScreen(), geos["rthird"], nil, nil},
  },
  code2 = {
    {"Slack", nil, laptopScreen, geos["bhalf"], nil, nil},
    {"Terminal", nil, primaryScreen(), geos["lthird"], nil, nil},
  },
  filemgmt = {
    {"Terminal", nil, primaryScreen(), geos["rhalf"], nil, nil},
  },

  -- layoutApp() layouts
  home3_chrome = {
    {geos["lhalf"], primaryScreen()}, {geos["rhalf"], primaryScreen()},
  },
  home3_term = {
    {geos["term"], primaryScreen()}, {geos["termr"], primaryScreen()},
  },
  filemgmt_finder = {
    {geos["ltq"], primaryScreen()}, {geos["lbq"], primaryScreen()},
  },
  chrome2 = {
    {geos["lhalf"], primaryScreen()}, {geos["rhalf"], primaryScreen()},
  },
  chrome3 = {
    {geos["lthird"], primaryScreen()}, {geos["mthird"], primaryScreen()},
    {geos["rthird"], primaryScreen()},
  },
  chrome4 = {
    {geos["ltq"], primaryScreen()}, {geos["rtq"], primaryScreen()},
    {geos["lbq"], primaryScreen()}, {geos["rbq"], primaryScreen()},
  },
  chrome6 = {
    {geos["ltthird"], primaryScreen()}, {geos["mtthird"], primaryScreen()},
    {geos["rtthird"], primaryScreen()}, {geos["lbthird"], primaryScreen()},
    {geos["mbthird"], primaryScreen()}, {geos["rbthird"], primaryScreen()},
  },
  zoom_chrome = {
    {geos["mthird"], primaryScreen()}, {geos["rthird"], primaryScreen()},
  },

  -- chain sequences (see chain() function below)
  chain = {
    term = { geos["term"], geos["termr"] },
    left = { geos["lhalf"], geos["llarge"], geos["lthird"] },
    right = { geos["rhalf"], geos["rlarge"], geos["rthird"] },
    up = { geos["thalf"], geos["tlarge"], geos["tthird"] },
    down = { geos["bhalf"], geos["blarge"], geos["bthird"] },

    full_grid = {
      geos["ltq"], geos["rtq"], geos["lbq"], geos["rbq"],
      geos["lthird"], geos["mthird"], geos["rthird"],
      geos["tthird"], geos["cthird"], geos["bthird"],
      geos["ltthird"], geos["mtthird"], geos["rtthird"],
      geos["lbthird"], geos["mbthird"], geos["rbthird"]
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

function getWF(app)
  local wf=hs.window.filter
  local filter = {
    currentSpace=true,
    rejectTitles={"Voice", "MCCal"},
    visible=true
  }

  if app then   return wf.new(app):setOverrideFilter(filter)
  else          return wf.new(false):setDefaultFilter(filter)
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

table.indexOf = function (t, obj)
  if type(t) ~= "table" then error("table expected, got " .. type(t), 2) end

  for i, v in pairs(t) do
    if obj == v then return i end
  end
end

local function nextPosition(t, urect)
  local nIdx = 1
  local cIdx = table.indexOf(t, hs.geometry.unitrect(urect))
  if cIdx then
    nIdx = cIdx + 1
    if nIdx > #t then nIdx = 1 end
  end
  return t[nIdx]
end

local function moveOneSpaceEW(dir)
  local win = hs.window.focusedWindow()
  local uuid = win:screen():getUUID()
  local spaceID = hs.spaces.activeSpaces()[uuid]
  local screenTable = hs.spaces.allSpaces()[uuid]
  local cIndex = table.indexOf(screenTable, spaceID)
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

local function chain(t, win)
  local win = win or hs.window.focusedWindow()
  win:move(nextPosition(t, currentWindowRect(win)))
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
  if     #app_table == 2 then layoutApp(app_table, layouts["chrome2"])
  elseif #app_table == 3 then layoutApp(app_table, layouts["chrome3"])
  elseif #app_table == 4 then layoutApp(app_table, layouts["chrome4"])
  elseif #app_table >= 5 then layoutApp(app_table, layouts["chrome6"])
  end
end

local function switchAudio(aud)
  local device = hs.audiodevice.findDeviceByName(aud)
  if device:setDefaultOutputDevice() then hs.alert.show("🔈" .. device:name()) end
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
  wins = getWF():rejectApp("zoom.us"):getWindows()
  if     #wins == 1 then layoutApp(wins, {{geos["rlarge"], primaryScreen()}})
  elseif #wins  > 1 then layoutApp(wins, layouts["zoom_chrome"])
  end
  hs.layout.apply(layouts["zoombrowse"])
end)
bind({"cmd", "alt"}, "v", function() hs.layout.apply(layouts["v2"]) end)
bind({"cmd", "alt"}, "m", function()
  hs.layout.apply(layouts["filemgmt"])
  layoutApp(getWF("Finder"):getWindows(), layouts["filemgmt_finder"])
end)
bind({"cmd", "alt"}, "1", function() hs.layout.apply(layouts["laptop"]) end)
bind({"cmd", "alt"}, "2", function() hs.layout.apply(layouts["pcm2"]) end)

bind({"cmd", "alt"}, "3",
     function() hs.layout.apply(layouts["home3"])
       layoutApp(getWF("Terminal"):getWindows(), layouts["home3_term"])
       layoutApp(getWF(browsers):getWindows(), layouts["home3_chrome"])
       layoutApp(
         hs.window.filter.new(browsers):setOverrideFilter(
           {allowTitles={"Voice", "MCCal"}}):getWindows(),
         {{ geos["tthird"], vScreen }})
     end)

bind({"cmd", "alt"}, "h",
     function() layoutApp(getWF(browsers):getWindows(), layouts["chrome2"]) end)
bind({"cmd", "alt"}, "4",
     function() layoutApp(getWF(browsers):getWindows(), layouts["chrome4"]) end)
bind({"cmd", "alt"}, "9", function() gridify(getWF():getWindows()) end)
bind(hyper, "9", function() gridify(hs.window.focusedWindow():application():allWindows()) end)

-- utility bindings
bind(hyper, "d", function() hs.eventtap.keyStrokes(os.date('%Y-%m-%d')) end)
bind(hyper, "h", function() switchAudio("External Headphones") end)
bind(hyper, "s", function() switchAudio("MacBook Pro Speakers") end)
bind(hyper, "m", function() switchAudio(dellScreen) end)

bind(hyper, "i", function() if dellID then switchMonitorInput() end end)
bind(hyper, "p", function() hs.application.launchOrFocus("PingID") end)
bind(hyper, "n", function() hs.network.ping.ping("8.8.8.8", 1, 0.01, 1.0, "any", pingResult) end)

bind({"cmd", "alt"}, "0", function() hs.reload() end)

hs.ipc.cliStatus() -- load IPC for commandline util
hs.alert.show("Config loaded")

