local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil
Job = nil
Walkie = false
Hz = nil
local talking = false
local talker = nil


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	NetworkClearVoiceChannel()
	RequestAnimDict( "random@arrests" )
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	Job = job
end)




--Main Loop
Citizen.CreateThread(function()
	while true do 
		Citizen.Wait(0)
		if Job ~= nil then
		if Job.name == "police" or Job.name == "sheriff" or Job.name == "state" or Job.name == "ambulance" or Job.name == "mecano" then
			if Walkie then
				if Job.name == "police" or Job.name == "sheriff" or Job.name == "state" or Job.name == "ambulance" then
					if IsControlJustPressed(0, Keys['F10']) then
						if Hz == 75 then
							Hz = 50
						elseif Hz == 50 then
							Hz = 25
						elseif Hz == 25 then
							Hz = 75
						end
						TriggerServerEvent('walkie:setChannel', Hz)
						SendNUIMessage({action = "setChannel", channel = Hz})
					end
				end

				if IsControlJustPressed(0, Keys['BACKSPACE']) then
					SendNUIMessage({action = "close"})
					TriggerServerEvent('walkie:setOff')
					Hz = nil
					NetworkClearVoiceChannel()
					Walkie = false
				end


				if talking then
					--if NetworkIsPlayerTalking(PlayerId()) == false then
					if IsControlPressed(0, 249) == false then
						if talker == GetPlayerServerId(PlayerId()) then
							TriggerServerEvent('walkie:playSoundOnChannel', Hz, "off")
							ClearPedTasks(PlayerPedId())
							talking = false
							TriggerServerEvent('walkie:setNotTalking', Hz)
						end
					end
				else
					--if NetworkIsPlayerTalking(PlayerId()) then
					if IsControlPressed(0, 249) then
						if talker == nil then
							ESX.TriggerServerCallback('walkie:setTalking', function(canBe)
								if canBe then
									TriggerServerEvent('walkie:playSoundOnChannel', Hz, "on")
									talking = true
									TaskPlayAnim(PlayerPedId(), "random@arrests", "generic_radio_chatter", 8.0, 2.5, -1, 49, 0, 0, 0, 0 )
								end
							end, {channel = Hz})
						end
					end
				end


				if talker ~= nil and talker ~= GetPlayerServerId(PlayerId()) then
					DisableControlAction(0, 249)
				end



			else
				if IsControlJustPressed(0, Keys['=']) then
					if Job.name == "police" or Job.name == "sheriff" or Job.name == "state" then
						Hz = 75
					elseif Job.name == "ambulance" then
						Hz = 50
					elseif Job.name == "mecano" then
						Hz = 25
					end
					TriggerServerEvent('walkie:setChannel', Hz)
					SendNUIMessage({action = "setChannel", channel = Hz})
					SendNUIMessage({action = "open"})
					Walkie = true
				end
			end




		end
		end
	end

end)

RegisterNetEvent('walkie:setChannelTalker')
AddEventHandler('walkie:setChannelTalker', function(id)
	NetworkSetVoiceChannel(Hz)
	talker = id
end)

RegisterNetEvent('walkie:removeChannelTalker')
AddEventHandler('walkie:removeChannelTalker', function()
	NetworkClearVoiceChannel()
	talker = nil
end)


RegisterNetEvent('walkie:playSound')
AddEventHandler('walkie:playSound', function(s)
	SendNUIMessage({action = "playSound", sound = s})
end)




function requestChannel()
	local hz = openTextInput("Enter Frequency", "", 3)
	hz = tonumber(hz)
	return hz
end


function openTextInput(title, defaultText, maxlength)
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", defaultText or "", "", "", "", maxlength or 180)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
        return GetOnscreenKeyboardResult()
    end
    return nil
end