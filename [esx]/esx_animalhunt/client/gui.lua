function OpenHuntingShopMenu()
	local elements = {}
	local playerPed = PlayerPedId()

	PlaySoundFrontend(-1, 'SELECT', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false)

	if HasPedGotWeapon(playerPed, GetHashKey('WEAPON_MUSKET'), false) then
		local ammo = GetAmmoInPedWeapon(playerPed, GetHashKey('WEAPON_MUSKET'))

		table.insert(elements, {
			label = ('Musket: <span style="color:green;">Owned</span> | Ammo: <span style="color:darkred;">%s bullets</span>'):format(ammo),
			action = 'musket_ammo',
			ammo = ammo
		})
	else
		table.insert(elements, {
			label = ('Musket: <span style="color:green;">$%s</span>'):format(ESX.Math.GroupDigits(Config.MusketPrice)),
			action = 'musket'
		})
	end

	if HasPedGotWeapon(playerPed, GetHashKey('WEAPON_KNIFE'), false) then
		table.insert(elements, {label = 'Knife: <span style="color:green;">Owned</span>', action = 'owned'})
	else
		table.insert(elements, {
			label = ('Knife: <span style="color:green;">$%s</span>'):format(ESX.Math.GroupDigits(Config.KnifePrice)),
			action = 'knife'
		})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'hunting_shop', {
		title    = 'Hunting Shop',
		align    = 'center',
		elements = elements
	}, function(data, menu)
		if data.current.action == 'musket' then
			ESX.TriggerServerCallback('esx_animalhunt:canAfford', function(paid)
				if paid then
					GiveWeaponToPed(playerPed, GetHashKey('WEAPON_MUSKET'), 0, false, false)
					PlaySoundFrontend(-1, 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET', false)
					OpenHuntingShopMenu()
				else
					PlaySoundFrontend(-1, 'ERROR', 'HUD_AMMO_SHOP_SOUNDSET', false)
				end
			end, Config.MusketPrice)
		elseif data.current.action == 'musket_ammo' then
			if data.current.ammo < 50 then
				ESX.TriggerServerCallback('esx_animalhunt:canAfford', function(paid)
					if paid then
						AddAmmoToPed(playerPed, GetHashKey('WEAPON_MUSKET'), 10)
						PlaySoundFrontend(-1, 'WEAPON_AMMO_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET', false)
						OpenHuntingShopMenu()
					else
						PlaySoundFrontend(-1, 'ERROR', 'HUD_AMMO_SHOP_SOUNDSET', false)
					end
				end, Config.BulletPrice)
			else
				PlaySoundFrontend(-1, 'ERROR', 'HUD_AMMO_SHOP_SOUNDSET', false)
			end

		elseif data.current.action == 'knife' then
			ESX.TriggerServerCallback('esx_animalhunt:canAfford', function(paid)
				if paid then
					GiveWeaponToPed(playerPed, GetHashKey('WEAPON_KNIFE'), 0, false, false)
					OpenHuntingShopMenu()
				else
					PlaySoundFrontend(-1, 'ERROR', 'HUD_AMMO_SHOP_SOUNDSET', false)
				end
			end, Config.KnifePrice)
		elseif data.current.action == 'owned' then
			PlaySoundFrontend(-1, 'ERROR', 'HUD_AMMO_SHOP_SOUNDSET', false)
		end
	end, function(data, menu)
		PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)
		menu.close()
	end, function(data, menu)
		PlaySoundFrontend(-1, 'NAV', 'HUD_AMMO_SHOP_SOUNDSET', false)
	end)
end

function OpenLicenceMenu()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'hunting_license', {
		title    = 'Buy Hunting License?',
		align    = 'top-left',
		elements = {
			{ label = 'No', value = 'no' },
			{ label = ('buy Hunting License: <span style="color:green;">$%s</span>'):format(ESX.Math.GroupDigits(Config.HuntingLicense)), value = 'yes' }
		}
	}, function(data, menu)
		if data.current.value == 'yes' then
			ESX.TriggerServerCallback('esx_animalhunt:buyHuntingLicense', function(boughtLicense)
				if boughtLicense then
					ESX.ShowNotification(("You've bought the ~o~Hunting License~s~ for ~g~$%s~s~"):format(ESX.Math.GroupDigits(Config.HuntingLicense)))
					menu.close()

					OpenHuntingShopMenu()
				else
					ESX.ShowNotification('You cannot afford the license!')
				end
			end)
		else
			menu.close()
		end
	end, function(data, menu)
		menu.close()
	end)
end