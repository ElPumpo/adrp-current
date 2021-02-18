ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

MySQL.ready(function()
	print('[adrp_characterspawn] [^2INFO^7] initialized')
end)

Citizen.CreateThread(function()
	local uptimeMinute, uptimeHour, uptime = 0, 0, ''

	while true do
		Citizen.Wait(1000 * 60) -- every minute
		uptimeMinute = uptimeMinute + 1

		if uptimeMinute == 60 then
			uptimeMinute = 0
			uptimeHour = uptimeHour + 1
		end

		uptime = string.format('%02dh %02dm', uptimeHour, uptimeMinute)
		SetConvarServerInfo('Uptime', uptime)

		TriggerClientEvent('uptime:tick', -1, uptime)
		TriggerEvent('uptime:tick', uptime)
	end
end)

function setCurrentCharacter(playerId, character)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if not xPlayer then
		DropPlayer(playerId, 'There was an error selecting your character! Error code: missing-xplayer\n\nThis error is caused by switching Steam account after once joined ADRP already. Please only play with your previous Steam account.')
		return
	end

	character.playerId = playerId

	-- Json to Table
	local tables = {'position', 'skin', 'inventory', 'loadout', 'status', 'tattoos'}

	for index,encodedData in pairs(tables) do
		if not character[encodedData] then
			character[encodedData] = {}
		else
			character[encodedData] = json.decode(character[encodedData])
		end
	end

	xPlayer.setName(character.fullname)
	xPlayer.set('networkID', character.networkID)

	if not character.dirtymoney then
		character.dirtymoney = 0
	end

	-- Discord integration
	TriggerClientEvent('adrp_characterspawn:networkDiscordInformation', playerId, xPlayer.identifier, xPlayer.getGroup())

	--
	-- Properties
	-- Partial todo: datastore
	MySQL.Async.fetchAll('SELECT name, rented FROM owned_properties WHERE owner = @owner', {
		['@owner'] = xPlayer.identifier
	}, function(result)
		for k,v in ipairs(result) do
			TriggerClientEvent('esx_property:setPropertyOwned', playerId, v.name, true, v.rented)
		end
	end)

	--
	-- GCPhone
	--
	xPlayer.set('phoneNumber', character.phone_number)
	TriggerClientEvent('gcPhone:myPhoneNumber', playerId, character.phone_number)
	TriggerClientEvent('gcPhone:getBourse', playerId, {})

	MySQL.Async.fetchAll('SELECT * FROM phone_messages WHERE receiver = @receiver', {
		['@receiver'] = character.phone_number
	}, function(result)
		TriggerClientEvent('gcPhone:allMessage', playerId, result)
	end)

	MySQL.Async.fetchAll('SELECT * FROM phone_users_contacts WHERE identifier = @identifier AND identifier_phone = @phone_number', {
		['@identifier'] = xPlayer.identifier,
		['@phone_number'] = character.phone_number
	}, function(result)
		TriggerClientEvent('gcPhone:contactList', playerId, result)
	end)

	--
	-- Money, Job & Gang
	--
	xPlayer.setMoney(character.money)
	xPlayer.setAccountMoney('black_money', tonumber(character.dirtymoney))
	xPlayer.setAccountMoney('bank', character.bank)
	xPlayer.setJob(character.job, character.job_grade)
	xPlayer.setGang(character.gang, character.gang_grade)

	--
	-- Licenses
	--
	TriggerEvent('esx_license:getLicenses', playerId, function(licenses)
		TriggerClientEvent('esx_dmvschool:loadLicenses', playerId, licenses)
		TriggerClientEvent('esx_weashop:loadLicenses', playerId, licenses)
	end)

	--
	-- Items
	--
	for k,v in ipairs(xPlayer.inventory) do
		if v.count > 0 then
			xPlayer.setInventoryItem(v.name, 0, false)
		end
	end

	for item,count in pairs(character.inventory) do
		if ESX.Items[item] then -- is an valid item?
			xPlayer.setInventoryItem(item, count, false)
		end
	end

	--
	-- Police MDT
	--
	MySQL.Async.fetchAll('SELECT 1 FROM records WHERE UPPER(player) = UPPER(@username) and type = "warrant"', {
		['@username'] = character.fullname,
	}, function(resp2)
		if resp2[1] then
			TriggerEvent('adrp_policemdt:sendGlobalPoliceMessage', ('^5%s^0 has been ^1spotted^0 in the city!'):format(character.fullname))
		end
	end)

	--
	-- Status
	--
	xPlayer.set('status', character.status)
	TriggerClientEvent('esx_status:load', playerId, character.status)

	--
	-- Tattoos
	--
	TriggerClientEvent('esx_tattooshop:load', playerId, character.tattoos)

	--
	-- Skin
	--
	if next(character.skin) == nil then
		SetTimeout(6000, function()
			TriggerClientEvent('esx_skin:openSaveableMenu', playerId)
		end)
	else
		TriggerClientEvent('skinchanger:loadSkin', playerId, character.skin)
	end

	--
	-- Scoreboard
	--
	TriggerEvent('esx_scoreboard:identityUpdated', playerId, character.fullname)

	--
	-- General event
	--
	TriggerEvent('char:characterSet', character) -- deprecated
	TriggerEvent('adrp_characterspawn:characterSet', character)

	--
	-- Position, Jail, Instance & Loadout
	--
	if character.jail_time > 0 then
		TriggerEvent('esx_jail:charAddPlayer', playerId, character.jail_time)
		TriggerClientEvent('adrp_characterspawn:setPosition', playerId, {x = 1714.6, y = 2543.3, z = 45.0})
	else
		if character.is_dead == 1 then
			TriggerClientEvent('esx_ambulancejob:combatKillPlayer', playerId)
		else
			if character.last_property and character.last_property ~= '' then
				TriggerClientEvent('instance:create', playerId, 'property', {property = character.last_property, owner = xPlayer.identifier}) -- TODO proper owner
			end

			TriggerClientEvent('adrp_characterspawn:setPosition', playerId, character.position)

			-- Loadout
			-- TODO fix since it sometimes doesnt work
			xPlayer.setLoadout(character.loadout, true)

			SetTimeout(6000, function()
				TriggerClientEvent('adrp_characterspawn:restoreLoadout', playerId, character.loadout)
			end)
		end
	end
