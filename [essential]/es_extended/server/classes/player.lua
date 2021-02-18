function CreateExtendedPlayer(player, accounts, inventory, job, gang, loadout, name, lastPosition)
	local self = {}

	self.player       = player
	self.accounts     = accounts
	self.inventory    = inventory
	self.job          = job
	self.gang         = gang
	self.loadout      = loadout
	self.name         = name
	self.lastPosition = lastPosition
	self.maxWeight    = Config.MaxWeight

	self.source     = self.player.get('source')
	self.identifier = self.player.get('identifier')

	self.getWeight = function()
		local inventoryWeight = 0

		for k,v in ipairs(self.inventory) do
			inventoryWeight = inventoryWeight + (v.count * v.weight)
		end

		return inventoryWeight
	end

	self.canCarryItem = function(name, count)
		local currentWeight, itemWeight = self.getWeight(), ESX.Items[name].weight
		local newWeight = currentWeight + (itemWeight * count)

		return newWeight <= self.maxWeight
	end

	self.canSwapItem = function(firstItem, firstItemCount, testItem, testItemCount)
		local firstItemObject = self.getInventoryItem(firstItem)
		local testItemObject = self.getInventoryItem(testItem)

		if firstItemObject.count >= firstItemCount then
			local weightWithoutFirstItem = ESX.Math.Round(self.getWeight() - (firstItemObject.weight * firstItemCount))
			local weightWithTestItem = ESX.Math.Round(weightWithoutFirstItem + (testItemObject.weight * testItemCount))

			return weightWithTestItem <= self.maxWeight
		end

		return false
	end

	self.setMaxWeight = function(newWeight)
		self.maxWeight = newWeight
		TriggerClientEvent('esx:setMaxWeight', self.source, self.maxWeight)
	end

	self.setMoney = function(money)
		money = ESX.Math.Round(money)
		self.player.setMoney(money)
	end

	self.getMoney = function()
		return self.player.get('money')
	end

	self.setBankBalance = function(money)
		money = ESX.Math.Round(money)
		self.player.setBankBalance(money)
	end

	self.getBank = function()
		return self.player.get('bank')
	end

	self.getCoords = function(vectorType)
		local coords = self.player.get('coords')
		coords = {x = ESX.Math.Round(coords.x, 1), y = ESX.Math.Round(coords.y, 1), z = ESX.Math.Round(coords.z, 1)}

		if vectorType then
			return vector3(coords.x, coords.y, coords.z)
		else
			return coords
		end
	end

	self.setCoords = function(x, y, z)
		self.player.coords = {x = x, y = y, z = z}
	end

	self.kick = function(r)
		self.player.kick(r)
	end

	self.addMoney = function(money)
		money = ESX.Math.Round(money)
		self.player.addMoney(money)
	end

	self.removeMoney = function(money)
		money = ESX.Math.Round(money)

		if money >= 0 then
			self.player.removeMoney(money)
		else
			print(('es_extended: ignoring :removeMoney "%s" for xPlayer "%s"'):format(money, self.source))
		end
	end

	self.addBank = function(money)
		money = ESX.Math.Round(money)
		self.player.addBank(money)
	end

	self.removeBank = function(money)
		money = ESX.Math.Round(money)
		self.player.removeBank(money)
	end

	self.displayMoney = function(money)
		self.player.displayMoney(money)
	end

	self.displayBank = function(money)
		self.player.displayBank(money)
	end

	self.setSessionVar = function(key, value)
		self.player.setSessionVar(key, value)
	end

	self.getSessionVar = function(k)
		return self.player.getSessionVar(k)
	end

	self.getPermissions = function()
		return self.player.getPermissions()
	end

	self.setPermissions = function(p)
		self.player.setPermissions(p)
	end

	self.getIdentifier = function()
		return self.player.getIdentifier()
	end

	self.getGroup = function()
		return self.player.getGroup()
	end

	self.set = function(k, v)
		self.player.set(k, v)
	end

	self.get = function(k)
		return self.player.get(k)
	end

	self.getPlayer = function()
		return self.player
	end

	self.getAccounts = function()
		local accounts = {}

		for i=1, #Config.Accounts do
			if Config.Accounts[i] == 'bank' then
				table.insert(accounts, {
					name  = 'bank',
					money = self.get('bank'),
					label = Config.AccountLabels['bank']
				})
			else
				for j=1, #self.accounts do
					if self.accounts[j].name == Config.Accounts[i] then
						table.insert(accounts, self.accounts[j])
					end
				end
			end
		end

		return accounts
	end

	self.getAccount = function(a)
		if a == 'bank' then
			return {
				name  = 'bank',
				money = self.get('bank'),
				label = Config.AccountLabels['bank']
			}
		end

		for i=1, #self.accounts do
			if self.accounts[i].name == a then
				return self.accounts[i]
			end
		end
	end

	self.getJob = function()
		return self.job
	end

	self.getGang = function()
		return self.gang
	end

	self.getInventory = function(minimal)
		if minimal then
			local minimalInventory = {}

			for k,v in ipairs(self.inventory) do
				if v.count > 0 then
					minimalInventory[v.name] = v.count
				end
			end

			return minimalInventory
		else
			return self.inventory
		end
	end

	self.getLoadout = function(minimal)
		if minimal then
			local minimalLoadout = {}

			for k,v in ipairs(self.loadout) do
				table.insert(minimalLoadout, {
					name = v.name,
					ammo = v.ammo,
					components = v.components
				})
			end

			return minimalLoadout
		else
			return self.loadout
		end
	end

	self.setLoadout = function(newLoadout, minimal)
		if minimal then
			for k,v in ipairs(newLoadout) do
				newLoadout[k].label = ESX.GetWeaponLabel(v.name)
			end
		end

		self.loadout = newLoadout
	end

	self.getName = function()
		return self.name
	end

	self.setName = function(newName)
		self.name = newName
		TriggerClientEvent('esx:setName', self.source, newName)
	end

	self.getLastPosition = function()
		if self.lastPosition and self.lastPosition.x and self.lastPosition.y and self.lastPosition.z then
			self.lastPosition.x = ESX.Math.Round(self.lastPosition.x, 1)
			self.lastPosition.y = ESX.Math.Round(self.lastPosition.y, 1)
			self.lastPosition.z = ESX.Math.Round(self.lastPosition.z, 1)
		end

		return self.lastPosition
	end

	self.setLastPosition = function(position)
		self.lastPosition = position
	end

	self.getMissingAccounts = function(cb)
		MySQL.Async.fetchAll('SELECT * FROM `user_accounts` WHERE `identifier` = @identifier', {
			['@identifier'] = self.getIdentifier()
		}, function(result)
			local missingAccounts = {}

			for i=1, #Config.Accounts do
				if Config.Accounts[i] ~= 'bank' then
					local found = false

					for j=1, #result do
						if Config.Accounts[i] == result[j].name then
							found = true
							break
						end
					end

					if not found then
						table.insert(missingAccounts, Config.Accounts[i])
					end
				end
			end

			cb(missingAccounts)
		end)
	end

	self.createAccounts = function(missingAccounts, cb)
		for i=1, #missingAccounts do
			MySQL.Async.execute('INSERT INTO `user_accounts` (identifier, name) VALUES (@identifier, @name)',
			{
				['@identifier'] = self.getIdentifier(),
				['@name']       = missingAccounts[i]
			}, function(rowsChanged)
				if cb ~= nil then
					cb()
				end
			end)
		end
	end

	self.setAccountMoney = function(acc, money)
		local account   = self.getAccount(acc)
		local prevMoney = account.money
		local newMoney  = ESX.Math.Round(money)

		account.money = newMoney

		if acc == 'bank' then
			self.set('bank', newMoney)
		end

		TriggerClientEvent('esx:setAccountMoney', self.source, account)
	end

	self.addAccountMoney = function(acc, money)
		local account  = self.getAccount(acc)
		local newMoney = account.money + ESX.Math.Round(money)

		account.money = newMoney

		if acc == 'bank' then
			self.set('bank', newMoney)
		end

		TriggerClientEvent('esx:setAccountMoney', self.source, account)
	end

	self.removeAccountMoney = function(a, m)
		local account  = self.getAccount(a)
		local newMoney = account.money - m

		account.money = newMoney

		if a == 'bank' then
			self.set('bank', newMoney)
		end

		TriggerClientEvent('esx:setAccountMoney', self.source, account)
	end

	self.getInventoryItem = function(name)
		for i=1, #self.inventory do
			if self.inventory[i].name == name then
				return self.inventory[i]
			end
		end
	end

	self.addInventoryItem = function(name, count, showNotification)
		if showNotification == nil then showNotification = true end

		local item     = self.getInventoryItem(name)
		local newCount = item.count + count
		item.count     = newCount

		TriggerEvent('esx:onAddInventoryItem', self.source, item, count)
		TriggerClientEvent('esx:addInventoryItem', self.source, item, count, showNotification)
		TriggerClientEvent('adrp_ui:updateWeight', self.source, (self.getWeight() / self.maxWeight) * 100)
	end

	self.removeInventoryItem = function(name, count, showNotification)
		if showNotification == nil then showNotification = true end

		local item     = self.getInventoryItem(name)
		local newCount = item.count - count
		item.count     = newCount

		TriggerEvent('esx:onRemoveInventoryItem', self.source, item, count)
		TriggerClientEvent('esx:removeInventoryItem', self.source, item, count, showNotificaiton)
		TriggerClientEvent('adrp_ui:updateWeight', self.source, (self.getWeight() / self.maxWeight) * 100)
	end

	self.setInventoryItem = function(name, count, showNotification)
		if showNotification == nil then showNotification = true end

		local item     = self.getInventoryItem(name)
		local oldCount = item.count
		item.count     = count

		if oldCount > item.count  then
			TriggerEvent('esx:onRemoveInventoryItem', self.source, item, oldCount - item.count)
			TriggerClientEvent('esx:removeInventoryItem', self.source, item, oldCount - item.count, showNotification)
			TriggerClientEvent('adrp_ui:updateWeight', self.source, (self.getWeight() / self.maxWeight) * 100)
		else
			TriggerEvent('esx:onAddInventoryItem', self.source, item, item.count - oldCount)
			TriggerClientEvent('esx:addInventoryItem', self.source, item, item.count - oldCount, showNotification)
			TriggerClientEvent('adrp_ui:updateWeight', self.source, (self.getWeight() / self.maxWeight) * 100)
		end
	end

	self.clearInventory = function(showNotification)
		for k,v in ipairs(self.inventory) do
			if v.count > 0 then
				self.removeInventoryItem(v.name, v.count, showNotification)
			end
		end
	end

	self.setJob = function(job, grade)
		grade = tostring(grade)
		local lastJob = json.decode(json.encode(self.job))

		if ESX.DoesJobExist(job, grade) then
			local jobObject, gradeObject = ESX.Jobs[job], ESX.Jobs[job].grades[grade]

			self.job.id    = jobObject.id
			self.job.name  = jobObject.name
			self.job.label = jobObject.label

			self.job.grade        = tonumber(grade)
			self.job.grade_name   = gradeObject.name
			self.job.grade_label  = gradeObject.label
			self.job.grade_salary = gradeObject.salary

			self.job.skin_male    = {}
			self.job.skin_female  = {}

			if gradeObject.skin_male ~= nil then
				self.job.skin_male = json.decode(gradeObject.skin_male)
			end

			if gradeObject.skin_female ~= nil then
				self.job.skin_female = json.decode(gradeObject.skin_female)
			end

			TriggerEvent('esx:setJob', self.source, self.job, lastJob)
			TriggerClientEvent('esx:setJob', self.source, self.job)
		else
			print(('es_extended: ignoring setJob for %s due to job not found!'):format(self.source))
		end
	end

	self.setGang = function(gang, grade)
		grade = tostring(grade)
		local lastGang = json.decode(json.encode(self.gang))

		if ESX.DoesGangExist(gang, grade) then
			local gangObject, gradeObject = ESX.Gangs[gang], ESX.Gangs[gang].grades[grade]

			self.gang.name = gangObject.name
			self.gang.label = gangObject.label
			self.gang.grade = grade

			self.gang.grade_name = gradeObject.name
			self.gang.grade_label = gradeObject.label

			TriggerEvent('esx:setGang', self.source, self.gang, lastGang)
			TriggerClientEvent('esx:setGang', self.source, self.gang)
		else
			print(('es_extended: ignoring setGang for %s due to gang not found!'):format(self.source))
		end
	end

	self.addWeapon = function(weaponName, ammo)
		local weaponLabel = ESX.GetWeaponLabel(weaponName)

		if not self.hasWeapon(weaponName) then
			table.insert(self.loadout, {
				name = weaponName,
				ammo = ammo,
				label = weaponLabel,
				components = {}
			})
		end

		TriggerClientEvent('esx:addWeapon', self.source, weaponName, ammo)
		TriggerClientEvent('esx:addInventoryItem', self.source, {label = weaponLabel}, 1)
	end

	self.addWeaponComponent = function(weaponName, weaponComponent)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			if not self.hasWeaponComponent(weaponName, weaponComponent) then
				table.insert(self.loadout[loadoutNum].components, weaponComponent)

				TriggerClientEvent('esx:addWeaponComponent', self.source, weaponName, weaponComponent)
			end
		end
	end

	self.addWeaponAmmo = function(weaponName, ammoCount)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then

			weapon.ammo = weapon.ammo + ammoCount
			TriggerClientEvent('esx:setWeaponAmmo', self.source, weaponName, weapon.ammo)
		end
	end

	self.removeWeapon = function(weaponName, ammo)
		local weaponLabel

		for i=1, #self.loadout do
			if self.loadout[i].name == weaponName then
				weaponLabel = self.loadout[i].label

				table.remove(self.loadout, i)
				break
			end
		end

		if weaponLabel then
			TriggerClientEvent('esx:removeWeapon', self.source, weaponName, ammo)
			TriggerClientEvent('esx:removeInventoryItem', self.source, {label = weaponLabel})
		end
	end

	self.removeWeaponComponent = function(weaponName, weaponComponent)
		local loadoutNum, weapon = self.getWeapon(weaponName)
		
		if weapon then
			for k,v in ipairs(self.loadout[loadoutNum].components) do
				if v.name == weaponComponent then
					table.remove(self.loadout[loadoutNum].components, k)
					break
				end
			end
			TriggerClientEvent('esx:removeWeaponComponent', self.source, weaponName, weaponComponent)
		end
	end

	self.removeWeaponAmmo = function(weaponName, ammoCount)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			weapon.ammo = weapon.ammo - ammoCount
			TriggerClientEvent('esx:setWeaponAmmo', self.source, weaponName, weapon.ammo)
		end
	end

	self.hasWeaponComponent = function(weaponName, weaponComponent)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			for k,v in ipairs(weapon.components) do
				if v == weaponComponent then
					return true
				end
			end

			return false
		else
			return false
		end
	end

	self.hasWeapon = function(weaponName)
		for i=1, #self.loadout do
			if self.loadout[i].name == weaponName then
				return true
			end
		end

		return false
	end

	self.getWeapon = function(weaponName)
		for i=1, #self.loadout do
			if self.loadout[i].name == weaponName then
				return i, self.loadout[i]
			end
		end

		return nil
	end

	self.showNotification = function(msg)
		TriggerClientEvent('esx:showNotification', self.source, msg)
	end

	self.showHelpNotification = function(msg)
		TriggerClientEvent('esx:showHelpNotification', self.source, msg)
	end

	return self
end