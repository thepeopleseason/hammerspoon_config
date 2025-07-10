-- Currently using private configuration included into config via
-- `private = require("private")` in init.lua
--
-- This config table could, of course, be inlined within this file
--
-- sample urlconf format:
-- urlconf = {
--   {
--     profile = "Profile 2",
--     matches = { "meet.google.com", "adp.com", "file:///.*mystuff.html" },
--   },
--   {
--     profile = "Profile 3",
--     matches = { "myworkday.com", "outlook.office365.com", "microsoft.com" },
--   }
-- }

urlconf = private.urlconf
modconf = {
  { key = { "cmd" },
    profile = "Profile 1" },
  { key = { "shift" },
    profile = "Profile 10" }
}

-- open Chrome with a specific named Profile
function openChromeWithProfile(profile, url)
  local t = hs.task.new(
    "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
    nil,
    function() return false end,
    { "--profile-directory=" .. profile, url })
  t:start()
end

-- Spotify
function openSpotify(url)
  local t = hs.task.new(
    "/Applications/Spotify.app/Contents/MacOS/Spotify",
    nil,
    function() return false end,
    { "--uri=" .. url })
  t:start()
end

-- clean URL cruft
function cleanURL(url)
  filter = { "utm_", "uta_", "fbclid", "gclid" }
  local path, qstring = table.unpack(hs.fnutils.split(url, "?"), 1, 2)
  newqstring = hs.fnutils.map(
    hs.fnutils.split(qstring, "&"), function(el)
      if not hs.fnutils.some(filter,
                         function(fel) if string.match(el, fel) then return true end end) then
        return el
      end
    end
  )
  if #newqstring == 0 then
    return path
  else
    return path .. "?" .. table.concat(newqstring, "&")
  end
end

function handleHTTP(scheme, host, params, url, sender)
  -- remove tracking and other unwanted URL cruft
  if string.match(url, "?") then url = cleanURL(url) end

  -- handle modkeys
  for i=1,#modconf do
    if hs.fnutils.every(modconf[i].key,
                        function(key) return hs.eventtap.checkKeyboardModifiers()[key] end)
    then
      openChromeWithProfile(modconf[i]["profile"], url)
      return true
    end
  end

  -- Spotify
  if string.match(url, "open.spotify.com") then
    openSpotify(url)
    return true
  end

  -- Zoom
  if string.match(url, "zoom.us/j") then
    hs.urlevent.openURLWithBundle(url, "us.zoom.xos")
    return true
  end

  for i=1,#urlconf do
    if hs.fnutils.some(urlconf[i]["matches"],
                       function(re) if string.match(url, re) then return true end end)
    then
      openChromeWithProfile(urlconf[i]["profile"], url)
      return true
    end
  end

  -- Default
  --hs.urlevent.openURLWithBundle(url, "org.mozilla.firefox")
  openChromeWithProfile("Profile 1", url)
  return true
end

hs.urlevent.httpCallback = handleHTTP
