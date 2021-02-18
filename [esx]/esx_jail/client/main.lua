isInJail, unjail, isDead, jailTime = false, false, false, 0

local countPlayersInJail, jailBreakCooldownActive, jailBlip = 0, false

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
	isDead = false
end)

function secondsToClock(seconds)
	local seconds, hours, mins, secs = tonumber(seconds), 0, 0, 0

	if seconds <= 0 then
		return 0, 0
	else
		local hours = string.format("%02.f", math.floor(seconds / 3600))
		local mins = string.format("%02.f", math.floor(seconds / 60 - (hours * 60)))
		local secs = string.format("%02.f", math.floor(seconds - hours * 3600 - mins * 60))

		return hours, mins, secs
	end
end

-- Create Blips
Citizen.CreateThread(function()
	jailBlip = AddBlipForCoord(Config.JailBlip)

	SetBlipSprite(jailBlip, 188)
	SetBlipScale (jailBlip, 1.9)
	SetBlipColour(jailBlip, 6)
	SetBlipAsShortRange(jailBlip, true)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(_U('blip_name'))
	EndTextCommandSetBlipName(jailBlip)

	refreshJailBlip()

	local blip = AddBlipForCoord(Config.Locations.PrisonBreak)

	SetBlipSprite(blip, 480)
	SetBlipScale (blip, 0.7)
	SetBlipColour(blip, 44)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(_U('blip_breakout'))
	EndTextCommandSetBlipName(blip)
end)

RegisterNetEvent('esx_jail:updatePlayersInJail')
AddEventHandler('esx_jail:updatePlayersInJail', function(playersInJail)
	countPlayersInJail = playersInJail
	refreshJailBlip()
end)

RegisterNetEvent('esx_jail:updateCooldownStatus')
AddEventHandler('esx_jail:updateCooldownStatus', function(state)
	jailBreakCooldownActive = state
	refreshJailBlip()
end)

function refreshJailBlip()
	exports['fivem-blipapi']:ResetBlipInfo(jailBlip)
	exports['fivem-blipapi']:SetBlipInfoTitle(jailBlip, _U('blip_name'), false)
	exports['fivem-blipapi']:AddBlipInfoText(jailBlip, 'Players in Jail', tostring(countPlayersInJail))
	exports['fivem-blipapi']:AddBlipInfoText(jailBlip, 'High Security Active', (jailBreakCooldownActive and 'Yes' or 'No'))

	RequestStreamedTextureDict('blip_general')

	while not HasStreamedTextureDictLoaded('blip_general') do
		Citizen.Wait(100)
	end

	exports['fivem-blipapi']:SetBlipInfoImage(jailBlip, 'blip_general', 'blip_prison')
	exports['fivem-blipapi']:AddBlipInfoHeader(jailBlip, '') -- Empty header adds the header line
	exports['fivem-blipapi']:AddBlipInfoText(jailBlip, 'Don\'t drop the soap! High security jail in San-Andreas where all bad guys are at, and also big guy Tyrone.')
end

Citizen.CreateThread(function()
	local base64Image = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAEAAAABNCAMAAAAhKZIyAAAABGdBTUEAALGPC/xhBQAAAwBQTFRFAAAA3XMp3XQp3HQq3XUr3XUs3ncu33gv4WgT4WkU4WkV92oF9W0N+2sE+WsG/moA/WoB/moC/WsD/msE+GwK+W4L/W8K/W8L8W0Q+XAO9XES9XMW8ncf5HEh5XMk5XQj5XQk5XQl4Hkx83wn930l9Hwn+n0k/n0j54Q/6II524RH3IVG3IRH24VI3IVI3IVJ3IZJ3IZK3YhM54xL7I9N7ZBN55BS6pFS65JT7ppf5Z5r7Z1k76Nu56Jx7Kp87L6c8bOG8L+b78Sm78Wn8Mao8Map8ciq8cir8cis8squ88uv88uw9Myx9M6y9c6z9c+0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAhiCDCQAAAQB0Uk5T////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////AFP3ByUAAAAJcEhZcwAACxEAAAsRAX9kX5EAAAAYdEVYdFNvZnR3YXJlAHBhaW50Lm5ldCA0LjEuNv1OCegAAAFBSURBVFhH7ZbXUsMwEEVND1Wmd5LQe++9hV7+/2vErnMhTGYlTNYPgdF58t1yRhr7wVEeFI9swhKyTGG3PLVXQCEfmU/iY+6MITmZ46kdBKIiMKvUuelFcDLMgiYE4ptghTrXPwqGWNCAQPz6BNkIGhGIKsGtVlDSXGG5LgR3WsF9OoH8Ia1R50EjWNcKNrIQPKYTNCMQWQo2qfOkFTxrr6AS8AleNIKtLASvWsFbOkELAlEleP/bgm1u9SM4SQStCERFEJ9xawTJyQRP7SMQUQ50HHDHXk0iO5hKpuxiO3IuKhdq578L5hcSZhFFfIIevCkzjoKETxBj33SiIBEEQcAEQRAwQRAETBAEAVPfgq8f71oFfdg3AyhI+ARd2DczKEj4BOe4Q/cFChI+gT0d5P3RS0QRr8Daw7bpEzyKWPsBgnZ5mw9ayr4AAAAASUVORK5CYII='
	local formatted = ("<img src='%s' height='16'> <b>{0}</b>"):format(base64Image)
	TriggerEvent('chat:addTemplate', 'jail', formatted)
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('chat:removeTemplate', 'jail')
		TriggerEvent('esx_jail:updateRemainingTime', '00:00')
	end
end)