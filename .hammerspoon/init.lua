hs.window.animationDuration = 0

local laptopScreen = "Built-in Retina Display"
local vScreen = "S23C570"
local dellScreen = "DELL U3419W"

geos = {
  fs = hs.geometry.unitrect(0.0, 0.0, 1.0, 1.0),
  llarge = hs.geometry.unitrect(0.0, 0.0, 0.66, 1.0),
  lhalf = hs.geometry.unitrect(0.0, 0.0, 0.5, 1.0),
  rlarge = hs.geometry.unitrect(0.34, 0.0, 0.66, 1.0),
  rhalf = hs.geometry.unitrect(0.5, 0.0, 0.5, 1.0),

  tlarge = hs.geometry.unitrect(0.0, 0.0, 1.0, 0.66),
  thalf = hs.geometry.unitrect(0.0, 0.0, 1.0, 0.5),
  blarge = hs.geometry.unitrect(0.0, 0.34, 1.0, 0.66),
  bhalf = hs.geometry.unitrect(0.0, 0.5, 1.0, 0.5),

  ltq = hs.geometry.unitrect(0.0, 0.0, 0.5, 0.5),
  lbq = hs.geometry.unitrect(0.0, 0.5, 0.5, 0.5),
  rtq = hs.geometry.unitrect(0.5, 0.0, 0.5, 0.5),
  rbq = hs.geometry.unitrect(0.5, 0.5, 0.5, 0.5),

  lthird = hs.geometry.unitrect(0.0, 0.0, 0.34, 1.0),
  mthird = hs.geometry.unitrect(0.34, 0.0, 0.34, 1.0),
  rthird = hs.geometry.unitrect(0.66, 0.0, 0.34, 1.0),

  ltthird = hs.geometry.unitrect(0.0, 0.0, 0.34, 0.5),
  mtthird = hs.geometry.unitrect(0.34, 0.0, 0.34, 0.5),
  rtthird = hs.geometry.unitrect(0.66, 0.0, 0.34, 0.5),

  lbthird = hs.geometry.unitrect(0.0, 0.5, 0.34, 0.5),
  mbthird = hs.geometry.unitrect(0.34, 0.5, 0.34, 0.5),
  rbthird = hs.geometry.unitrect(0.66, 0.5, 0.34, 0.5),

  tthird = hs.geometry.unitrect(0.0, 0.0, 1.0, 0.34),
  cthird = hs.geometry.unitrect(0.0, 0.34, 1.0, 0.34),
  bthird = hs.geometry.unitrect(0.0, 0.66, 1.0, 0.34),

  term = hs.geometry.unitrect(0.0, 0.0, 0.29, 0.99),
  termr = hs.geometry.unitrect(0.7, 0.0, 0.29, 0.99),
}

