local obj = {}

obj.mbpScreen = "Built-in Retina Display"
obj.samsungScreen = "S23C570"
obj.dellScreen = "DELL U3419W"
obj.miamiScreen = "HP S2031"

obj.current = {}
obj.mc = nil

function obj.init()
  if hs.screen(obj.dellScreen) then
    obj.mc = require("monitor_control")
    obj.mc.init()
    obj.current = { hs.screen(obj.dellScreen), hs.screen(obj.samsungScreen) }
  elseif hs.screen(obj.miamiScreen) then
    obj.current = { hs.screen(obj.miamiScreen), hs.screen(obj.mbpScreen) }
  else
    obj.current = { hs.screen(obj.mbpScreen), hs.screen(obj.mbpScreen) }
  end
  return obj.current, obj.mc
end

return obj
