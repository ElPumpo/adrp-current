
local Spawnables = {

	["SniperRifle"]= {
		hash = "PICKUP_WEAPON_SNIPERRIFLE",
		item = "WEAPON_SNIPERRIFLE",
		x= 1282.336, y= -3211.73, z= 21.193
	},

	["SniperRifle2"]= {
		hash = "PICKUP_WEAPON_SNIPERRIFLE",
		item = "WEAPON_SNIPERRIFLE",
		x= 1282.336, y= -3213.73, z= 21.193
	},

	["SniperRifle3"]= {
		hash = "PICKUP_WEAPON_SNIPERRIFLE",
		item = "WEAPON_SNIPERRIFLE",
		x= 1282.336, y= -3215.73, z= 21.193
	},

	["Armour"]= {
		hash = "PICKUP_ARMOUR_STANDARD",
		item = "WEAPON_SNIPERRIFLE",
		x= 1283.336, y= -3211.73, z= 21.193
	},

	["Armour2"]= {
		hash = "PICKUP_ARMOUR_STANDARD",
		item = "WEAPON_SNIPERRIFLE",
		x= 1283.336, y= -3213.73, z= 21.193
	},

	["Armour3"]= {
		hash = "PICKUP_ARMOUR_STANDARD",
		x= 1283.336, y= -3215.73, z= 21.193
	},
}

local activated = false

RegisterNetEvent('ADRP:DuckHunt')
AddEventHandler('ADRP:DuckHunt', function(bool)
	if bool == true then
		activated = true
	else
		activated = false
		RemoveAllPickupsOfType(GetHashKey("PICKUP_ARMOUR_STANDARD"))
		RemoveAllPickupsOfType(GetHashKey("PICKUP_WEAPON_SNIPERRIFLE"))
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if not activated then
			Citizen.Wait(500)
		elseif activated then
			RestorePlayerStamina(PlayerPedId())
			SpawnSpawnables()
			activated = false
		end
	end
end)

function SpawnSpawnables()
	for k,v in pairs(Spawnables) do
		CreateAmbientPickup(GetHashKey(v.hash), v.x, v.y, v.z, 0, 40000, 1, false, true)
 	end
end


RegisterNetEvent('ADRP:chosenSniper')
AddEventHandler('ADRP:chosenSniper', function()
	local playerPed = PlayerPedId()
	GiveWeaponToPed(playerPed, GetHashKey("weapon_sniperrifle"), 100, false, true)
	SetEntityCoords(playerPed, 1392.789, -3243.8310, 21.878, 0, 0, 0, 0)
	SetEntityHeading(playerPed, 90.0)
end)