layouts = {
  laptop = {
    {"Slack", nil, laptopScreen, geos["fs"], nil, nil},
    {"Google Chrome", nil, laptopScreen, geos["fs"], nil, nil},
    {"Terminal", nil, laptopScreen, geos["term"], nil, nil},
  },
  zoombrowse = {
    {"zoom.us", nil, dellScreen, geos["lthird"], nil, nil},
    {"Google Chrome", nil, dellScreen, geos["rlarge"], nil, nil},
  },
  home3 = {
    {"Slack", nil, vScreen, geos["blarge"], nil, nil},
    {"Spotify", nil, laptopScreen, geos["fs"], nil, nil},
    {"Safari", nil, laptopScreen, geos["fs"], nil, nil},
    {"zoom.us", nil, dellScreen, geos["lthird"], nil, nil},
  },
  home3_chrome = {
    {geos["lhalf"], dellScreen},
    {geos["rhalf"], dellScreen},
  },
  home3_term = {
    {geos["tthird"], vScreen},
    {geos["term"], dellScreen},
  },
  v2 = {
    {"Slack", nil, laptopScreen, geos["bhalf"], nil, nil},
    {"Safari", nil, laptopScreen, geos["thalf"], nil, nil},
    {"Google Chrome", nil, vScreen, geos["blarge"], nil, nil},
    {"Terminal", nil, vScreen, geos["tthird"], nil, nil},
  },
  pcm2 = {
    {"Slack", nil, laptopScreen, geos["bhalf"], nil, nil},
    {"Safari", nil, laptopScreen, geos["thalf"], nil, nil},
    {"Google Chrome", nil, dellScreen, geos["llarge"], nil, nil},
    {"Terminal", nil, dellScreen, geos["rthird"], nil, nil},
  },
  code2 = {
    {"Slack", nil, laptopScreen, geos["bhalf"], nil, nil},
    {"Safari", nil, laptopScreen, geos["thalf"], nil, nil},
    {"Google Chrome", nil, dellScreen, geos["rlarge"], nil, nil},
    {"Terminal", nil, dellScreen, geos["lthird"], nil, nil},
  },
  filemgmt = {
    {"Google Chrome", nil, dellScreen, geos["rhalf"], nil, nil},
    {"Terminal", nil, dellScreen, geos["rhalf"], nil, nil},
  },
  filemgmt_finder = {
    {geos["ltq"], dellScreen},
    {geos["lbq"], dellScreen},
  },
  chrome2 = {
    {geos["lhalf"], dellScreen},
    {geos["rhalf"], dellScreen},
  },
  chrome4 = {
    {geos["ltq"], dellScreen},
    {geos["rtq"], dellScreen},
    {geos["lbq"], dellScreen},
    {geos["rbq"], dellScreen},
  },
  chrome6 = {
    {geos["ltthird"], dellScreen},
    {geos["mtthird"], dellScreen},
    {geos["rtthird"], dellScreen},
    {geos["lbthird"], dellScreen},
    {geos["mbthird"], dellScreen},
    {geos["rbthird"], dellScreen},
  },
}

left = { geos["lhalf"], geos["llarge"], geos["lthird"] }
right = { geos["rhalf"], geos["rlarge"], geos["rthird"] }
up = { geos["thalf"], geos["tlarge"], geos["tthird"] }
down = { geos["bhalf"], geos["blarge"], geos["bthird"] }

full_grid = { geos["ltq"], geos["rtq"], geos["lbq"], geos["rbq"],
              geos["lthird"], geos["mthird"], geos["rthird"],
              geos["tthird"], geos["cthird"], geos["bthird"],
              geos["ltthird"], geos["mtthird"], geos["rtthird"],
              geos["lbthird"], geos["mbthird"], geos["rbthird"] }

term = { geos["term"], geos["termr"] }

function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

local function round(x, places)
  local places = places or 0
  local x = x * 10^places
  return (x + 0.5 - (x + 0.5) % 1) / 10^places
end

local function current_window_rect(win)
  local win = win or hs.window.focusedWindow()
  local ur, r = win:screen():toUnitRect(win:frame()), round
  return {r(ur.x,2), r(ur.y,2), r(ur.w,2), r(ur.h,2)} -- an hs.geometry.unitrect table
end

table.indexOf = function (t, obj)
  if type(t) ~= "table" then error("table expected, got " .. type(t), 2) end

  for i, v in pairs(t) do
    if obj == v then
      return i
    end
  end
end

local function getTerminals()
  local terms = hs.application.get("Terminal"):allWindows()
  table.sort(terms, function(a, b)
    return a:screen():name():upper() > b:screen():name():upper()
  end)
  return terms
end

local function layout_app(wins, layout)
  for i, win in ipairs(wins) do
    local layout_index = i
    if layout_index > #layout then layout_index = #layout end
    win:moveToScreen(layout[layout_index][2])
    win:move(layout[layout_index][1])
  end
end

local function next_position(t, urect)
  local next_index = 1
  local cur_index = table.indexOf(t, hs.geometry.unitrect(urect))
  if cur_index then
    next_index = cur_index + 1
    if next_index > #t then
      next_index = 1
    end
  end
  return t[next_index]
