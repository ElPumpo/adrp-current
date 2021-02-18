ESX = nil
local deleteGunActive, canSync = false, true
admin, PlayerData = false, {}
isProne, isOnBack, isCrouching, isOnKnees = false, false, false, false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
	PlayerData.gang = gang
end)

function Notify(text)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(text)
	DrawNotification(false, true)
end

function startSyncCooldown()
	Citizen.CreateThread(function()
		Citizen.Wait(1000 * 60 * 15)
		canSync = true
	end)
end

function OpenPersonnelMenu()
	ESX.UI.Menu.CloseAll()

	ESX.TriggerServerCallback('NB:getUsergroup', function(group)
		playergroup = group

		local elements = {
			{label = 'Personal Menu', value = 'menuperso_moi'},
			{label = 'Animation List', value = 'menuperso_actions'}
		}

		if IsInVehicle() then
			local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
			if GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
				table.insert(elements, {label = 'Vehicle Managment', value = 'menuperso_vehicule'})
			end
		end

		table.insert(elements, {label = 'Report an Incident', value = 'menuperso_report'})

		if PlayerData.job.grade_name == 'boss' then
			table.insert(elements, {label = 'Business Management', value = 'menuperso_grade'})
		end

		if PlayerData.gang.name ~= 'nogang' then
			table.insert(elements, {label = 'Gang Interactions', value = 'menuperso_gang'})
		end

		table.insert(elements, {label = 'Request a Train', value = 'train'})

		if playergroup == 'mod' or playergroup == 'admin' or playergroup == 'superadmin' or playergroup == 'owner' then
			table.insert(elements, {label = 'Administration Tools', value = 'menuperso_modo'})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu_perso', {
			title    = 'Personal Menu',
			align    = 'bottom-right',
			elements = elements
		}, function(data, menu)
			elements = {}

			if playergroup == 'mod' then
				table.insert(elements, {label = 'Toggle Delete Gun',									value = 'deleteGun'})
				table.insert(elements, {label = 'TP to player',								value = 'menuperso_modo_tp_toplayer'})
				table.insert(elements, {label = 'TP player to me',			 			value = 'menuperso_modo_tp_playertome'})
				table.insert(elements, {label = 'Repair your Vehicle',							value = 'menuperso_modo_vehicle_repair'})
				table.insert(elements, {label = 'Spawn Vehicle',							value = 'menuperso_modo_vehicle_spawn'})
				table.insert(elements, {label = 'TP to Waypoint',							value = 'menuperso_modo_tp_marcker'})
				table.insert(elements, {label = 'Access Reports',						value = 'menuperso_reports'})
			elseif playergroup == 'admin' then
				table.insert(elements, {label = 'Save the appearance',									value = 'menuperso_modo_save_skin'})
			elseif (playergroup == 'superadmin' or playergroup == 'owner') then
				table.insert(elements, {label = 'Toggle Delete Gun',									value = 'deleteGun'})
				table.insert(elements, {label = 'Toggle God Mode',									value = 'menuperso_modo_godmode'})
				table.insert(elements, {label = 'Give Dirty Money',						value = 'menuperso_modo_give_moneydirty'})
				table.insert(elements, {label = 'Toggle invisibility',								value = 'menuperso_modo_mode_fantome'})
				table.insert(elements, {label = 'Repair your Vehicle',							value = 'menuperso_modo_vehicle_repair'})
				table.insert(elements, {label = 'TP to Waypoint',							value = 'menuperso_modo_tp_marcker'})
				table.insert(elements, {label = 'Access Reports',						value = 'menuperso_reports'})
			end

			if data.current.value == 'menuperso_modo' then
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_modo', {
					title	= 'Administration Tools',
					align	= 'bottom-right',
					elements = elements
				}, function(data2, menu2)
					if data2.current.value == 'deleteGun' then
						toggleDeleteGun()
					elseif data2.current.value == 'menuperso_modo_tp_toplayer' then
						admin_tp_toplayer()
					elseif data2.current.value == 'menuperso_modo_tp_playertome' then
						admin_tp_playertome()
					elseif data2.current.value == 'menuperso_modo_tp_pos' then
						admin_tp_pos()
					elseif data2.current.value == 'menuperso_modo_no_clip' then
						admin_no_clip()
					elseif data2.current.value == 'menuperso_modo_godmode' then
						admin_godmode()
					elseif data2.current.value == 'menuperso_modo_mode_fantome' then
						admin_mode_fantome()
					elseif data2.current.value == 'menuperso_modo_vehicle_repair' then
						admin_vehicle_repair()
					elseif data2.current.value == 'menuperso_modo_vehicle_spawn' then
						admin_vehicle_spawn()
					elseif data2.current.value == 'menuperso_modo_vehicle_flip' then
						admin_vehicle_flip()
					elseif data2.current.value == 'menuperso_modo_give_money' then
						admin_give_money()
					elseif data2.current.value == 'menuperso_modo_give_moneybank' then
						admin_give_bank()
					elseif data2.current.value == 'menuperso_modo_give_moneydirty' then
						admin_give_dirty()
					elseif data2.current.value == 'menuperso_modo_showname' then
						modo_showname()
					elseif data2.current.value == 'menuperso_modo_tp_marcker' then
						admin_tp_marcker()
					elseif data2.current.value == 'menuperso_modo_heal_player' then
						admin_heal_player()
					elseif data2.current.value == 'menuperso_modo_spec_player' then
						admin_spec_player()
					elseif data2.current.value == 'menuperso_reports' then
						TriggerEvent('adrp_reportsystem:openReports')
					elseif data2.current.value == 'menuperso_modo_changer_skin' then
						changer_skin()
					end
				end, function(data2, menu2)
					menu2.close()
				end)
			elseif data.current.value == 'menuperso_vehicule' then
				OpenVehiculeMenu()
			elseif data.current.value == 'train' then
				TriggerServerEvent('RequestTrain')
			elseif data.current.value == 'menuperso_moi' then
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_moi', {
					title    = 'Personal',
					align    = 'bottom-right',
					elements = {
						{label = 'Inventory', value = 'inventory'},
						{label = 'Keychains', value = 'keychain'},
						{label = 'My Bills', value = 'bills'},
						{label = 'Show ID to player', value = 'showID'},
						{label = 'View ID', value = 'viewID'},
						{label = 'Manage Pet', value = 'pet'},
						{label = 'Share Phone Number', value = 'phone'},
						{label = 'Sync Player Data', value = 'sync_player'}
				}}, function(data2, menu2)
					if data2.current.value == 'showID' then
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

						if closestPlayer ~= -1 and closestDistance < 3.0 then
							TriggerServerEvent('gc:openIdentity', GetPlayerServerId(closestPlayer))
						else
							ESX.ShowNotification('There\'s no player(s) nearby you!')
						end
					elseif data2.current.value == 'keychain' then
						TriggerEvent('esx_adrp_vehicle:openKeyChainMenu')
					elseif data2.current.value == 'viewID' then
						TriggerEvent('gcl:openMeIdentity')
					elseif data2.current.value == 'inventory' then
						openInventaire()
					elseif data2.current.value == 'bills' then
						TriggerEvent('esx_billing:openMenu')
					elseif data2.current.value == 'sync_player' then
						if canSync then
							canSync = false
							TriggerServerEvent('adrp_characterspawn:saveCharacterData')
							ESX.ShowNotification('You have synced your character in the server hive!')
							startSyncCooldown()
						else
							ESX.ShowNotification('You have recently synced your player data. There is an cooldown of 15 minutes for syncing to the hive.')
						end
					elseif data2.current.value == 'phone' then
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

						if closestPlayer ~= -1 and closestDistance < 3.0 then
							TriggerServerEvent('esx_rpchat:sharePhoneNumber')
						else
							ESX.ShowNotification('There\'s no player(s) nearby you that are intrested in your phone number!')
						end
					elseif data2.current.value == 'pet' then
						ESX.TriggerServerCallback('eden_animal:getPet', function(pet)
							if pet and pet ~= '' then
								TriggerEvent('esx_pets:openPetMenu')
							else
								ESX.ShowNotification('You dont own a pet!')
							end
						end)
					end
				end, function(data2, menu2)
					menu2.close()
				end)
			elseif data.current.value == 'menuperso_actions' then
				TriggerEvent('adrp:openAnimationMenu')
			elseif data.current.value == 'menuperso_report' then
				TriggerEvent('adrp_reportsystem:report')
			elseif data.current.value == 'menuperso_gang' then
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_gang', {
					title    = 'Gang Interactions',
					align    = 'bottom-right',
					elements = {
						{label = 'Gang Interactions', value = 'menuperso_citizen'},
						{label = 'Recruit', value = 'menuperso_gang_recruter'},
						{label = 'Fire', value = 'menuperso_gang_virer'},
						{label = 'Promote', value = 'menuperso_gang_promouvoir'},
						{label = 'Demote', value = 'menuperso_gang_destituer'}
				}}, function(data2, menu2)
					if data2.current.value == 'menuperso_citizen' then
						local gangName = PlayerData.gang.name
						OpenActionsMenu(gangName)
					elseif data2.current.value == 'menuperso_gang_recruter' then
						if PlayerData.gang.grade_name == 'boss' then
							local gang =  PlayerData.gang.name
							local grade = 0
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

							if closestPlayer == -1 or closestDistance > 3.0 then
								ESX.ShowNotification('No players nearby')
							else
								TriggerServerEvent('NB:recruitplayer', GetPlayerServerId(closestPlayer), gang, grade)
							end
						else
							Notify('You do not have the ~r~rights~s~.')
						end
					elseif data2.current.value == 'menuperso_gang_virer' then
						if PlayerData.gang.grade_name == 'boss' then
							local gang =  PlayerData.gang.name
							local grade = 0
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

							if closestPlayer == -1 or closestDistance > 3.0 then
								ESX.ShowNotification('No players nearby')
							else
								TriggerServerEvent('NB:fireplayer', GetPlayerServerId(closestPlayer))
							end
						else
							Notify('You do not have the ~r~rights~s~.')
						end
					elseif data2.current.value == 'menuperso_gang_promouvoir' then
						if PlayerData.gang.grade_name == 'boss' then
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

							if closestPlayer == -1 or closestDistance > 3.0 then
								ESX.ShowNotification('No players nearby')
							else
								TriggerServerEvent('NB:promoteplayer', GetPlayerServerId(closestPlayer))
							end
						else
							Notify('You do not have the ~r~rights~s~.')
						end
					elseif data2.current.value == 'menuperso_gang_destituer' then
						if PlayerData.job.grade_name == 'boss' then
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

							if closestPlayer == -1 or closestDistance > 3.0 then
								ESX.ShowNotification('No players nearby')
							else
								TriggerServerEvent('NB:demoteplayer', GetPlayerServerId(closestPlayer))
							end
						else
							Notify('You do not have the ~r~rights~s~.')
						end
					end
				end, function(data2, menu2)
					menu2.close()
				end)
			elseif data.current.value == 'menuperso_grade' then
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_grade', {
					title	= 'Business Management',
					align	= 'bottom-right',
					elements = {
						{label = 'Recruit', value = 'menuperso_grade_recruter'},
						{label = 'Fire', value = 'menuperso_grade_virer'},
						{label = 'Promote', value = 'menuperso_grade_promouvoir'},
						{label = 'Demote', value = 'menuperso_grade_destituer'}
				}}, function(data2, menu2)
					if data2.current.value == 'menuperso_grade_recruter' then
						if PlayerData.job.grade_name == 'boss' then
							local job =  PlayerData.job.name
							local grade = 0
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

							if closestPlayer == -1 or closestDistance > 3.0 then
								ESX.ShowNotification('No players nearby')
							else
								TriggerServerEvent('NB:recruterplayer', GetPlayerServerId(closestPlayer), job,grade)
							end
						else
							Notify('You do not have the ~r~rights~s~.')
						end
					elseif data2.current.value == 'menuperso_grade_virer' then
						if PlayerData.job.grade_name == 'boss' then
							local job =  PlayerData.job.name
							local grade = 0
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

							if closestPlayer == -1 or closestDistance > 3.0 then
								ESX.ShowNotification('No players nearby')
							else
								TriggerServerEvent('NB:virerplayer', GetPlayerServerId(closestPlayer))
							end
						else
							Notify('You do not have the ~r~rights~s~.')
						end
					elseif data2.current.value == 'menuperso_grade_promouvoir' then
						if PlayerData.job.grade_name == 'boss' then
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

							if closestPlayer == -1 or closestDistance > 3.0 then
								ESX.ShowNotification('No players nearby')
							else
								TriggerServerEvent('NB:promouvoirplayer', GetPlayerServerId(closestPlayer))
							end
						else
							Notify('You do not have the ~r~rights~s~.')
						end
					elseif data2.current.value == 'menuperso_grade_destituer' then
						if PlayerData.job.grade_name == 'boss' then
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

							if closestPlayer == -1 or closestDistance > 3.0 then
								ESX.ShowNotification('No players nearby')
							else
								TriggerServerEvent('NB:destituerplayer', GetPlayerServerId(closestPlayer))
							end
						else
							Notify('You do not have the ~r~rights~s~.')
						end
					end
				end, function(data2, menu2)
					menu2.close()
				end)
			end
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenVehiculeMenu()
	ESX.UI.Menu.CloseAll()
	local elements = {}

	if vehiculeON then
		table.insert(elements, {label = 'Engine Off',			value = 'menuperso_vehicule_MoteurOff'})
	else
		table.insert(elements, {label = 'Engine On',		value = 'menuperso_vehicule_MoteurOn'})
	end

	if porteAvantGaucheOuverte then
		table.insert(elements, {label = 'Close left door',	value = 'menuperso_vehicule_fermerportes_fermerportegauche'})
	else
		table.insert(elements, {label = 'Open left door',		value = 'menuperso_vehicule_ouvrirportes_ouvrirportegauche'})
	end

	if porteAvantDroiteOuverte then
		table.insert(elements, {label = 'Close right door',	value = 'menuperso_vehicule_fermerportes_fermerportedroite'})
	else
		table.insert(elements, {label = 'Open right door',		value = 'menuperso_vehicule_ouvrirportes_ouvrirportedroite'})
	end

	if porteArriereGaucheOuverte then
		table.insert(elements, {label = 'Close the left rear doorClose the left rear door',	value = 'menuperso_vehicule_fermerportes_fermerportearrieregauche'})
	else
		table.insert(elements, {label = 'Open the left rear door',		value = 'menuperso_vehicule_ouvrirportes_ouvrirportearrieregauche'})
	end

	if porteArriereDroiteOuverte then
		table.insert(elements, {label = 'Close the right rear door',	value = 'menuperso_vehicule_fermerportes_fermerportearrieredroite'})
	else
		table.insert(elements, {label = 'Open the right rear door',		value = 'menuperso_vehicule_ouvrirportes_ouvrirportearrieredroite'})
	end

	if porteCapotOuvert then
		table.insert(elements, {label = 'Close the hood',	value = 'menuperso_vehicule_fermerportes_fermercapot'})
	else
		table.insert(elements, {label = 'Open the hood',		value = 'menuperso_vehicule_ouvrirportes_ouvrircapot'})
	end

	if porteCoffreOuvert then
		table.insert(elements, {label = 'Close the trunk',	value = 'menuperso_vehicule_fermerportes_fermercoffre'})
	else
		table.insert(elements, {label = 'Open the trunk',		value = 'menuperso_vehicule_ouvrirportes_ouvrircoffre'})
	end

	if porteToutOuvert then
		table.insert(elements, {label = 'Close everything',	value = 'menuperso_vehicule_fermerportes_fermerTout'})
	else
		table.insert(elements, {label = 'Open everything',		value = 'menuperso_vehicule_ouvrirportes_ouvrirTout'})
	end


	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_vehicule', {
		title    = 'Vehicle Interaction',
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		if data.current.value == 'menuperso_vehicule_MoteurOn' then
			vehiculeON = true
			SetVehicleEngineOn(vehicle, true, false, true)
			SetVehicleUndriveable(vehicle, false)
			OpenVehiculeMenu()
		elseif data.current.value == 'menuperso_vehicule_MoteurOff' then
			vehiculeON = false
			SetVehicleEngineOn(vehicle, false, false, true)
			SetVehicleUndriveable(vehicle, true)
			OpenVehiculeMenu()
		elseif data.current.value == 'menuperso_vehicule_togglelock' then
			OpenCloseVehicle()
		elseif data.current.value == 'menuperso_vehicule_ouvrirportes_ouvrirportegauche' then
			porteAvantGaucheOuverte = true
			SetVehicleDoorOpen(vehicle, 0, false, false)
			OpenVehiculeMenu()
		elseif data.current.value == 'menuperso_vehicule_ouvrirportes_ouvrirportedroite' then
			porteAvantDroiteOuverte = true
			SetVehicleDoorOpen(vehicle, 1, false, false)
			OpenVehiculeMenu()
		elseif data.current.value == 'menuperso_vehicule_ouvrirportes_ouvrirportearrieregauche' then
			porteArriereGaucheOuverte = true
			SetVehicleDoorOpen(vehicle, 2, false, false)
			OpenVehiculeMenu()
		elseif data.current.value == 'menuperso_vehicule_ouvrirportes_ouvrirportearrieredroite' then
			porteArriereDroiteOuverte = true
			SetVehicleDoorOpen(vehicle, 3, false, false)
			OpenVehiculeMenu()
		elseif data.current.value == 'menuperso_vehicule_ouvrirportes_ouvrircapot' then
			porteCapotOuvert = true
			SetVehicleDoorOpen(vehicle, 4, false, false)
			OpenVehiculeMenu()
		elseif data.current.value == 'menuperso_vehicule_ouvrirportes_ouvrircoffre' then
			porteCoffreOuvert = true
			SetVehicleDoorOpen(vehicle, 5, false, false)
			OpenVehiculeMenu()
		elseif data.current.value == 'menuperso_vehicule_ouvrirportes_ouvrirAutre1' then
			porteAutre1Ouvert = true
			SetVehicleDoorOpen(vehicle, 6, false, false)
			OpenVehiculeMenu()
		elseif data.current.value == 'menuperso_vehicule_ouvrirportes_ouvrirAutre2' then
			porteAutre2Ouvert = true
			SetVehicleDoorOpen(vehicle, 7, false, false)
			OpenVehiculeMenu()
		elseif data.current.value == 'menuperso_vehicule_ouvrirportes_ouvrirTout' then
			porteAvantGaucheOuverte = true
			porteAvantDroiteOuverte = true
			porteArriereGaucheOuverte = true
			porteArriereDroiteOuverte = true
			porteCapotOuvert = true
			porteCoffreOuvert = true
			porteAutre1Ouvert = true
			porteAutre2Ouvert = true
			porteToutOuvert = true
			SetVehicleDoorOpen(vehicle, 0, false, false)
			SetVehicleDoorOpen(vehicle, 1, false, false)
			SetVehicleDoorOpen(vehicle, 2, false, false)
			SetVehicleDoorOpen(vehicle, 3, false, false)
			SetVehicleDoorOpen(vehicle, 4, false, false)
			SetVehicleDoorOpen(vehicle, 5, false, false)
			SetVehicleDoorOpen(vehicle, 6, false, false)
			SetVehicleDoorOpen(vehicle, 7, false, false)
			OpenVehiculeMenu()
		elseif data.current.value == 'menuperso_vehicule_fermerportes_fermerportegauche' then
			porteAvantGaucheOuverte = false
			SetVehicleDoorShut(vehicle, 0, false, false)
			OpenVehiculeMenu()
		elseif data.current.value == 'menuperso_vehicule_fermerportes_fermerportedroite' then
			porteAvantDroiteOuverte = false
			SetVehicleDoorShut(vehicle, 1, false, false)
			OpenVehiculeMenu()
		elseif data.current.value == 'menuperso_vehicule_fermerportes_fermerportearrieregauche' then
			porteArriereGaucheOuverte = false
			SetVehicleDoorShut(vehicle, 2, false, false)
			OpenVehiculeMenu()
		elseif data.current.value == 'menuperso_vehicule_fermerportes_fermerportearrieredroite' then
			porteArriereDroiteOuverte = false
			SetVehicleDoorShut(vehicle, 3, false, false)
			OpenVehiculeMenu()
		elseif data.current.value == 'menuperso_vehicule_fermerportes_fermercapot' then
			porteCapotOuvert = false
			SetVehicleDoorShut(vehicle, 4, false, false)
			OpenVehiculeMenu()
		elseif data.current.value == 'menuperso_vehicule_fermerportes_fermercoffre' then
			porteCoffreOuvert = false
			SetVehicleDoorShut(vehicle, 5, false, false)
			OpenVehiculeMenu()
		elseif data.current.value == 'menuperso_vehicule_fermerportes_fermerAutre1' then
			porteAutre1Ouvert = false
			SetVehicleDoorShut(vehicle, 6, false, false)
			OpenVehiculeMenu()
		elseif data.current.value == 'menuperso_vehicule_fermerportes_fermerAutre2' then
			porteAutre2Ouvert = false
			SetVehicleDoorShut(vehicle, 7, false, false)
			OpenVehiculeMenu()
		elseif data.current.value == 'menuperso_vehicule_fermerportes_fermerTout' then
			porteAvantGaucheOuverte = false
			porteAvantDroiteOuverte = false
			porteArriereGaucheOuverte = false
			porteArriereDroiteOuverte = false
			porteCapotOuvert = false
			porteCoffreOuvert = false
			porteAutre1Ouvert = false
			porteAutre2Ouvert = false
			porteToutOuvert = false
			SetVehicleDoorShut(vehicle, 0, false, false)
			SetVehicleDoorShut(vehicle, 1, false, false)
			SetVehicleDoorShut(vehicle, 2, false, false)
			SetVehicleDoorShut(vehicle, 3, false, false)
			SetVehicleDoorShut(vehicle, 4, false, false)
			SetVehicleDoorShut(vehicle, 5, false, false)
			SetVehicleDoorShut(vehicle, 6, false, false)
			SetVehicleDoorShut(vehicle, 7, false, false)
			OpenVehiculeMenu()
		end
	end, function(data, menu)
		menu.close()
	end)
