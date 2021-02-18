local timeout = 0
-- keybinds
local keybindJobMenu = 19
local keybindPersonalMenu = 311


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		while not PlayerData.job do
			Citizen.Wait(500)
		end

		if IsControlPressed(0, 21) and IsControlPressed(0, 324) then
			if (GetGameTimer() - timeout > 150) and IsInputDisabled(0) then
				ESX.UI.Menu.CloseAll()
				TriggerEvent('NB:goTpMarcker')
				timeout = GetGameTimer()
			end
		end

		if IsControlJustReleased(0, keybindPersonalMenu) then
			if IsInputDisabled(0) then
				ESX.UI.Menu.CloseAll()
				TriggerEvent('NB:openMenuPersonnel')
			end
		end

		if IsControlJustReleased(0, keybindJobMenu) then
			if IsInputDisabled(0) then
				local job = PlayerData.job.name

				if job == 'taxi' then
					TriggerEvent('esx_taxijob:openJobMenu')
				elseif (job == 'police' or job == 'sheriff' or job == 'state' or job == 'usmarshal' or job == 'dod' or job == 'fib' or job == 'securoserv') then
					TriggerEvent('esx_policejob:openJobMenu')
				elseif job == 'ambulance' then
					TriggerEvent('esx_ambulancejob:openJobMenu')
				elseif job == 'mecano' then
					TriggerEvent('esx_mechanicjob:openJobMenu')
				elseif job == 'heli' then
					TriggerEvent('esx_heli:openJobMenu')
				elseif job == 'unicorn' then
					TriggerEvent('esx_unicornjob:openJobMenu')
				end
			end
		end
	end
end)

RegisterNetEvent('NB:closeAllMenu')
AddEventHandler('NB:closeAllMenu', function()
	ESX.UI.Menu.CloseAll()
end)