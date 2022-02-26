
ESX.RegisterServerCallback("PlayerGroup", function(source, cb)
	local xSource = ESX.GetPlayerFromId(source)
	cb(xSource.getGroup())
end)


