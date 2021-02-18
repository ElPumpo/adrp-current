ESX = nil
local currentCinema, choosenShow
local movieStatus, isInCinema = false, false
local cinemaScreenHash = GetHashKey('v_ilev_cin_screen')

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	-- prettify menu childs
	for k, v in pairs(Config.AvailableCinemaShows) do
		v.label = ('%s - <span style="color:green;">%s</span>'):format(v.label, _U('menu_item', ESX.Math.GroupDigits(v.price)))
	end
end)

-- adds blips for movie theater
function LoadBlips()
	for k,v in ipairs(Config.CinemaLocations) do
		local blip = AddBlipForCoord(v.coord)

		SetBlipSprite(blip, 135)
		SetBlipScale(blip, 1.2)
		SetBlipColour(blip, 4)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(_U('blip_cinema'))
		EndTextCommandSetBlipName(blip)
	end
end

function SetupMovie()
	isInCinema = true
	TriggerEvent('ui:toggle', false)
	local cinema = GetInteriorAtCoords(320.217, 263.81, 82.974)
	LoadInterior(cinema)

	if not DoesEntityExist(tv) then
		tv = CreateObjectNoOffset(cinemaScreenHash, 320.1257, 248.6608, 86.56934, 1, true, false)
		SetEntityHeading(tv, 179.99)
	else
		tv = GetClosestObjectOfType(319.884, 262.103, 82.917, 20.475, cinemaScreenHash, 0, 0, 0)
	end

	-- this checks if the rendertarget is registered and registers rendertarget
	if not IsNamedRendertargetRegistered('cinscreen') then
		RegisterNamedRendertarget('cinscreen', 0)
	end

	-- this checks if the screen is linked to rendertarget and links screen to rendertarget
	if not IsNamedRendertargetLinked(cinemaScreenHash) then
		LinkNamedRendertarget(cinemaScreenHash)
	end

	local rendertargetid = GetNamedRendertargetRenderId('cinscreen')

	-- this checks if the rendertarget is linked AND registered
	if IsNamedRendertargetLinked(cinemaScreenHash) and IsNamedRendertargetRegistered('cinscreen') then
		-- this sets the rendertargets channel and video
		Citizen.InvokeNative(0x9DD5A62390C3B735, 2, choosenShow, 0)

		-- this sets the rendertarget
		SetTextRenderId(rendertargetid)

		-- sets the volume
		SetTvVolume(100)

		-- sets the cannel
		SetTvChannel(2)

		-- sets subtitles
		EnableMovieSubtitles(1)

		-- these are for the rendertarget 2d settings and stuff
		Citizen.InvokeNative(0x67A346B3CDB15CA5, 100.0)
		SetScriptGfxDrawOrder(4)
		SetScriptGfxDrawBehindPausemenu(true)
	else
		-- this puts the rendertarget back to regular use(playing)
		SetTextRenderId(GetDefaultScriptRendertargetRenderId())
	end

	if not movieStatus then
		movieStatus = true
		CreateMovieThread()
	end
end

-- this FUNCTION deletes the movie screen sets the channel to basicly nothing
function DeconstructMovie()
	local obj = GetClosestObjectOfType(319.884, 262.103, 82.917, 20.475, cinemaScreenHash, 0, 0, 0)

	SetTvChannel(-1)
	ReleaseNamedRendertarget(GetHashKey('cinscreen'))
	SetTextRenderId(GetDefaultScriptRendertargetRenderId())
	SetEntityAsMissionEntity(obj, true, false)
	DeleteObject(obj)
end