end

function admin_godmode()
	godmode = not godmode
	local ped = PlayerPedId()

	if godmode then -- activé
		SetEntityInvincible(ped, true)
		Notify('God mode ~g~enabled')
	else
		SetEntityInvincible(ped, false)
		Notify('God mode ~r~disabled')
	end
end
-- FIN GOD MODE

-- INVISIBLE
function admin_mode_fantome()
	invisible = not invisible
	local ped = PlayerPedId()

	if invisible then -- activé
		SetEntityVisible(ped, false)
		Notify('Invisible: ~g~Enabled')
	else
		SetEntityVisible(ped, true)
		Notify('Invisible: ~r~Disabled')
	end
end
-- FIN INVISIBLE

-- Réparer vehicule
function admin_vehicle_repair()
	local ped = PlayerPedId()
	local car = GetVehiclePedIsUsing(ped)

	SetVehicleFixed(car)
	SetVehicleDirtLevel(car, 0.0)
end

-- Spawn vehicule
function admin_vehicle_spawn()
	DisplayOnscreenKeyboard(true, 'FMMC_KEY_TIP8', '', '', '', '', '', 120)
	Notify('~b~Enter name of the vehicle')
	inputvehicle = 1
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if inputvehicle == 1 then
			if UpdateOnscreenKeyboard() == 3 then
				inputvehicle = 0
			elseif UpdateOnscreenKeyboard() == 1 then
					inputvehicle = 2
			elseif UpdateOnscreenKeyboard() == 2 then
				inputvehicle = 0
			end
		elseif inputvehicle == 2 then
			local vehicleName = GetOnscreenKeyboardResult()
			local vehicleHash = GetHashKey(vehicleName)

			Citizen.CreateThread(function()
				Citizen.Wait(10)

				RequestModel(vehicleHash)

				while not HasModelLoaded(vehicleHash) do
					Citizen.Wait(0)
				end

				local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(),true))
				veh = CreateVehicle(vehicleHash, x,y,z, 0.0, true, false)
				SetEntityVelocity(veh, 2000)
				SetVehicleOnGroundProperly(veh)
				SetVehicleHasBeenOwnedByPlayer(veh,true)

				local id = NetworkGetNetworkIdFromEntity(veh)
				SetNetworkIdCanMigrate(id, true)
				SetVehRadioStation(veh, 'OFF')
				SetPedIntoVehicle(PlayerPedId(),  veh,  -1)

				Notify('Vehicle Spawned')
			end)

			inputvehicle = 0
		else
			Citizen.Wait(500)
		end
	end
