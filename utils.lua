local utils = {}
local fnutils = hs.fnutils

function utils:switchAudio()
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

return utils
