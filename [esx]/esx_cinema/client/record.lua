RegisterNetEvent('esx_cinema:openEditor')
AddEventHandler('esx_cinema:openEditor', function()
	ActivateRockstarEditor()

	while IsPauseMenuActive() do
		Citizen.Wait(1000)
	end

	DoScreenFadeIn(1)
	TriggerEvent('customNotification', 'You left your previous session when you entered the Rockstar Editor, you must rejoin the server in order to play. Abusing this will not be tolerated.', 20000)
end)

RegisterNetEvent('esx_cinema:recordStart')
AddEventHandler('esx_cinema:recordStart', function()
	if IsRecording() then
		ESX.ShowNotification('You are already recording!')
	else
		StartRecording(1)
	end
end)

RegisterNetEvent('esx_cinema:recordStop')
AddEventHandler('esx_cinema:recordStop', function()
	if IsRecording() then
		StopRecordingAndSaveClip()
	else
		ESX.ShowNotification('You have not started recording!')
	end
end)

RegisterNetEvent('esx_cinema:recordDiscard')
AddEventHandler('esx_cinema:recordDiscard', function()
	if IsRecording() then
		StopRecordingAndDiscardClip()
	else
		ESX.ShowNotification('You have not started recording!')
	end
end)

