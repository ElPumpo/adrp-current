ESX = nil
local StationsPrice, serverEssenceArray = {}, {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('esx_advancedfuel:getStationPrices')
AddEventHandler('esx_advancedfuel:getStationPrices', function()
	TriggerClientEvent('esx_advancedfuel:sendStationPrices', source, StationsPrice)
end)

RegisterNetEvent('esx_advancedfuel:syncFuelWithPlayers')
AddEventHandler('esx_advancedfuel:syncFuelWithPlayers', function(essence, vplate, vmodel)
	local _source = source
	local bool, ind = searchByModelAndPlate(vplate, vmodel)
	if(bool and ind ~= nil) then
		serverEssenceArray[ind].es = essence
	else
		if(vplate ~=nil and vmodel~=nil and essence ~=nil) then
			table.insert(serverEssenceArray,{plate=vplate,model=vmodel,es=essence})
		end
	end

	TriggerClientEvent('esx_advancedfuel:syncFuelWithPlayers', -1, essence, vplate, vmodel)
end)

RegisterNetEvent('esx_advancedfuel:buyFuel')
AddEventHandler('esx_advancedfuel:buyFuel', function(amount, index, e)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = StationsPrice[index]

	if e then
		price = index
	end

	local toPay = ESX.Math.Round(amount * price)

	if toPay > xPlayer.getMoney() then
		TriggerClientEvent('esx_advancedfuel:showErrorMessage', source, 'You cannot afford that. Come back with some more money!')
	else
		xPlayer.removeMoney(toPay)
		TriggerClientEvent('esx_advancedfuel:buyFuel', source, amount)
	end
end)

RegisterNetEvent('essence:buy')
AddEventHandler('essence:buy', function()
	local date = os.date('%Y-%m-%d %H:%M')
	local identifier = GetPlayerIdentifiers(source)[1]
	print(('esx_advancedfuel: %s attempted to run old event :buy!'):format(identifier))

	local message = (('esx_advancedfuel attempted to run old event :buy!\n\nSource: %s | %s\nTime & Day: %s'):format(source, identifier, date))
	TriggerEvent('adrp_anticheat:cheaterDetected', message)
	TriggerEvent('adrp_anticheat:banCheater', source)
end)

RegisterNetEvent('esx_advancedfuel:requestStationPrices')
AddEventHandler('esx_advancedfuel:requestStationPrices',function()
	TriggerClientEvent('esx_advancedfuel:sendStationPrices', source, StationsPrice)
end)

RegisterNetEvent('esx_advancedfuel:getFuel')
AddEventHandler('esx_advancedfuel:getFuel', function(plate, model)
	local _source = source
	local bool, ind = searchByModelAndPlate(plate, model)

	if bool then
		TriggerClientEvent('esx_advancedfuel:sendFuel', _source, 1, serverEssenceArray[ind].es)
	else
		TriggerClientEvent('esx_advancedfuel:sendFuel', _source, 0, 0)
	end
end)

RegisterNetEvent('esx_advancedfuel:setFuel')
AddEventHandler('esx_advancedfuel:setFuel', function(percent, vplate, vmodel)
	local bool, ind = searchByModelAndPlate(vplate, vmodel)

	local percentToEs = (percent/100)*0.142

	if bool then
		serverEssenceArray[ind].es = percentToEs
	else
		table.insert(serverEssenceArray, {
			plate = vplate,
			model = vmodel,
			es = percentToEs
		})
	end
end)

RegisterNetEvent('esx_advancedfuel:buyFuelCan')
AddEventHandler('esx_advancedfuel:buyFuelCan', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getMoney() >= petrolCanPrice then
		xPlayer.removeMoney(petrolCanPrice)
		xPlayer.addWeapon('WEAPON_PETROLCAN', 4500)
		TriggerClientEvent('esx_advancedfuel:showDoneMessage', source, ('You bought a fuel can for $%s'):format(petrolCanPrice))
	else
		TriggerClientEvent('esx_advancedfuel:showErrorMessage', source, 'You cannot afford a fuel can.')
	end
end)

function renderPrice()
	for i=0,34 do
		if(randomPrice) then
			StationsPrice[i] = math.random(15,50)/100
		else
			StationsPrice[i] = price
		end
	end
end

renderPrice()

function searchByModelAndPlate(plate, model)
	for i,k in pairs(serverEssenceArray) do
		if(k.plate == plate and k.model == model) then
			return true, i
		end
	end

	return false, -1
end