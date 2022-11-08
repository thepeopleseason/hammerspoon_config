-- Currently using private configuration included into config via
-- `private = require("private")` in init.lua
--
-- This config table could, of course, be inlined within this file
--
-- sample urlconf format:
-- urlconf = {
--   mc = {
--     pf = "Profile 2",
--     matches = { "meet.google.com", "adp.com" },
--   },
--   int = {
--     pf = "Profile 3",
--     matches = { "myworkday.com", "outlook.office365.com", "microsoft.com" },
--   }
-- }


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

  -- Spotify
  if string.match(host, "open.spotify.com") then
    openSpotify(url)
    return true
  end

  -- Zoom
  if string.match(url, "zoom.us/j") then
    hs.urlevent.openURLWithBundle(url, "us.zoom.xos")
    return true
  end

  -- handle modkeys
  if hs.eventtap.checkKeyboardModifiers()["cmd"]
  then
    openChromeWithProfile(private.urlconf["mc"]["pf"], url)
    return true
  end

  if hs.eventtap.checkKeyboardModifiers()["shift"]
  then
    openChromeWithProfile(private.urlconf["int"]["pf"], url)
    return true
  end

  if string.match(scheme, "http") then
    if hs.fnutils.some(private.urlconf["mc"]["matches"], function(el)
                         if string.match(url, el) then return true end end)
    then
      openChromeWithProfile(private.urlconf["mc"]["pf"], url)
      return true
    end

    if hs.fnutils.some(private.urlconf["int"]["matches"], function(el)
                         if string.match(url, el) then return true end end)
    then
      openChromeWithProfile(private.urlconf["int"]["pf"], url)
      return true
    end
  end

  -- Default
  hs.urlevent.openURLWithBundle(url, "org.mozilla.firefox")
  return true
end

hs.urlevent.httpCallback = handleHTTP
