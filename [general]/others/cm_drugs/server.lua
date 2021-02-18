local harvesting = {}

ESX.RegisterServerCallback('drugs:tryCollect', function(source, cb, data)
	local _source = source
	local rval = true

	for k,v in pairs(harvesting) do
		if v.source == _source then
			rval = false
			break
		end
	end

	if data.required ~= nil then
		local xPlayer  = ESX.GetPlayerFromId(_source)
		local req = xPlayer.getInventoryItem(data.required)
		local reqcount = 1

		if data.required_count ~= nil then
			reqcount = data.required_count
		end

		if req.count < reqcount then
			rval = false
		end
	end

	cb(rval)
end)

RegisterServerEvent('drugs:startHarvest')
AddEventHandler('drugs:startHarvest', function(loc)
	local _source = source
	local data = {source = _source, other = loc, harvest = 0}
	local exists = false

	for k,v in pairs(harvesting) do
		if v.source == _source then
			exists = true
			v.other = data.other
			v.harvest = data.harvest
		end
	end

	if exists == false then
		table.insert(harvesting, data)
	end
end)

RegisterServerEvent('drugs:stopHarvest')
AddEventHandler('drugs:stopHarvest', function()
	local _source = source

	for k,v in pairs(harvesting) do
		if v.source == _source then
			table.remove(harvesting, k)
		end
	end
end)

AddEventHandler('playerDropped', function()
	local _source = source
	for k,v in pairs(harvesting) do
		if v.source == _source then
			table.remove(harvesting, k)
		end
	end
end)

--Main Loop
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		for k,v in pairs(harvesting) do
			v.harvest = v.harvest + 1
			if math.fmod(v.harvest, v.other.time) == 0 then

				if v.other.required ~= nil then
					local xPlayer  = ESX.GetPlayerFromId(v.source)
					local req = xPlayer.getInventoryItem(v.other.required)
					local reqcount = 1

					if v.other.required_count ~= nil then
						reqcount = v.other.required_count
					end

					if req.count >= reqcount then
						--Give item
						xPlayer.addInventoryItem(v.other.item, 1)
						xPlayer.removeInventoryItem(v.other.required, reqcount)
						--Remove required
					else
						TriggerClientEvent('drugs:stopHarvestClient', v.source)
						table.remove(harvesting, k)
					end
				else
					local xPlayer = ESX.GetPlayerFromId(v.source)
					--Give item
					xPlayer.addInventoryItem(v.other.item, 1)
				end
			end
		end
	end
end)