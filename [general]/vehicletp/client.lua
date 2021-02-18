local key_to_teleport = 38

--[[
	{{x, y, z, Heading}, {x, y, z, Heading}, "Text to show when in the area."},
]]


local PlayerData                = {}

ESX                             = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().gang == nil do
		Citizen.Wait(100)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	PlayerData = ESX.GetPlayerData()
end)


RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
	PlayerData.gang = gang
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

local positions = {
	{{1109.63, -3164.89, -37.518, 0}, {188.29, 2786.67, 45.62, 277.0}, "LOST MC **TRESSPASSER WILL BE SHOT**", "lostmc"}, -- Outside the Sheriff's Station
	{{501.02, -1337.499, 29.32, 27.7}, {972.72, -2994.55, -39.64, 187.9}, "REDLINE P&R Auto Shop", "nogang"},
	{{936.64, -2999.331, -47.94, 270.0}, {977.61, -3001.92, -39.60, 87.0}, "Basement Garage", "nogang"},
	{{994.39, -3022.061, -39.94, 270.0}, {993.15, -3027.51, -35.60, 355.0}, "Lift 1", "redlinecrew"},
	{{998.29, -3021.061, -39.94, 355.0}, {998.15, -3027.31, -35.60, 355.0}, "Lift 2", "redlinecrew"},
	{{1004.09, -3027.391, -36.94, 355.0}, {1003.760, -3022.47, -39.60, 355.0}, "Lift 3", "redlinecrew"},
	{{1009.36, -3027.391, -36.94, 355.0}, {1009.760, -3021.47, -39.60, 85.0}, "Lift 4", "redlinecrew"},
	{{954.554, -3018.391, -36.94, 275.0}, {961.760, -3018.39, -39.60, 275.0}, "Lift 5", "redlinecrew"},
	{{954.554, -3023.391, -36.94, 275.0}, {961.760, -3023.39, -39.60, 275.0}, "Lift 6", "redlinecrew"},
	{{954.554, -3028.391, -36.94, 275.0}, {961.760, -3028.39, -39.60, 275.0}, "Lift 7", "redlinecrew"},
	{{959.554, -3035.391, -36.94, 355.0}, {959.760, -3031.39, -39.60, 355.0}, "Lift 8", "redlinecrew"},
	{{963.934, -3035.391, -36.94, 355.0}, {963.760, -3031.39, -39.60, 355.0}, "Lift 9", "redlinecrew"},
	{{967.934, -3035.391, -36.94, 355.0}, {967.760, -3031.39, -39.60, 355.0}, "Lift 10", "redlinecrew"},
	{{971.934, -3035.391, -36.94, 355.0}, {971.760, -3031.39, -39.60, 85.0}, "Lift 11", "redlinecrew"},
	{{975.934, -3035.391, -36.94, 355.0}, {976.760, -3031.39, -39.60, 85.0}, "Lift 12", "redlinecrew"},
	{{979.934, -3035.391, -36.94, 355.0}, {980.760, -3031.39, -39.60, 85.0}, "Lift 13", "redlinecrew"},
	{{-1145.286, -3397.909, 13.94, 328.0}, {-1267.002, -3013.39, -49.60, 179.0}, "Pax Air Hangar", "nogang"},
	{{2540.893, -336.909, 94.19, 201.0}, {893.832, -3245.39, -99.60, 88.0}, "PRIVATE PROPERTY, TRESPASSER'S WILL BE SHOT, SURVIVORS WILL BE SHOT TWICE", "armsdealer"},
	{{1874.693, 283.009, 164.89, 148.9}, {482.132, 4814.19, -58.30, 19.2}, "PRIVATE PROPERTY, TRESPASSER'S WILL BE SHOT, Co.", "company"},
	{{3540.693, 3675.009, 20.89, 166.9}, {3540.132, 3675.19, 28.12, 169.2}, "To Escape Tunnel", "nogang"},
	{{-84.1, -821.0, 36.0, 350.9}, {-72.2, -812.6, 284.9, 156.9}, "Lost Motors Mod Shop", "nogang"},
	{{-72.2, -812.6, 284.9, 156.9}, {-84.1, -821.0, 36.0, 350.9}, "Lost Motors Mod Shop Floor", "nogang"},
	{{-570.3, -146.4, 37.0, 205.7}, {-1517.9, -2978.6, -80.9, 273.7}, "DOJ Restricted Access Parking. Violators will be prosecuted for tresspassing", "usn"},
	{{-1507.6, -3023.8, -79.2, 184.8}, {-610.7, -100.6, 49.4, 277.5}, "Parliment of the City of Los Santos", "usn"},
	{{-1576.4, -587.2, 86.5, 302.2}, {-1579.2, -583.6, 91.8, 275.3}, "1-2", "nogang"},
	{{-1576.4, -587.2, 91.8, 302.2}, {-1579.2, -583.6, 97.1, 275.3}, "2-3", "nogang"},
	--{{-1586.3, -561.3, 86.5, 221.1}, {-1581.4, -561.9, 108.5, 278.3}, "Garage-Office", "nogang"},
	{{-1581.5, -558.2, 108.5, 143.8}, {-1560.7, -569.2, 114.4, 36.5}, "Roof Access", "nogang"},
	{{-1579.5, -564.9, 108.5, 303.5}, {-1581.3, -558.2, 34.9, 35.8}, "Front Door-Office", "nogang"},
	{{514.2, 4888.1, -62.5, 189.6}, {3100.1, -4813.4, 2.0, 343.2}, "Carrier-Subamrine", "usn"},
	{{514.1, 4843.8, -62.5, 187.9}, {524.1, -3163.6, 4.3, 58.1}, "Shore-Subamrine", "usn"},
	{{3085.1, -4822.8, 15.5, 164.9}, {491.1, -3367.6, 6.3, 358.1}, "To SHORE, VEHICLE ONLY", "usn"},
	{{-2303.3, 3382.8, 31.2, 51.9}, {-2287.1, 3372.6, 31.4, 234.1}, "Fort Zancudo, Military Base. RESTRICTED AREA, TRESSPASSERS WILL BE SHOT OR PROSECUTED -ENTRANCE-", "usn"},
	{{-2293.3, 3385.8, 31.2, 53.9}, {-2282.3, 3375.2, 31.5, 49.6}, "Fort Zancudo, Military Base. RESTRICTED AREA, TRESSPASSERS WILL BE SHOT OR PROSECUTED -EXIT-", "usn"},
	{{-1591.3, 2803.8, 16.2, 215.9}, {-1607.1, 2817.6, 17.7, 37.1}, "Fort Zancudo, Military Base. RESTRICTED AREA, TRESSPASSERS WILL BE SHOT OR PROSECUTED -ENTRANCE-", "usn"},
	{{-1599.3, 2798.8, 16.9, 221.9}, {-1608.1, 2811.6, 17.5, 214.9}, "Fort Zancudo, Military Base. RESTRICTED AREA, TRESSPASSERS WILL BE SHOT OR PROSECUTED -EXIT-", "usn"},
	{{1658.3, 2576.8, 45.2, 215.9}, {1758.1, 2615.6, 45.5, 37.1}, "Solitary", "nogang"},
	{{-2361.3, 3249.8, 32.2, 319.9}, {-2360.8, 3249.4, 92.9, 325.27}, "Tower Elevator", "nogang"},
	{{-139.2, -620.7, 168.8, 88.1}, {-130.3, -598.9, 48.24, 248.21}, "O'Connor Corporation Offices", "nogang"},
	{{-198.2, -580.4, 136.8, 275.7}, {-141.9, -617.7, 168.82, 272.77}, "O'Connor Corporation Garage", "nogang"},
	{{-144.27, -577.2, 32.42, 158.07}, {-176.2, -586.7, 136.82, 334.12}, "O'Connor Corporation Garage Lvl1", "oconnor"},
	{{-176.11, -586.0, 141.35, 343.87}, {-172.5, -586.2, 136.02, 85.11}, "lvl1 & lvl2", "oconnor"},
	{{-176.11, -586.0, 146.69, 343.87}, {-172.5, -586.2, 141.35, 85.11}, "lvl2 & lvl3", "oconnor"},
	{{-141.83, -590.5, 167.69, 130.36}, {-172.5, -586.2, 146.69, 85.11}, "lvl3 & Mod Garage", "oconnor"},
	{{-144.72, -599.19, 206.92, 165.47}, {-139.6, -613.9, 168.82, 104.22}, "Roof Access", "oconnor"},
	{{-138.44, -592.71, 167.92, 48.03}, {-142.8, -624.7, 168.82, 274.23}, "Mod Shop & Office", "oconnor"},
	{ {1085.45, 214.5, -49.22, 311.59}, {964.24, 58.92, 112.55, 242.03}, "Lobby", "company"},
	{ {978.01, 61.8, 120.22, 143.03}, {1119.44, 266.77, -45.845, 182.03}, "Helipad", "nogang"},
	{ {1099.55, 220.09, -48.12, 235.03}, {1000.38, -54.59, 74.845, 186.21}, "Show Car", "Company"}
}


