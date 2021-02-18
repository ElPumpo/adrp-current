TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('adrp_evidence:PlaceEvidenceS')
AddEventHandler('adrp_evidence:PlaceEvidenceS', function(pos, obj, weapon, weaponType)
	local xPlayer = ESX.GetPlayerFromId(source)
	local fullName = xPlayer.name

	TriggerClientEvent('adrp_evidence:PlaceEvidenceC', -1, pos, obj, fullName, weapon, weaponType)
end)

ESX.RegisterServerCallback('adrp_evidence:PickupEvidenceS', function(source, cb, evidence)
	local xPlayer = ESX.GetPlayerFromId(source)

	local cbData
	if evidence.obj == Config.BloodObject then
		local count = xPlayer.getInventoryItem('blood')

		if count and count.count > 0 then
			cbData = false
		else
			xPlayer.addInventoryItem('blood', 1)
			TriggerClientEvent('adrp_evidence:PickupEvidenceC', -1, evidence)
			cbData = true
		end
	elseif evidence.obj == Config.ResidueObject then
		local count = xPlayer.getInventoryItem('bulletsample')
		if count and count.count > 0 then
			cbData = false
		else
			xPlayer.addInventoryItem('bulletsample', 1)
			TriggerClientEvent('adrp_evidence:PickupEvidenceC', -1, evidence)
			cbData = true
		end
	end

	cb(cbData)
end)

ESX.RegisterServerCallback('adrp_evidence:PlayersJob', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local cbData = xPlayer.getJob()

	cb(cbData)
end)

ESX.RegisterUsableItem('dnaanalyzer', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getInventoryItem('blood').count > 0 then
		xPlayer.removeInventoryItem('blood', 1)
		TriggerClientEvent('adrp_evidence:AnalyzeDNA', source)
	end
end)

ESX.RegisterUsableItem('ammoanalyzer', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getInventoryItem('bulletsample').count > 0 then
		xPlayer.removeInventoryItem('bulletsample', 1)
		TriggerClientEvent('adrp_evidence:AnalyzeCasing', source)
	end
end)