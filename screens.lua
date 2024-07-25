hs.loadSpoon("Caffeine")
spoon.Caffeine:start()

local obj = {}

obj.mbpScreen = "Built-in Retina Display"
obj.home1Screen = "DELL U3419W"
obj.home2Screen = "DELL S2422HG"
obj.mia1Screen = "DELL U3417W"
obj.mia2Screen = "S23C570"
obj.atl1Screen = "C34J79x"
obj.atl2Screen = "VG27A"

obj.screens = {}
obj.screenList = ''
obj.mainDdcID = nil

obj.defaultInput = "27" -- USB-C

function obj.init()
  -- get Dell UW ID
  if hs.screen(obj.home1Screen) or hs.screen(obj.mia1Screen) then
    hs.task.new(
      os.getenv("HOME") .. "/.hammerspoon/bin/dell_id",
      function(exitCode, output, err) obj.mainDdcID = string.gsub(output, "%s", "") end
    ):start():waitUntilExit()
  end

  scr = hs.screen.allScreens()
  if #scr == 3 then
    if hs.screen(obj.mia1Screen) then
      print (hs.inspect(obj.screens))
      obj.screens = { hs.screen(obj.mia1Screen),
                      hs.screen(obj.mia2Screen),
                      scr[1] }
      print (hs.inspect(obj.screens))
    elseif hs.screen(obj.atl2Screen) then
      if scr[2]:currentMode()["h"] == "2560" then
        obj.screens = { scr[3], scr[2], scr[1] }
      else
        obj.screens = { scr[2], scr[3], scr[1] }
      end
    end
  else
    if hs.screen(obj.home1Screen) then
      obj.screens = { hs.screen(obj.home1Screen), hs.screen(obj.home2Screen) }
    elseif hs.screen(obj.mia1Screen) then
      obj.screens = { hs.screen(obj.mia1Screen), hs.screen(obj.mia2Screen) }
      obj.defaultInput = "15" -- DP
    elseif hs.screen(obj.atl1Screen) then
      obj.screens = { hs.screen(obj.atl1Screen), hs.screen(obj.mbpScreen) }
    elseif hs.screen(obj.atl2Screen) then
      if scr[1]:currentMode()["h"] == "2560" then
        obj.screens = { scr[2], scr[1] }
      else
        obj.screens = { scr[1], scr[2] }
      end
    end
  end

  if #obj.screens == 0 then
    obj.screens = { scr[1], scr[1] }
  end

  obj.screenList = table.concat(
    hs.fnutils.imap(obj.screens, function(e) print(e:name()) return e:name() end), ":")

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