end

function switchCharacter(playerId, networkID, cb)
	local identifier = GetPlayerIdentifiers(playerId)[1]

	PerformHttpRequest(('%s/switch/%s/%s'):format(Config.ServerAddress, identifier, networkID), function(err, text, headers)
		if text then
			local resp = json.decode(text)

			if resp and resp.success then
				setCurrentCharacter(playerId, resp.character)
				print(('[adrp_characterspawn] [^2INFO^7] switchCharacter() completed [ID: %s | Identifier: %s | Response time: %s]'):format(playerId, identifier, resp.time))
			else
				print(('[adrp_characterspawn] [^3WARNING^7] switchCharacter() could not complete [ID: %s | Identifier: %s]'):format(playerId, identifier))
			end

			if cb then
				cb(resp.success)
			end
		else
			print('[adrp_characterspawn] [^1ERROR^7] adrp-char-api responce was empty!^7')

			if cb then
				cb(false, true)
			end
		end
	end)
end

function saveCharacter(playerId, identifier, disconnect, cb)
	PerformHttpRequest(('%s/save/%s/%s'):format(Config.ServerAddress, identifier, tostring(disconnect)), function(err, text, headers)
		if text then
			local resp = json.decode(text)

			if resp.success then
				print(('[adrp_characterspawn] [^2INFO^7] saveCharacter() completed [ID: %s | Identifier: %s | Response time: %s]'):format(playerId, identifier, resp.time))
			else
				print(('[adrp_characterspawn] [^3WARNING^7] saveCharacter() could not complete [ID: %s | Identifier: %s]'):format(playerId, identifier))
			end
	
			if cb then
				cb(resp.success)
			end
		else
			print('[adrp_characterspawn] [^1ERROR^7] adrp-char-api responce was empty!^7')

			if cb then
				cb(false)
			end
		end
	end)
end