Citizen.CreateThread(function()
	local teleport_text, loc1, loc2m, letSleep, playerPed, playerLoc, vehicle

	while true do
		Citizen.Wait(10)
		playerPed = PlayerPedId()
		playerLoc = GetEntityCoords(playerPed)
		letSleep = true

		for i,location in ipairs(positions) do
			teleport_text = location[3]
			gang = location[4]
			loc1 = {
				coords=vector3(location[1][1], location[1][2], location[1][3]),
				heading=location[1][4],
			}
			loc2 = {
				coords=vector3(location[2][1], location[2][2], location[2][3]),
				heading=location[2][4]
			}

			if #(playerLoc - loc1.coords) < 2 and (PlayerData.gang.name == gang or gang == 'nogang')  then
				letSleep = false
				alert(teleport_text)

				if IsControlJustReleased(0, key_to_teleport) then
					if IsPedInAnyVehicle(playerPed, true) then
						vehicle = GetVehiclePedIsUsing(playerPed)
						SetEntityCoords(vehicle, loc2.coords)
						SetEntityHeading(vehicle, loc2.heading)
					else
						SetEntityCoords(playerPed, loc2.coords)
						SetEntityHeading(playerPed, loc2.heading)
					end
				end

			elseif #(playerLoc - loc2.coords) < 2 then
				letSleep = false
				alert(teleport_text)

				if IsControlJustReleased(0, key_to_teleport) then
					if IsPedInAnyVehicle(playerPed, true) then
						vehicle = GetVehiclePedIsUsing(playerPed)
						SetEntityCoords(vehicle, loc1.coords)
						SetEntityHeading(vehicle, loc1.heading)
					else
						SetEntityCoords(playerPed, loc1.coords)
						SetEntityHeading(playerPed, loc1.heading)
					end
				end
			end
		end

		if letSleep then
			Citizen.Wait(500)
		end
	end
end)

function alert(msg)
	SetTextComponentFormat("STRING")
	AddTextComponentString(msg)
	DisplayHelpTextFromStringLabel(0,0,1,-1)
end