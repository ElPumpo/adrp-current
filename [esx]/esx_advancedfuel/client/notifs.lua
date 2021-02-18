function showDoneNotif(mes)
	SendNUIMessage({
		showDone = true,
		text = mes
	})
end

function showWarnNotif(mes)
	SendNUIMessage({
		showWarn = true,
		text = mes
	})
end

RegisterNetEvent('esx_advancedfuel:showErrorMessage')
AddEventHandler('esx_advancedfuel:showErrorMessage', function(mes)
	SendNUIMessage({
		showError = true,
		text = mes
	})
end)

RegisterNetEvent('esx_advancedfuel:showDoneMessage')
AddEventHandler('esx_advancedfuel:showDoneMessage', function(mes)
	showDoneNotif(mes)
end)

function showNoneNotif(mes)
	SendNUIMessage({
		showNone = true,
		text = mes
	})
end