end

local function chain(t, win)
  local win = win or hs.window.focusedWindow()
  win:move(next_position(t, current_window_rect(win)))
end

local function adjust(dim, amt)
  local win = hs.window.focusedWindow()
  local f = win:frame()
  f[dim] = f[dim] + amt
  win:setFrame(f)
end


-- resize bindings
hs.hotkey.bind({"ctrl", "alt"}, "left", function () adjust("w", -20) end)
hs.hotkey.bind({"ctrl", "alt"}, "right", function () adjust("w", 20) end)
hs.hotkey.bind({"ctrl", "alt"}, "up", function () adjust("h", -20) end)
hs.hotkey.bind({"ctrl", "alt"}, "down", function () adjust("h", 20) end)

-- nudge bindings
hs.hotkey.bind({"ctrl", "alt", "shift"}, "left", function () adjust("x", -50) end)
hs.hotkey.bind({"ctrl", "alt", "shift"}, "right", function () adjust("x", 50) end)
hs.hotkey.bind({"ctrl", "alt", "shift"}, "up", function () adjust("y", -50) end)
hs.hotkey.bind({"ctrl", "alt", "shift"}, "down", function () adjust("y", 50) end)

-- throw bindings
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "left", function()
  hs.window.focusedWindow():moveOneScreenWest(true, true)
end)
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "right", function()
  hs.window.focusedWindow():moveOneScreenEast(true, true)
end)

-- chain bindings
hs.hotkey.bind({"cmd", "alt"}, "Left", function() chain(left) end)
hs.hotkey.bind({"cmd", "alt"}, "Right", function() chain(right) end)
hs.hotkey.bind({"cmd", "alt"}, "Up", function () chain(up) end)
hs.hotkey.bind({"cmd", "alt"}, "Down", function() chain(down) end)
hs.hotkey.bind({"ctrl", "shift"}, "Right", function() chain(full_grid) end)
hs.hotkey.bind({"cmd", "alt"}, "t", function() chain(term) end)

-- layout bindings
hs.hotkey.bind({"cmd", "alt"}, "f", function() hs.window.focusedWindow():maximize() end)
hs.hotkey.bind({"cmd", "alt"}, "q", function() hs.layout.apply(layouts["zoombrowse"]) end)
hs.hotkey.bind({"cmd", "alt"}, "v", function() hs.layout.apply(layouts["v2"]) end)
hs.hotkey.bind({"cmd", "alt"}, "m", function()
  hs.layout.apply(layouts["filemgmt"])
  layout_app(hs.application.get("Finder"):allWindows(), layouts["filemgmt_finder"])
end)
hs.hotkey.bind({"cmd", "alt"}, "1", function() hs.layout.apply(layouts["laptop"]) end)
hs.hotkey.bind({"cmd", "alt"}, "2", function() hs.layout.apply(layouts["pcm2"]) end)
hs.hotkey.bind({"cmd", "alt"}, "3", function()
  layout_app(hs.application.get("Google Chrome"):allWindows(), layouts["home3_chrome"])
  layout_app(getTerminals(), layouts["home3_term"])
  hs.layout.apply(layouts["home3"])
end)
hs.hotkey.bind({"cmd", "alt"}, "h", function()
  layout_app(hs.application.get("Google Chrome"):allWindows(), layouts["chrome2"])
end)
hs.hotkey.bind({"cmd", "alt"}, "4", function()
  layout_app(hs.application.get("Google Chrome"):allWindows(), layouts["chrome4"])
end)
hs.hotkey.bind({"cmd", "alt"}, "6", function()
  layout_app(hs.application.get("Google Chrome"):allWindows(), layouts["chrome6"])
end)

-- utility bindings
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "d", function()
  hs.eventtap.keyStrokes(os.date('%Y-%m-%d'))
end)
hs.hotkey.bind({"cmd", "alt"}, "0", function() hs.reload() end)
hs.alert.show("Config loaded")

