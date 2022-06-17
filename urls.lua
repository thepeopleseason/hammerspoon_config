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
  local mailchimp = {
    pf = "Profile 2",
    matches = { "rsglab", "mailchimp", "mcpeeps", "meet.google.com" },
  }
  local intuit = {
    pf = "Profile 3",
    matches = { "intuit", "alight.com", "perksatwork.com", "degreed.com",
                "www.concursolutions.com", "align.ustream.tv", "outlook.office365.com" },
  }

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

  -- Mailchimp
  if hs.eventtap.checkKeyboardModifiers()["cmd"] or
    hs.fnutils.some(mailchimp["matches"], function(el)
                      if string.match(url, el) then return true end end)
  then
    openChromeWithProfile(mailchimp["pf"], url)
    return true
  end

  -- Intuit
  if hs.eventtap.checkKeyboardModifiers()["shift"] or
    hs.fnutils.some(intuit["matches"],
                    function(el)
                      if string.match(url, el) then return true end end)
  then
    openChromeWithProfile(intuit["pf"], url)
    return true
  end

  -- Default
  hs.urlevent.openURLWithBundle(url, "org.mozilla.firefox")
end

hs.urlevent.httpCallback = handleHTTP