end)

function admin_give_dirty()
	DisplayOnscreenKeyboard(true, 'FMMC_KEY_TIP8', '', '', '', '', '', 120)
	TriggerEvent('customNotification', 'Enter how much you would like to give')
	inputmoneydirty = 1
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if inputmoneydirty == 1 then

			if UpdateOnscreenKeyboard() == 3 then
				inputmoneydirty = 0
			elseif UpdateOnscreenKeyboard() == 1 then
				inputmoneydirty = 2
			elseif UpdateOnscreenKeyboard() == 2 then
				inputmoneydirty = 0
			end

		elseif inputmoneydirty == 2 then

			local rMoney = GetOnscreenKeyboardResult()
			local money = tonumber(rMoney)
			TriggerServerEvent('AdminMenu:giveDirtyMoney', money)
			inputmoneydirty = 0

		else
			Citizen.Wait(500)
		end
	end
end)

-- Afficher Nom
function modo_showname()
	if showname then
		showname = false
	else
		Notify('Open / Close the pause menu to display the names')
		showname = true
	end
end

-- TP MARCKER
function admin_tp_marcker()
	local blip = GetFirstBlipInfoId(8)
	local authorized

	ESX.TriggerServerCallback('NB:getUsergroup', function(group)
		if group == 'admin' or group == 'superadmin' or group == 'owner' or group == 'mod' then
			authorized = true
		else
			authorized = false
		end
	end)

	while authorized == nil do
		Citizen.Wait(200)
	end

	if not authorized then
		return
	end

	if DoesBlipExist(blip) then
		local playerPed = PlayerPedId()
		local teleportEntity = playerPed

		if IsPedInAnyVehicle(playerPed, false) and GetPedInVehicleSeat(GetVehiclePedIsIn(playerPed, false), -1) == playerPed then
			teleportEntity = GetVehiclePedIsIn(playerPed, false)
		end

		NetworkFadeOutEntity(teleportEntity, true, false)

		local coord = GetBlipInfoIdCoord(blip)
		local groundFound, coordZ = false, 0
		local groundCheckHeights = {0.0, 50.0, 100.0, 150.0, 200.0, 250.0, 300.0, 350.0, 400.0,450.0, 500.0, 550.0, 600.0, 650.0, 700.0, 750.0, 800.0}

		for _,height in ipairs(groundCheckHeights) do
			ESX.Game.Teleport(teleportEntity, {x = coord.x, y = coord.y, z = height})

			local foundGround, z = GetGroundZFor_3dCoord(coord.x, coord.y, height)

			if foundGround then
				coordZ = z + 3.01
				groundFound = true
				break
			end
		end

		if groundFound then
			ESX.Game.Teleport(teleportEntity, {x = coord.x, y = coord.y, z = coordZ})

			NetworkFadeInEntity(teleportEntity, true)
		else
			Notify('Could not found ground coord axis. You\'ve been teleported to the nearest road.')
			local retval, outPosition = GetNthClosestVehicleNode(coord.x, coord.y, coordZ, 0, 0, 0, 0)

			ESX.Game.Teleport(teleportEntity, {x = outPosition.x, y = outPosition.y, z = outPosition.z})
			NetworkFadeInEntity(teleportEntity, true)
		end
	else
		Notify('No waypoint has been set!')
	end
