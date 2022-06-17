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


function handleHTTP(scheme, host, params, url, sender)
  local mailchimp = {
    pf    = "Profile 2",
    hosts = { "rsglab", "mailchimp", "mcpeeps", "meet.google.com" },
    paths = { "mailchimp" }
  }
  local intuit = {
    pf    = "Profile 3",
    hosts = { "intuit", "alight.com", "perksatwork.com", "degreed.com",
                "www.concursolutions.com", "align.ustream.tv", "outlook.office365.com" },
    paths = { "intuit" }
  }

  if string.match(host, "open.spotify.com") then
    openSpotify(url)
    return true
  end

  if hs.eventtap.checkKeyboardModifiers()["cmd"] or
    hs.fnutils.some(mailchimp["hosts"], function(el)
                      if string.match(host, el) then return true end end)
  then
    openChromeWithProfile(mailchimp["pf"], url)
    return true
  end

  if hs.eventtap.checkKeyboardModifiers()["shift"] or
    hs.fnutils.some(intuit["hosts"],
                    function(el)
                      if string.match(host, el) then return true end end)
  then
    openChromeWithProfile(intuit["pf"], url)
    return true
  end

  if hs.fnutils.some(mailchimp["paths"],
                     function(el)
                       if string.match(url, el) then return true end end)
  then
    openChromeWithProfile(mailchimp["pf"], url)
    return true
  end

  if hs.fnutils.some(intuit["paths"],
                     function(el)
                       if string.match(url, el) then return true end end)
  then
    openChromeWithProfile(intuit["pf"], url)
    return true
  end

  hs.urlevent.openURLWithBundle(url, "org.mozilla.firefox")
end

hs.urlevent.httpCallback = handleHTTP