ESX.RegisterServerCallback('adrp_characterspawn:executeAction', function(source, cb, data)
	if data.action == 'selectCharacter' then
		switchCharacter(source, data.networkID, function(success, charApiError)
			if success then
				cb({success = true, message = 'Success selecting character.'})
			else
				local message

				if charApiError then
					message = '<span class="thick">Error code:</span> char-api-offline<br><span class="thick">Message:</span> The character database seems to be offline. Please wait for a couple of minutes and try again.'
				else
					message = '<span class="thick">Error code:</span> char-api-internal<br><span class="thick">Message:</span> There was an internal error selecting your character, this can sometimes happen when the server is overloaded. If this error doesn\'t go away then there is something wrong with your character. You must contact the staff in order to fix your account.'
				end

				cb({success = false, message = message})
			end
		end)
	elseif data.action == 'deleteCharacter' then
		local networkID, characterID, identifier = data.networkID, data.characterID, GetPlayerIdentifiers(source)[1]

		MySQL.Async.fetchAll('SELECT 1 FROM characters WHERE identifier = @identifier AND networkID = @networkID', {
			['@identifier'] = identifier,
			['@networkID'] = networkID
		}, function(response)
			if response[1] then
				MySQL.Async.execute('DELETE FROM characters WHERE networkID = @networkID', {
					['@networkID'] = networkID
				}, function(rowsChanged)
					local message = ('**SteamHEX:** %s\n**characterID:** %s'):format(identifier, characterID)
					TriggerEvent('adrp_anticheat:sendLog', message, 'Character Deleted')
					cb({success = (rowsChanged == 1)})
				end)
			else
				-- anti cheat?!
				cb({success = false})
			end
		end)
	elseif data.action == 'getCharacters' then
		MySQL.Async.fetchAll('SELECT characterID, networkID, firstname, lastname, dateofbirth, height, sex FROM characters WHERE identifier = @identifier', {
			['@identifier'] = GetPlayerIdentifiers(source)[1]
		}, function(response)
			cb(response)
		end)
	elseif data.action == 'createCharacter' then
		local identifier = GetPlayerIdentifiers(source)[1]

		data = data.data
		data.firstname = ESX.Math.Trim(data.firstname)
		data.lastname = ESX.Math.Trim(data.lastname)
		data.fullname = ('%s %s'):format(data.firstname, data.lastname)
		data.identifier = identifier

		MySQL.Async.fetchAll('SELECT 1 FROM characters WHERE fullname = @fullname', {
			['@fullname'] = data.fullname
		}, function(result)
			if result[1] then
				cb({success = false, message = 'That character name has already been taken. On ADRP everyone must play with an unique character name, so please choose something else.'})
			else
				MySQL.Async.fetchAll('SELECT license, startup_money FROM users WHERE identifier = @identifier', {
					['@identifier'] = identifier
				}, function(resp)
					if resp and resp[1] and resp[1].license then -- TODO what's the nil value? we shouldn't have to check all three, right?
						data.license = resp[1].license
						data.startup_money, startupMoney = handleStartupMoney(resp[1].startup_money, data.characterID)
			
						MySQL.Async.execute('INSERT INTO characters (identifier, money, bank, license, characterID, firstname, lastname, fullname, dateofbirth, sex, height, phone_number) VALUES (@identifier, @money, @bank, @license, @characterID, @firstname, @lastname, @fullname, @dateofbirth, @sex, @height, @phone_number)', {
							['@characterID'] = data.characterID,
							['@identifier'] = identifier,
							['@money'] = 0,
							['@bank'] = startupMoney,
							['@license'] = data.license,
							['@firstname'] = data.firstname,
							['@lastname'] = data.lastname,
							['@fullname'] = data.fullname,
							['@dateofbirth'] = data.dateofbirth,
							['@sex'] = data.sex,
							['@height'] = data.height,
							['@phone_number'] = generatePhoneNumber()
						}, function(rowsChanged)
							if data.startup_money ~= resp[1].startup_money then
								MySQL.Sync.execute('UPDATE users SET startup_money = @startupMoney WHERE identifier = @identifier', {
									['@identifier'] = identifier,
									['@startupMoney'] = data.startup_money
								})
							end
			
							if rowsChanged > 0 then
								cb({success = true, message = 'Character has been successfully created'})
								local message = ('**SteamHEX:** %s\n**characterID:** %s'):format(identifier, data.characterID)
								TriggerEvent('adrp_anticheat:sendLog', message, 'Character Created')
							else
								cb({success = false, message = 'Error creating character'})
							end
						end)
					else
						cb({success = false, message = '<span class="thick">Error code:</span> missing-license<br><span class="thick">Message:</span> Make sure your\'re playing on the same Steam account that you used when you previously played on ADRP.'})
					end
				end)
			end
		end)
	end
end)

--- Generate number (string now) with format XXX-XXXX
function generatePhoneNumber()
	while true do
		Citizen.Wait(100)
		local suffix = math.random(0, 9999)
		local prefix = Config.AreaCodes[math.random(1, 255)]
		if prefix == -48 then prefix = 480 end

		local formattedNumber = ('%s-%04d'):format(prefix, suffix)
	
		if isPhoneNumberAvailable(formattedNumber) then
			return formattedNumber
		end
	end