end

---------------------------------------------------------------------------Me concernant

function openInventaire()
	TriggerEvent('NB:closeAllMenu')
	TriggerEvent('NB:closeMenuKey')

	TriggerEvent('NB:openMenuInventory')
end

---------------------------------------------------------------------------Actions

function animPlayer(animDict, animName)
	local playerPed = PlayerPedId()

	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do
		Citizen.Wait(100)
	end

	if IsEntityPlayingAnim(playerPed, animDict, animName, 3) then
		ClearPedTasks(playerPed)
	else
		ClearPedTasks(playerPed)
		TaskPlayAnim(playerPed, animDict, animName, 4.0, -4.0, -1, 1, 0.0, false, false, false)
	end
end

function halfanimPlayer(animDict, animName)
	local playerPed = PlayerPedId()

	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do
		Citizen.Wait(100)
	end

	if IsEntityPlayingAnim(playerPed, animDict, animName, 3) then
		ClearPedTasks(playerPed)
	else
		ClearPedTasks(playerPed)
		TaskPlayAnim(playerPed, animDict, animName, 4.0, -4.0, -1, 49, 0.0, false, false, false)
	end
end

local playAnim = false
local dataAnim = {}

function animsAction(animObj)
	if IsInVehicle() then
		local source = GetPlayerServerId()
		ESX.ShowNotification('Get out from the vehicle first!')
	else
		Citizen.CreateThread(function()
			if not playAnim then
				local playerPed = PlayerPedId()
				if DoesEntityExist(playerPed) then -- Ckeck if ped exist
					dataAnim = animObj

					-- Play Animation
					RequestAnimDict(dataAnim.lib)
					while not HasAnimDictLoaded(dataAnim.lib) do
						Citizen.Wait(0)
					end
					if HasAnimDictLoaded(dataAnim.lib) then
						local flag = 0
						if dataAnim.loop ~= nil and dataAnim.loop then
							flag = 1
						elseif dataAnim.move ~= nil and dataAnim.move then
							flag = 49
						end

						TaskPlayAnim(playerPed, dataAnim.lib, dataAnim.anim, 8.0, -8.0, -1, flag, 0.0, false, false, false)
						playAnimation = true
					end

					-- Wait end annimation
					while true do
						Citizen.Wait(100)
						if not IsEntityPlayingAnim(playerPed, dataAnim.lib, dataAnim.anim, 3) then
							playAnim = false
							break
						end
					end
				end -- end ped exist
			end
		end)
	end
