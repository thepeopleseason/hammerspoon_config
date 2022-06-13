local mc = {}

mc.dellID = nil

function mc:init()
  hs.task.new(
    os.getenv("HOME") .. "/.hammerspoon/bin/dell_id",
    function(exitCode, output, err) mc.dellID = string.gsub(output, "%s", "") end
  ):start():waitUntilExit()
end

function mc:switchMonitorInput()
  local cInput = "27"
  local nInput

  hs.task.new(
    os.getenv("HOME") .. "/.hammerspoon/bin/current_input",
    function(exitCode, output, err) cInput = string.gsub(output, "%s", "") end
  ):start():waitUntilExit()

  if cInput == "27" then
    nInput = "17" -- switch to HDMI 1
    spoon.Caffeine:setState(true)
  else
    nInput = "27" -- switch to USB-C
    spoon.Caffeine:setState(false)
  end
  hs.execute("/usr/local/bin/m1ddc display " .. mc.dellID .. " set input " .. nInput)
end

return mc
