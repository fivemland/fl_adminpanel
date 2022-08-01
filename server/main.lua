local adminsOnDuty = {}

-- Callback
ESX.RegisterServerCallback("PlayerGroup", function(source, cb)
	local xSource = ESX.GetPlayerFromId(source)
	cb(xSource.getGroup())
end)	

-- Event
RegisterNetEvent("setAdminsOnDuty")
AddEventHandler("setAdminsOnDuty", function(onduty)
    adminsOnDuty = onduty
end)

-- DISCORD LOG
function SendToDiscord(color, name, message, url)
	local embed = {
			{
				["color"] = color,
				["title"] = "**".. name .."**",
				["description"] = message,
				["footer"] = {
					["text"] = footer,
				},
			}
		}
	
	PerformHttpRequest(url, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
end
RegisterNetEvent("adam_adminpanel:SendToDiscord", SendToDiscord)