end


function animsActionScenario(animObj)
	if (IsInVehicle()) then
		local source = GetPlayerServerId()
		ESX.ShowNotification('Get out of your vehicle to do that !')
	else
		Citizen.CreateThread(function()
			if not playAnim then
				local playerPed = PlayerPedId()
				if DoesEntityExist(playerPed) then
					dataAnim = animObj
					TaskStartScenarioInPlace(playerPed, dataAnim.anim, 0, false)
					playAnimation = true
				end
			end
		end)
	end
end

-- Verifie si le joueurs est dans un vehicule ou pas
function IsInVehicle()
	local ply = PlayerPedId()
	if IsPedSittingInAnyVehicle(ply) then
		return true
	else
		return false
	end
end

function changer_skin()
	TriggerEvent('esx_skin:openSaveableMenu', source)
end

function save_skin()
	TriggerEvent('esx_skin:requestSaveSkin', source)
end

---------------------------------------------------------------------------------------------------------
--NB : gestion des menu
---------------------------------------------------------------------------------------------------------

RegisterNetEvent('NB:goTpMarcker')
AddEventHandler('NB:goTpMarcker', function()
	admin_tp_marcker()
end)

RegisterNetEvent('NB:openMenuPersonnel')
AddEventHandler('NB:openMenuPersonnel', function()
	OpenPersonnelMenu()
end)

