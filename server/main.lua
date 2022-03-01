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

-- Commands
RegisterCommand("command", function(source, args, rawCommand)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getGroup() ~= 'user' then
		if adminsOnDuty[source] then
			TriggerClientEvent('chat:addMessage', source ,{
				color = { 0, 255, 0},
				multiline = true,
				args = {"Admin System", "This is a message"}
			})
			SendToDiscord(1752220,"Title", "Message", AAP.DiscordWebhook) --(1752220) colors: https://gist.github.com/thomasbnt/b6f455e2c7d743b796917fa3c205f812
		else
			TriggerClientEvent('chat:addMessage',source, {
				color = { 255, 0, 0},
				multiline = true,
				args = {"Admin System", "You must go into on duty first!"}
			})
		end
	else 
		TriggerClientEvent('chat:addMessage',source, {
			color = { 255, 0, 0},
			multiline = true,
			args = {"Admin System", "You do not have permission!"}
		})
	end
end, false)

RegisterNetEvent("adam_adminpanel:SendToDiscord")
AddEventHandler("adam_adminpanel:SendToDiscord", function(color, name, message, url)
	SendToDiscord(color, name, message, url)
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
