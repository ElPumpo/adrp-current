function OpenShopMenu()
	ESX.UI.Menu.CloseAll()

	local elements = {
		{
			label = ('%s - <span style="color:green;">$%s</span>'):format(_U('firstaidkit'), ESX.Math.GroupDigits(Config.Price.firstaidkit)),
			value = {name = 'firstaidkit',    price = Config.Price.firstaidkit}
		},
		{
			label = ('%s - <span style="color:green;">$%s</span>'):format(_U('defibrillateur'), ESX.Math.GroupDigits(Config.Price.defibrillateur)),
			value = {name = 'defibrillateur', price = Config.Price.defibrillateur}
		}
	}

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop', {
		title    = _U('drugstore'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		local element = data.current.value

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
			title = _U('valid_this_purchase'),
			align = 'top-left',
			elements = {
				{label = _U('yes'), value = 'yes'},
				{label = _U('no'),  value = 'no'}
			}
		}, function(data2, menu2)
			if data2.current.value == 'yes' then
				TriggerServerEvent('esx_pharmacy:buyItem', element.name, element.price)
			end

			menu2.close()
			setCurrentAction('pharmacy_shop', _U('press_menu'), {})
		end, function(data2, menu2)
			menu2.close()
		end)

	end, function(data, menu)
		menu.close()
	end)
end