function OpenActionsMenu(gangName)
	local elements = {{ label = 'Citizen Interactions', value = 'citizen_interaction' }}

	if PlayerData.gang.name == 'lostmotors' then
		table.insert(elements, { label = 'Attach to Trailer', value = 'towcar'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu_actions', {
		title    = gangName,
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'towcar' then
			TriggerEvent('towLost')
		elseif data.current.value == 'citizen_interaction' then
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
				title = 'Citizen Interactions',
				align = 'bottom-right',
				elements = {
					{label = 'Put in vehicle',  value = 'put_in_vehicle'},
					{label = 'Take out of vehicle', value = 'out_the_vehicle'}
			}}, function(data2, menu2)
				local player, distance = ESX.Game.GetClosestPlayer()

				if distance and distance <= 3 then
					if data2.current.value == 'put_in_vehicle' then
						TriggerServerEvent('esx_gang:putInVehicle', GetPlayerServerId(player))
					elseif data2.current.value == 'out_the_vehicle' then
						TriggerServerEvent('esx_gang:outVehicle', GetPlayerServerId(player))
					end
				else
					ESX.ShowNotification(_U('no_players_nearby'))
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function walker(walker)
	if not HasAnimSetLoaded(walker) then
		RequestAnimSet(walker)
		while not HasAnimSetLoaded(walker) do
			Citizen.Wait(0)
		end
	end

	local ped = PlayerPedId()
	SetPedMovementClipset(ped,walker,1)
end

function resetWalk()
	local ped = PlayerPedId()
	ResetPedMovementClipset(ped, 0)
end

function toggleDeleteGun()
	if deleteGunActive == false then
		TriggerEvent('customNotification', 'Delete gun enabled')
		deleteGunActive = true
	else
		TriggerEvent('customNotification', 'Delete gun disabled')
		deleteGunActive = false
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if deleteGunActive then
			local playerId = PlayerId()
			local playerPed = GetPlayerPed(playerId)

			if IsPlayerFreeAiming(playerId) then

				if IsPedShooting(playerPed) then
					local found, entity = getTargettedEntity(playerId)
					if found then
						NetworkRegisterEntityAsNetworked(entity)
						Citizen.Wait(100)

						NetworkRequestControlOfEntity(entity)

						if not IsEntityAMissionEntity(entity) then
							SetEntityAsMissionEntity(entity)
						end

						Citizen.Wait(100)
						DeleteEntity(entity)
					end
				end
			end
		else
			Citizen.Wait(500)
		end
	end
end)

function getTargettedEntity(playerId)
	local found, entity = GetEntityPlayerIsFreeAimingAt(playerId)

	return found, entity
end