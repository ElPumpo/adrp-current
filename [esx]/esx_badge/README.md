# Policejob integration

### ⚠️ YOU MUST DO THIS TO ENABLE THE BADGE ⚠️

Add to police menu interaction list

    {label = ('Police Identification'), value = 'police_id'}

Add as elseif option

		elseif data.current.value == 'police_id' then
			ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'police_id',
			{
				title    = ('Police Identification'),
				align    = 'top-left',
				elements = {
					{label = ('Set Police ID (Badge)'),	value = 'set_pol_id'},
					{label = ('Show Police ID'),		value = 'show_pol_id'},
					{label = ('See Police ID'),		value = 'see_pol_id'}
				}
			}, function(data2, menu2)
				local polAction = data2.current.value
				if polAction == 'set_pol_id' then
					TriggerEvent('esx_badge:setBadge')
				elseif polAction == 'show_pol_id' then
					TriggerEvent('esx_badge:showBadge')
				else
					TriggerEvent('esx_badge:openBadge')
				end

			end, function(data2, menu2)
				menu2.close()
			end)			

		end
