function toggleApp(appName)
	local app = hs.application.get(appName)
	if app == nil then
		hs.application.launchOrFocus(appName)
	elseif app:isFrontmost() then
		app:hide()
	else
		hs.application.launchOrFocus(appName)
	end
end

hs.application.enableSpotlightForNameSearches(true)
hs.hotkey.bind({ "ctrl" }, "i", function()
	toggleApp("wezterm")
end)