--this starts the movie
function CreateMovieThread()
	Citizen.CreateThread(function()
		SetTextRenderId(GetNamedRendertargetRenderId('cinscreen'))
		Citizen.InvokeNative(0x9DD5A62390C3B735, 2, choosenShow, 0)
		SetTvChannel(2)
		EnableMovieSubtitles(1)
		Citizen.InvokeNative(0x67A346B3CDB15CA5, 100.0)
		SetScriptGfxDrawOrder(4)
		SetScriptGfxDrawBehindPausemenu(true)

		while isInCinema do
			Citizen.Wait(0)
			DrawTvChannel(0.5, 0.5, 1.0, 1.0, 0.0, 255, 255, 255, 255)
		end
	end)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed)
		local letSleep, hour = true, GetClockHours()

		for k,v in ipairs(Config.CinemaLocations) do
			-- Check if the player is near the cinema
			if GetDistanceBetweenCoords(playerCoords, v.coord, true) < 4.8 then
				letSleep = false

				-- Check if the cinema is open or closed.
				if hour < Config.OpeningHour or hour > Config.ClosingHour then
					ESX.ShowHelpNotification(_U('cinema_prompt_closed'))
				else
					ESX.ShowHelpNotification(_U('cinema_prompt'))

					-- Check if the player is near the cinema and pressed 'INPUT_CONTEXT'
					if IsControlJustReleased(0, 38) then
						ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu_cinema', {
							title    = _U('cinema_menutitle'),
							align    = 'top-left',
							elements = Config.AvailableCinemaShows
						}, function(data, menu)
							menu.close()
							choosenShow = data.current.showName

							ESX.TriggerServerCallback('esx_cinema:payPrice', function(paid)
								if paid then
									ESX.ShowNotification(_U('cinema_youpaid', ESX.Math.GroupDigits(data.current.price)))
									DoScreenFadeOut(1000)
									SetupMovie()

									Citizen.Wait(500)
									ESX.Game.Teleport(playerPed, vector3(320.2, 263.8, 81.9))

									DoScreenFadeIn(800)
									Citizen.Wait(30)

									currentCinema = v.name
									TriggerEvent('esx_cinema:enteredCinema')
									SetEntityHeading(playerPed, 180.0)
									TaskLookAtCoord(playerPed, 319.259, 251.827, 85.648, -1, 2048, 3)
									FreezeEntityPosition(playerPed, true)

									ESX.ShowNotification(_U('cinema_entered'))
								else
									ESX.ShowNotification(_U('cinema_poor'))
								end
							end, choosenShow)

						end, function(data, menu)
							menu.close()
						end)
					end
				end

				break
			end
		end

		if letSleep then
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)

		local hour = GetClockHours()
		local min = GetClockMinutes()
		if hour == 19 and min == 00 then
			ESX.ShowAdvancedNotification('ADRP THEATERS', '~b~OPEN!', 'Movie Theaters are now open!', 'CHAR_PROPERTY_CINEMA_VINEWOOD', 2)
		elseif hour == 23 and min == 00 then
			ESX.ShowAdvancedNotification('ADRP THEATERS', '~r~CLOSED!', 'Movie Theaters are now closed!', 'CHAR_PROPERTY_CINEMA_VINEWOOD', 2)
		end
	end
end)

-- if the player is not inside theater delete screen
Citizen.CreateThread(function()
	if GetRoomKeyFromEntity(PlayerPedId()) ~= -1337806789 and DoesEntityExist(GetClosestObjectOfType(319.884, 262.103, 82.917, 20.475, cinemaScreenHash, 0, 0, 0)) then
		DeconstructMovie()
	end

	-- Create the blips for the cinema's
	LoadBlips()

	-- loads the theater interior
	RequestIpl('v_cinema')
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if isInCinema then
			local player, playerPed = PlayerId(), PlayerPedId()
			SetPlayerInvincible(player, true)
			SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)

			if IsControlJustReleased(0, 38) then
				DoScreenFadeOut(1000)
	
				for k,v in ipairs(Config.CinemaLocations) do
					if v.name == currentCinema then
						ESX.Game.Teleport(playerPed, v.coord, function()
							SetEntityHeading(playerPed, v.heading)
						end)
						break
					end
				end
	
				Citizen.Wait(30)
				DoScreenFadeIn(800)
				TriggerEvent('esx_cinema:exitedCinema')
				ESX.UI.Menu.CloseAll()
	
				FreezeEntityPosition(playerPed, false)
				DeconstructMovie()
				SetPlayerInvincible(player, false)
				movieStatus = false
				Citizen.Wait(800)
				TriggerEvent('ui:toggle', true)
				isInCinema = false
			end
		else
			Citizen.Wait(500)
		end
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if isInCinema then
			local playerPed = PlayerPedId()

			for k,v in ipairs(Config.CinemaLocations) do
				if v.name == currentCinema then
					ESX.Game.Teleport(playerPed, v.coord, function()
						SetEntityHeading(playerPed, v.heading)
						FreezeEntityPosition(playerPed, false)
						SetPlayerInvincible(PlayerId(), false)
						TriggerEvent('ui:toggle', true)
					end)
					break
				end
			end
		end
	end
end)