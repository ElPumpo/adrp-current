Keys = {
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


local vaultDoor = GetClosestObjectOfType(-2956.604, 481.441, 14.697, 25.0, GetHashKey('hei_prop_heist_sec_door'), 0, 0, 0)
local depositBox = GetClosestObjectOfType(-2952.941, 484.627, 15.675, 10.0, GetHashKey("hei_prop_heist_safedepdoor"), 0, 0 ,0)


print(depositBox)
local model = GetHashKey("hei_prop_heist_drill")

SetEntityHeading(depositBox, 180.0)



Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlJustPressed(0, Keys["G"]) then
			TriggerEvent("drill:start")
		end
	end
end)



local Drilling = true
local DrillSpeed = 0.0
local DrillPosition = 0.0
local DrillDepth = 0.1
local DrillTemperature = 0.0
local pin_one = false
local pin_two = false
local pin_three = false
local pin_four = false
local Reset = false
local CamMode = 1

local sound = GetSoundId()
local PinSound = GetSoundId()
local FailSound = GetSoundId()



RegisterNetEvent("drill:start") 
AddEventHandler("drill:start", function()
	local ped = PlayerPedId()
	GiveWeaponToPed(ped, GetHashKey("WEAPON_UNARMED"), 0, true, true)
	SetPedCanSwitchWeapon(ped, false)

	scaleform = RequestScaleformMovieInstance("DRILLING")

	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(0)
	end
	print("loaded Movie")

	RequestNamedPtfxAsset("fm_mission_controler")
	RequestAnimDict("anim@heists@fleeca_bank@drilling")
	RequestModel(model)

	while not HasAnimDictLoaded("anim@heists@fleeca_bank@drilling") do
		Citizen.Wait(0)
	end

	while not HasNamedPtfxAssetLoaded("fm_mission_controler") do
		Citizen.Wait(0)
	end

	print("ptfx loaded")

	while not HasNamedPtfxAssetLoaded("fm_mission_controler") do
		Citizen.Wait(0)
	end

	while not HasModelLoaded(model) do
		Citizen.Wait(0)
	end

	print("All loaded")

	RequestAmbientAudioBank("HEIST_FLEECA_DRILL", 0, -1) 
	RequestAmbientAudioBank("HEIST_FLEECA_DRILL_2", 0, -1) 
	RequestAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL", 0, -1) 
	RequestAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL_2", 0, -1) 
	RequestAmbientAudioBank("SAFE_CRACK", 0, -1) 
	RequestAmbientAudioBank("DLC_Biker_Cracked_Sounds", 0, -1) 
	RequestAmbientAudioBank("HUD_MINI_GAME_SOUNDSET", 0, -1) 
	RequestAmbientAudioBank("MissionFailedSounds", 0, -1) 
	RequestAmbientAudioBank("dlc_heist_fleeca_bank_door_sounds", 0, -1) 
	RequestAmbientAudioBank("vault_door", 0, -1) 
	RequestScriptAudioBank("Alarms", 0, -1) 
	RequestAmbientAudioBank("DLC_HEIST_FLEECA_SOUNDSET", 0, -1)
	local propdrill = CreateObject(model, GetEntityCoords(ped), true, true, true)
	--FreezeEntityPosition(drill, true)
	SetEntityCollision(propdrill, false, true)
	AttachEntityToEntity(propdrill, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 2, 1)
	SetEntityInvincible(propdrill, true)
	SetModelAsNoLongerNeeded(model)

	TaskPlayAnim(PlayerPedId(), "anim@heists@fleeca_bank@drilling", "drill_right_end", 1.0, 0.1, 2000, 0, 0.0, 1, 1, 1)
	Citizen.CreateThread(function()
		local scaleform = RequestScaleformMovieInstance("DRILLING")

		while not HasScaleformMovieLoaded(scaleform) do
			Citizen.Wait(0)
		end
		
		while Drilling do
			Citizen.Wait(0)
			DisableControlAction(2, 37, true)
			DisableControlAction(2, 27, true)
			mouse = GetControlNormal(2, 240)
			mouse = 0.0 - mouse + 0.9
			leftStick = mouse
			if IsControlJustPressed(2, 241) then
				if DrillSpeed < 1.0 then
					DrillSpeed = DrillSpeed + 0.125
				else
					DrillSpeed = 1.0
				end
			end
			if IsControlJustPressed(2, 242) then
				if DrillSpeed > 0.0 then
					DrillSpeed = DrillSpeed - 0.125
				else
					DrillSpeed = 0.0
				end
			end
			if DrillSpeed > 0 then
				if HasSoundFinished(Sound) then
					PlaySoundFromEntity(Sound, "Drill", propdrill, "DLC_HEIST_FLEECA_SOUNDSET", 1, 0)
				end
			else
				StopSound(Sound)
			end
			if DrillSpeed == 0.0 and not IsEntityPlayingAnim(PlayerPedId(), "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 3) then
				TaskPlayAnim(PlayerPedId(), "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 6.0, 0.01, -1, 0, 0.0, 1, 1, 1)
			end

			if DrillSpeed > 0 then
				TaskPlayAnim(PlayerPedId(), "anim@heists@fleeca_bank@drilling", "drill_right_end", 3.0, 0.01, -1, 0, 0.0, 1, 1, 1)
			end

			if DrillTemperature < 1.0 then
				if DrillPosition > DrillDepth - .2 then
					if DrillSpeed > 0.2 and DrillSpeed < 0.8 then
						DrillDepth = DrillDepth + 0.0003
					end
					if DrillSpeed > 0.3 and DrillSpeed < 0.7 then
						DrillDepth = DrillDepth + 0.0003
					end
					if DrillDepth > 0.776 then
						if DrillSpeed > 0.2 and DrillSpeed < 0.7 then
							DrillDepth = DrillDepth + 0.005
						end
					end

				end
			end
			if leftStick > 0.75 and DrillSpeed > 0.0 or leftStick > 0 and DrillSpeed > 0.75 then
				if DrillPosition > DrillDepth - 0.2 then
					if DrillTemperature < 1.0 then
						DrillTemperature = DrillTemperature + 0.015
					end
				end
			end
			if DrillSpeed == 0 and DrillPosition == 0 then
				if DrillTemperature > 0.0 then
					DrillTemperature = DrillTemperature - 0.005
				end
			end
			if DrillSpeed < 0.01 then
				RemoveParticleFx(DrillFX, 0)
			end

			if leftStick > 0 then
				if DrillPosition < DrillDepth - 0.2 then
					DrillPosition = DrillPosition + 0.05
				end
				if DrillPosition < DrillDepth then
					DrillPosition = DrillPosition + 0.01
					if DrillSpeed > 0  then
						DrillFX = StartParticleFxLoopedOnEntity_2("scr_drill_debris", propdrill, 0.0, -0.55, 0.01, 90.0, 90.0, 90.0, 0.8, 0, 0, 0)
						UseParticleFxAssetNextCall("fm_mission_controler")
						RemoveParticleFx(DrillFX, 0)
						SetParticleFxLoopedEvolution(DrillFX, "power", 0.7, 0)
					else
						RemoveParticleFx(DrillFX, 0)
					end
				end
			else
				DrillPosition = 0.0
				RemoveParticleFx(DrillFX, 0)
			end

			--[do sounds here]

			SetVariableOnSound(0, "DrillState", 0.0)

			if leftStick > DrillDepth and leftStick < DrillDepth + 0.2 then
				SetVariableOnSound(0, "DrillState", 0.5)
			end

			if leftStick > DrillDepth and leftStick > DrillDepth + 0.2 then
				SetVariableOnSound(0, "DrillState", 1.0)
			end


			if DrillDepth > 0.326 and pin_one == false then
				PlaySoundFrontend(PinSound, "Drill_Pin_Break", "DLC_HEIST_FLEECA_SOUNDSET", 1)
				pin_one = true
			end

			if DrillDepth > 0.476 and pin_two == false then
				PlaySoundFrontend(PinSound, "Drill_Pin_Break", "DLC_HEIST_FLEECA_SOUNDSET", 1)
				pin_two = true
			end
			
			if DrillDepth > 0.625 and pin_three == false then
				PlaySoundFrontend(PinSound, "Drill_Pin_Break", "DLC_HEIST_FLEECA_SOUNDSET", 1)
				pin_three = true
			end

			if DrillDepth > 0.776 and pin_four == false then
				PlaySoundFrontend(PinSound, "Drill_Pin_Break", "DLC_HEIST_FLEECA_SOUNDSET", 1)
				pin_four = true
			end

			if DrillTemperature > 0.99 then
				if HasSoundFinished(Sound) then
					SetVariableOnSound(Sound, "DrillState", 0.0)
					StopSound(Sound)
				end
				if HasSoundFinished(PinSound) then
					StopSound(PinSound)
				end

				PlaySoundFromEntity(Failsound, "Drill_Jam", PlayerPedId(), "DLC_HEIST_FLEECA_SOUNDSET", 1, 20)
				RemoveParticleFx(DrillFX, 0)
				DrillPosition = 0.0
				DrillSpeed = 0.0
				DrillTemperature = 0.0
				SetScaleformMovieAsNoLongerNeeded(scaleform)
				RemoveDriller()
				DeleteObject(propdrill)
				Drilling = false
			end

			DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
			CallScaleformMovieFunctionFloatParams(scaleform, "SET_SPEED", DrillSpeed, -1082130432, -1082130432, -1082130432, -1082130432)
			--CallScaleformMovieFunctionFloatParams(scaleform, "SET_HOLE_DEPTH", DrillDepth, -1082130432, -1082130432, -1082130432, -1082130432)
			CallScaleformMovieFunctionFloatParams(scaleform, "SET_DRILL_POSITION", DrillPosition, -1082130432, -1082130432, -1082130432, -1082130432)
			CallScaleformMovieFunctionFloatParams(scaleform, "SET_TEMPERATURE", DrillTemperature, -1082130432, -1082130432, -1082130432, -1082130432)



		end
	end)
end)


function RemoveDriller()
	EnableControlAction(2, 37, 1)
	EnableControlAction(2, 27, 1)
	SetPedCanSwitchWeapon(true)
	TaskPlayAnim(PlayerPedId(), "anim@heists@fleeca_bank@drilling", "drill_straight_fail", 1.0, 0.1, 2000, 0, 0.0, 1, 1, 1);
	ClearPedTasksImmediately(PlayerPedId())
	if HasSoundFinished(Sound) and HasSoundFinished(PinSound) and HasSoundFinished(FailSound) then
		StopSound(Sound)
		StopSound(PinSound)
		StopSound(FailSound)
	end
	RemoveParticleFx(DrillFX, 0)
	drilling = false
	pin_one = false
	pin_two = false
	pin_three = false
	pin_four = false
	SetScaleformMovieAsNoLongerNeeded(scaleform)
	RemoveNamedPtfxAsset("fm_mission_controler")
	RemoveAnimDict("anim@heists@fleeca_bank@drilling")
end



function requestAudio()
	RequestAmbientAudioBank("SAFE_CRACK", false)
	RequestAmbientAudioBank("HEIST_FLEECA_DRILL", false) 
	RequestAmbientAudioBank("HEIST_FLEECA_DRILL_2", false) 
	RequestAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL", false) 
	RequestAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL_2", false) 
	RequestAmbientAudioBank("SAFE_CRACK", false) 
	RequestAmbientAudioBank("DLC_Biker_Cracked_Sounds", false) 
	RequestAmbientAudioBank("HUD_MINI_GAME_SOUNDSET", false) 
	RequestAmbientAudioBank("MissionFailedSounds", false) 
	RequestAmbientAudioBank("dlc_heist_fleeca_bank_door_sounds", false) 
	RequestAmbientAudioBank("vault_door", false) 
	RequestScriptAudioBank("Alarms", false) 
	RequestAmbientAudioBank("DLC_HEIST_FLEECA_SOUNDSET", false)
end



function DrawSpecialText(m_text, showtime)
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(showtime, 1)
end

Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(0)
		for i = 1, #Config.HackLocations do
			HackLocations = Config.HackLocations[i]
			DrawMarker(27, HackLocations[1], HackLocations[2], HackLocations[3], 0, 0, 0, 0, 0, 0, 0.75,0.75,0.5, 255, 0, 0,255, 0, 0, 0, 0)
			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), HackLocations[1], HackLocations[2], HackLocations[3], true ) < 1.5 then
				DrawSpecialText("Press ~b~[E]~w~ to start hacking")
				if(IsControlJustPressed(1, 38)) then
					TriggerEvent("mhacking:show")
					TriggerEvent("mhacking:start",7,35,checkSuccess)
				end
			end
		end
	end
end)

local alarm_sound = GetSoundId()

RegisterNetEvent("vault:syncOpen") 
AddEventHandler("vault:syncOpen", function()
	SetEntityHeading(vaultDoor, -60.0)
	PlaySoundFromCoord(alarm_sound, "Burglar_Bell",-2956.604, 481.441, 14.697, "Generic_Alarms", 0, 0, 0)
end)

RegisterNetEvent("vault:syncClose") 
AddEventHandler("vault:syncClose", function()
	local vaultDoor = GetClosestObjectOfType(-2956.604, 481.441, 14.697, 25.0, GetHashKey('hei_prop_heist_sec_door'), 0, 0, 0)
	SetEntityHeading(vaultDoor, 0.0)
	StopSound(alarm_sound)
end)

function checkSuccess(success, timeremaining)
	if success then
		TriggerEvent('mhacking:hide')
		TriggerServerEvent("vault:syncOpenServer")
	else
		TriggerEvent('mhacking:hide')
		TriggerServerEvent("vault:syncCloseServer")
	end
end



requestAudio()

