hs.loadSpoon("Caffeine")
spoon.Caffeine:start()

local obj = {}

obj.mbpScreen = "Built-in Retina Display"
obj.samsungScreen = "S23C570"
obj.homeScreen = "DELL U3419W"
obj.mia1Screen = "DELL U3417W"
obj.mia2Screen = "DELL S2422HG"
obj.atl1Screen = "C34J79x"
obj.atl2Screen = "VG27A"

obj.screens = {}
obj.mc = nil
obj.mainDdcID = nil

obj.defaultInput = "27" -- USB-C

function obj.init()
  if hs.screen(obj.homeScreen) then
    hs.task.new(
      os.getenv("HOME") .. "/.hammerspoon/bin/dell_id",
      function(exitCode, output, err) obj.mainDdcID = string.gsub(output, "%s", "") end
    ):start():waitUntilExit()
    obj.screens = { hs.screen(obj.homeScreen), hs.screen(obj.samsungScreen) }
  elseif hs.screen(obj.mia1Screen) then
    hs.task.new(
      os.getenv("HOME") .. "/.hammerspoon/bin/dell_id",
      function(exitCode, output, err) obj.mainDdcID = string.gsub(output, "%s", "") end
    ):start():waitUntilExit()
    obj.screens = { hs.screen(obj.mia1Screen), hs.screen(obj.mia2Screen) }
    obj.defaultInput = "15" -- DP
  elseif hs.screen(obj.mcScreen) then
    obj.screens = { hs.screen(obj.mcScreen), hs.screen(obj.mbpScreen) }
  elseif hs.screen(obj.atl1Screen) then
    obj.screens = { hs.screen(obj.atl1Screen), hs.screen(obj.mbpScreen) }
  elseif hs.screen(obj.atl2Screen) then
    scr = hs.screen.allScreens()
    if scr[1]:currentMode()["h"] == "2560" then
      obj.screens = { scr[2], scr[1] }
    else
      obj.screens = { scr[1], scr[2] }
    end
  else
    obj.screens = { hs.screen(obj.mbpScreen), hs.screen(obj.mbpScreen) }
  end
  return obj
end

function obj.switchMonitorInput(caffeinate)
  local cInput = obj.defaultInput
  local nInput

  hs.task.new(
    os.getenv("HOME") .. "/.hammerspoon/bin/current_input",
    function(exitCode, output, err) cInput = string.gsub(output, "%s", "") end
  ):start():waitUntilExit()

  if cInput == obj.defaultInput then
    nInput = "17" -- switch to HDMI 1
  else
    nInput = "27" -- switch to USB-C
  end
  hs.execute("/usr/local/bin/m1ddc display " .. obj.mainDdcID .. " set input " .. nInput)
end

return obj
