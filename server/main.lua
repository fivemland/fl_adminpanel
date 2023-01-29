local dutyStarts = {}

-- Callback
ESX.RegisterServerCallback("adminpanel:PlayerGroup", function(source, cb)
	local xSource = ESX.GetPlayerFromId(source)
	cb(AAP.AdminGroups[xSource.getGroup()])
end)	

ESX.RegisterServerCallback('changePlayerDutyState', function(source, cb)
	local playerName <const> = GetPlayerName(source)
	local sb = Player(source).state

	local newState <const> = not sb.adminDuty
	sb.adminDuty = newState

	local timeOnDuty = 0
	if (newState) then 
		dutyStarts[source] = os.time()
	else 
		if (dutyStarts[source]) then 
			timeOnDuty = SecondsToClock(os.time() - dutyStarts[source])
		end
	end

	SendToDiscord(1752220, "Adminduty", playerName .. " " .. (newState and "belépett a szolgálatba" or "kilépett a szolgálatból\nSzolgálatban töltött idő: " .. timeOnDuty), AAP.DiscordWebhook)

	cb(newState, timeOnDuty)
end)

-- DISCORD LOG
function SendToDiscord(color, name, message, url)
	local embed <const> = {
			{
				["color"] = color,
				["title"] = "**".. name .."**",
				["description"] = message,
			}
		}
	PerformHttpRequest(url, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
end

function SecondsToClock(seconds)
  local seconds = tonumber(seconds)

  if seconds <= 0 then
    return "00:00:00";
	end

	local hours <const> = string.format("%02.f", math.floor(seconds / 3600));
	local mins <const> = string.format("%02.f", math.floor(seconds / 60 - (hours * 60)));
	local secs <const> = string.format("%02.f", math.floor(seconds - hours * 3600 - mins * 60));
	return hours .. ":" .. mins .. ":" .. secs
end

-- Exports
function isPlayerInAdminduty(player)
	return Player(player).state.adminDuty
end
exports('isPlayerInAdminduty', isPlayerInAdminduty)