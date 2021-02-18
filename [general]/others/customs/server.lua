local tbl = {
	[1] = {locked = false, player = nil},
	[2] = {locked = false, player = nil},
	[3] = {locked = false, player = nil},
	[4] = {locked = false, player = nil},
	[5] = {locked = false, player = nil},
	[6] = {locked = false, player = nil},
	[7] = {locked = false, player = nil},
	[8] = {locked = false, player = nil},
	[9] = {locked = false, player = nil},
	[10] = {locked = false, player = nil},
	[11] = {locked = false, player = nil},
	[12] = {locked = false, player = nil}
}

RegisterServerEvent('lockGarage')
AddEventHandler('lockGarage', function(state, garage)
	local playerId = source
	local garage = tbl[tonumber(garage)]

	if garage then
		garage.locked = state

		if not state then
			garage.player = nil
		else
			garage.player = playerId
		end

		TriggerClientEvent('lockGarage',-1,tbl)
	else
		print('others: Could not handle exception lockGarage :/')
	end
end)

RegisterServerEvent('getGarageInfo')
AddEventHandler('getGarageInfo', function()
	TriggerClientEvent('lockGarage',-1,tbl)
end)

AddEventHandler('playerDropped', function()
	for i,g in pairs(tbl) do
		if g.player then
			if source == g.player then
				g.locked = false
				g.player = nil
				TriggerClientEvent('lockGarage',-1,tbl)
			end
		end
	end
end)

RegisterServerEvent("LSC:buttonSelected")
AddEventHandler("LSC:buttonSelected", function(name, button)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local mechanic = false

	if xPlayer.job.name == 'mecano' and button.price ~= nil then
		button.price = 0.80 * tonumber(button.price)
	else
		button.price = tonumber(button.price)
	end

	if button.price then -- check if button have price
		if button.price < xPlayer.getMoney() then
			TriggerClientEvent("LSC:buttonSelected", source,name, button, true)
			xPlayer.removeMoney(button.price)
			TriggerClientEvent('LSC:installMod', _source)
		else
			TriggerClientEvent("LSC:buttonSelected", source,name, button, false)
			TriggerClientEvent('LSC:cancelInstallMod', _source)
		end
	end
end)

-- TODO only allow some values to be changed
RegisterServerEvent('LSC:refreshOwnedVehicle')
AddEventHandler('LSC:refreshOwnedVehicle', function(vehicleProps)
	local playerId = source

	MySQL.Async.fetchAll('SELECT vehicle FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = vehicleProps.plate
	}, function(result)
		if result[1] then
			local remoteVehicle = json.decode(result[1].vehicle)

			if vehicleProps.model == remoteVehicle.model then
				MySQL.Async.execute('UPDATE owned_vehicles SET vehicle = @vehicle WHERE plate = @plate', {
					['@plate']   = vehicleProps.plate,
					['@vehicle'] = json.encode(vehicleProps)
				})
			else
				print(('customs: %s attempted to refresh vehicle with mismatching model!'):format(GetPlayerIdentifier(playerId, 0)))
			end
		end
	end)
end)

RegisterServerEvent("LSC:finished")
AddEventHandler("LSC:finished", function(veh)
	local model = veh.model --Display name from vehicle model(comet2, entityxf)
	local mods = veh.mods
	local color = veh.color
	local extracolor = veh.extracolor
	local neoncolor = veh.neoncolor
	local smokecolor = veh.smokecolor
	local plateindex = veh.plateindex
	local windowtint = veh.windowtint
	local wheeltype = veh.wheeltype
	local bulletProofTyres = veh.bulletProofTyres
	--Do w/e u need with all this stuff when vehicle drives out of lsc
end)
