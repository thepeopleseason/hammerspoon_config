-- open Chrome with a specific named Profile
function chromeWithProfile(profile, url)
  local t = hs.task.new(
    "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
    nil,
    function() return false end,
    { "--profile-directory=" .. profile, url })
  t:start()
end

-- IN PROGRESS (May just give up and stick with finicky.js)
function handleHTTP(scheme, host, params, url, sender)
  local intuit = "Profile 3"
  local mailchimp = "Profile 2"
  local mchosts = { "rsglab", "mailchimp", "mcpeeps", "meet.google.com" }
  local inthosts = { "intuit", "alight.com", "perksatwork.com", "degreed.com",
                     "www.concursolutions.com", "align.ustream.tv", "outlook.office365.com" }

  if hs.eventtap.checkKeyboardModifiers()["cmd"] then chromeWithProfile(mailchimp, url) end
  if hs.eventtap.checkKeyboardModifiers()["shift"] then chromeWithProfile(intuit, url) end
end
