local obj = {}
local fnutils = hs.fnutils

function obj.switchAudio(filter)
  local ignoreFilter = filter or {"ZoomAudioDevice"}

  -- filter out MBP speakers if in clamshell mode
  if not hs.screen.findByName("Built-in Retina Display") then
    table.insert(ignoreFilter, "MacBook Pro Speakers")
  end

  local choiceList = fnutils.filter(
    hs.audiodevice.allOutputDevices(),
    function(el) return not fnutils.contains(ignoreFilter, el:name()) end)

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
  chooser:placeholderText("Choose audio output:")
  chooser:bgDark(true):rows(1):width(30):show()
end

function obj.pingResult(object, message, seqnum, error)
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

return obj