end

function isPhoneNumberAvailable(phoneNumber)
	local fetched = MySQL.Sync.fetchScalar('SELECT 1 FROM users WHERE phone_number = @phone_number', {
		['@phone_number'] = phoneNumber
	})

	return fetched == nil
end

-- todo rewrite
RegisterServerEvent('adrp_characterspawn:getCharacterData')
AddEventHandler('adrp_characterspawn:getCharacterData', function()
	local identifier = GetPlayerIdentifiers(source)[1]
	local _source = source

	MySQL.Async.fetchAll('SELECT characterID, networkID, firstname, lastname, dateofbirth, height, sex FROM characters WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(resp)
		TriggerClientEvent('adrp_characterspawn:openMenu', _source, resp)
	end)
end)

TriggerEvent('es:addGroupCommand', 'charswitch', 'admin', function(source, args, user)
	local identifier = GetPlayerIdentifiers(source)[1]

	saveCharacter(source, identifier, false, function(success)
		MySQL.Async.fetchAll('SELECT * FROM characters WHERE identifier = @identifier', {
			['@identifier'] = identifier
		}, function(resp)
			TriggerClientEvent('adrp_characterspawn:openMenu', source, resp)
			TriggerClientEvent('adrp_characterspawn:spawnFreeze', source)
		end)
	end)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = 'Switch player character'})

TriggerEvent('es:addGroupCommand', 'charsave', 'admin', function(source, args, user)
	local identifier = GetPlayerIdentifiers(source)[1]
	saveCharacter(source, identifier, false)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = 'Force save current character'})

RegisterServerEvent('adrp_characterspawn:saveCharacterData')
AddEventHandler('adrp_characterspawn:saveCharacterData', function()
	local _source = source
	local identifier = GetPlayerIdentifiers(_source)[1]

	saveCharacter(_source, identifier, false)
end)

AddEventHandler('es:playerLoaded', function(playerId)
	local identifier = GetPlayerIdentifiers(playerId)[1]
	local dateNow = os.date('%Y-%m-%d %H:%M')

	MySQL.Async.execute('UPDATE users SET last_connected = @dateNow WHERE identifier = @identifier', {
		['@identifier'] = identifier,
		['@dateNow'] = dateNow
	})

	MySQL.Async.execute('UPDATE characters SET last_connected = @dateNow WHERE identifier = @identifier', {
		['@identifier'] = identifier,
		['@dateNow'] = dateNow
	})

	print(('[adrp_characterspawn] [^2INFO^7] %s has joined the server'):format(identifier))
end)

AddEventHandler('playerDropped', function(reason)
	local playerId = source

	if playerId > 3000 then
		return
	end

	local identifier = GetPlayerIdentifiers(playerId)[1]

	SetTimeout(5000, function()
		saveCharacter(playerId, identifier, true)
		print(('[adrp_characterspawn] [^2INFO^7] %s has left the server'):format(identifier))
	end)
end)

TriggerEvent('es:addGroupCommand', 'kickall', 'superadmin', function(source, args, user)
	if not args[1] then
		print('Usage: kickall [reason]')
	else
		KickAll(table.concat(args, ' '))
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {
	help = 'Kick all online players',
	params = {
		{name = 'reason', help = 'The reason for all players to be kicked. Will be displayed on kick'}
	}
})

RegisterCommand('charrestore', function(source, args, rawCommand)
	if source == 0 then
		PerformHttpRequest(('%s/saveUnsaved'):format(Config.ServerAddress), function(err, text, headers)
			local resp = json.decode(text)

			if resp.success then
				print(('[adrp_characterspawn] [^2INFO^7] saveUnsaved() success with responce time: %s'):format(resp.time))
			else
				print('[adrp_characterspawn] [^1ERROR^7] saveUnsaved() failed! Check adrp-char-api for stack trace')
			end
		end)
	end
end, true)

function KickAll(reason)
	local xPlayers = ESX.GetPlayers()

	for i=1, #xPlayers do
		DropPlayer(xPlayers[i], reason)
	end
end

function handleStartupMoney(startup, charID)
	local used = string.sub(startup, charID,charID) == '2'
	local newStartup

	if used then
		return startup, 0
	else
		newStartup = replaceChar(tostring(startup), charID, 2)
		return newStartup, Config.StartBankBalance
	end
end

function replaceChar(str, pos, new)
	return tonumber(str:sub(1, pos-1) .. new .. str:sub(pos+1))
end