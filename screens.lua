local screens = {}

screens.mbpScreen = "Built-in Retina Display"
screens.samsungScreen = "S23C570"
screens.dellScreen = "DELL U3419W"
screens.miamiScreen = "HP S2031"

screens.current = {}
screens.mc = nil

function screens:init()
  if hs.screen(screens.dellScreen) then
    screens.mc = require("monitor_control")
    screens.mc.init()
    screens.current = { hs.screen(screens.dellScreen), hs.screen(screens.samsungScreen) }
  elseif hs.screen(screens.miamiScreen) then
    screens.current = { hs.screen(screens.miamiScreen), hs.screen(screens.mbpScreen) }
  else
    screens.current = { hs.screen(screens.mbpScreen), hs.screen(screens.mbpScreen) }
  end
  return screens.current, screens.mc
end

return screens
