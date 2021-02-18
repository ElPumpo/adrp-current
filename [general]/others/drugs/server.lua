RegisterServerEvent('sell:check1')
AddEventHandler('sell:check1', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local Cokepayment = math.random(500,650)
	local Methpayment = math.random(500,700)
	local Weedpayment = math.random(250,500)
	local Heropayment = math.random(100,250)
	local nztpayment = math.random(750,1000)
	local moonshinepayment = math.random(300,500)
	local ketpayment = math.random(750,1000)

	local xPlayer  = ESX.GetPlayerFromId(source)

	local cokeqty = xPlayer.getInventoryItem('coke_pooch').count
	local methqty = xPlayer.getInventoryItem('meth_pooch').count
	local weedqty = xPlayer.getInventoryItem('weed_pooch').count
	local heroqty = xPlayer.getInventoryItem('opium_pooch').count
	local nztqty = xPlayer.getInventoryItem('nzt').count
	local moonshineqty = xPlayer.getInventoryItem('moonshine').count
	local ketqty = xPlayer.getInventoryItem('step2').count

	if cokeqty >= 5 then
		local x = math.random(1,5)

		TriggerClientEvent('currentlySelling', _source)

		local cokePay = Cokepayment * x
			xPlayer.addAccountMoney('black_money', cokePay)
			xPlayer.removeInventoryItem('coke_pooch', x)

			TriggerClientEvent("pNotify:SetQueueMax", _source, "gta", 5)
			TriggerClientEvent("pNotify:SendNotification", _source, {
				text = "You have sold " ..x.. " grams of coke for $" .. cokePay ,
				type = "success",
				progressBar = false,
				queue = "gta",
				timeout = 2000,
				layout = "CenterRight"
			})
		TriggerClientEvent('done', _source)
		TriggerClientEvent('cancel', _source)

	elseif cokeqty == 4 then
		local x = math.random(1,4)
		TriggerClientEvent('currentlySelling', _source)
		local cokePay = Cokepayment * x
			xPlayer.addAccountMoney('black_money', cokePay)
			xPlayer.removeInventoryItem('coke_pooch', x)

			TriggerClientEvent("pNotify:SetQueueMax", _source, "gta", 5)
			TriggerClientEvent("pNotify:SendNotification", _source, {
				text = "You have sold " ..x.. " grams of coke for $"..cokePay,
				type = "success",
				progressBar = false,
				queue = "gta",
				timeout = 2000,
				layout = "CenterRight"
			})
		TriggerClientEvent('done', _source)
		TriggerClientEvent('cancel', _source)

	elseif cokeqty == 3 then
		local x = math.random(1,3)
		TriggerClientEvent('currentlySelling', _source)
		local cokePay = Cokepayment * x
			xPlayer.addAccountMoney('black_money', cokePay)
			xPlayer.removeInventoryItem('coke_pooch', x)

			TriggerClientEvent("pNotify:SetQueueMax", _source, "gta", 5)
			TriggerClientEvent("pNotify:SendNotification", _source, {
				text = "You have sold " ..x.. " grams of coke for $"..cokePay,
				type = "success",
				progressBar = false,
				queue = "gta",
				timeout = 2000,
				layout = "CenterRight"
			})
		TriggerClientEvent('done', _source)
		TriggerClientEvent('cancel', _source)

	elseif cokeqty == 2 then
		local x = math.random(1,2)
		TriggerClientEvent('currentlySelling', _source)
		local cokePay = Cokepayment * x
			xPlayer.addAccountMoney('black_money', cokePay)
			xPlayer.removeInventoryItem('coke_pooch', x)

			TriggerClientEvent("pNotify:SetQueueMax", _source, "gta", 5)
			TriggerClientEvent("pNotify:SendNotification", _source, {
				text = "You have sold " ..x.. " grams of coke for $"..cokePay,
				type = "success",
				progressBar = false,
				queue = "gta",
				timeout = 2000,
				layout = "CenterRight"
			})
		TriggerClientEvent('done', _source)
		TriggerClientEvent('cancel', _source)

	elseif cokeqty == 1 then
		TriggerClientEvent('currentlySelling', _source)
			xPlayer.addAccountMoney('black_money', Cokepayment)
			xPlayer.removeInventoryItem('coke_pooch', 1)

			TriggerClientEvent("pNotify:SetQueueMax", _source, "gta", 5)
			TriggerClientEvent("pNotify:SendNotification", _source, {
				text = "You have sold 1 gram of coke for $"..Cokepayment,
				type = "success",
				progressBar = false,
				queue = "gta",
				timeout = 2000,
				layout = "CenterRight"
			})
		TriggerClientEvent('done', _source)
		TriggerClientEvent('cancel', _source)

----------------------------------------------------------------------------------
--
--
--
--                         Meth
--
--
----------------------------------------------------------------------------------

	elseif methqty >= 5 then
			local x2 = math.random(1,5)
			TriggerClientEvent('currentlySelling', _source)
			local methPay = Methpayment * x2
			xPlayer.addAccountMoney('black_money', methPay)
			xPlayer.removeInventoryItem('meth_pooch', x2)

			TriggerClientEvent("pNotify:SetQueueMax", _source, "gta", 5)
			TriggerClientEvent("pNotify:SendNotification", _source, {
				text = "You have sold " ..x2.. " grams of meth for $" .. methPay,
				type = "success",
				progressBar = false,
				queue = "gta",
				timeout = 2000,
				layout = "CenterRight"
			})
			TriggerClientEvent('done', _source)
			TriggerClientEvent('cancel', _source)

	elseif methqty == 4 then
		local x2 = math.random(1,4)
		TriggerClientEvent('currentlySelling', _source)
		local methPay = Methpayment * x2
		xPlayer.addAccountMoney('black_money', methPay)
		xPlayer.removeInventoryItem('meth_pooch', x2)

		TriggerClientEvent("pNotify:SetQueueMax", _source, "gta", 5)
		TriggerClientEvent("pNotify:SendNotification", _source, {
			text = "You have sold " ..x2.. " grams of meth for $" .. methPay,
			type = "success",
			progressBar = false,
			queue = "gta",
			timeout = 2000,
			layout = "CenterRight"
		})
		TriggerClientEvent('done', _source)
		TriggerClientEvent('cancel', _source)

	elseif methqty == 3 then
		local x2 = math.random(1,3)
		TriggerClientEvent('currentlySelling', _source)
		local methPay = Methpayment * x2
		xPlayer.addAccountMoney('black_money', methPay)
		xPlayer.removeInventoryItem('meth_pooch', x2)

		TriggerClientEvent("pNotify:SetQueueMax", _source, "gta", 5)
		TriggerClientEvent("pNotify:SendNotification", _source, {
			text = "You have sold " ..x2.. " grams of meth for $" .. methPay,
			type = "success",
			progressBar = false,
			queue = "gta",
			timeout = 2000,
			layout = "CenterRight"
		})
		TriggerClientEvent('done', _source)
		TriggerClientEvent('cancel', _source)

	elseif methqty == 2 then
		local x2 = math.random(1,2)
		TriggerClientEvent('currentlySelling', _source)
		local methPay = Methpayment * x2
		xPlayer.addAccountMoney('black_money', methPay)
		xPlayer.removeInventoryItem('meth_pooch', x2)

		TriggerClientEvent("pNotify:SetQueueMax", _source, "gta", 5)
		TriggerClientEvent("pNotify:SendNotification", _source, {
			text = "You have sold " ..x2.. " grams of meth for $"..methPay,
			type = "success",
			progressBar = false,
			queue = "gta",
			timeout = 2000,
			layout = "CenterRight"
		})
		TriggerClientEvent('done', _source)
		TriggerClientEvent('cancel', _source)

	elseif methqty == 1 then
		TriggerClientEvent('currentlySelling', _source)
		xPlayer.addAccountMoney('black_money', Methpayment)
		xPlayer.removeInventoryItem('meth_pooch', 1)

		TriggerClientEvent("pNotify:SetQueueMax", _source, "gta", 5)
		TriggerClientEvent("pNotify:SendNotification", _source, {
			text = "You have sold 1 grams of meth for $" .. Methpayment,
			type = "success",
			progressBar = false,
			queue = "gta",
			timeout = 2000,
			layout = "CenterRight"
		})
		TriggerClientEvent('done', _source)
		TriggerClientEvent('cancel', _source)

----------------------------------------------------------------------------------
--
--
--
--                         nzt
--
--
----------------------------------------------------------------------------------



----------------------------------------------------------------------------------
--
--
--
--                         Moonshine
--
--
----------------------------------------------------------------------------------

	elseif moonshineqty >= 5 then
		local x2 = math.random(1,5)
		TriggerClientEvent('currentlySelling', _source)
		local moonshinePay = moonshinepayment * x2
		xPlayer.addAccountMoney('black_money', moonshinePay)
		xPlayer.removeInventoryItem('moonshine', x2)

		TriggerClientEvent("pNotify:SetQueueMax", _source, "gta", 5)
		TriggerClientEvent("pNotify:SendNotification", _source, {
			text = "You have sold " ..x2.. " pints of moonshine for $" .. moonshinePay,
			type = "success",
			progressBar = false,
			queue = "gta",
			timeout = 2000,
			layout = "CenterRight"
		})
		TriggerClientEvent('done', _source)
		TriggerClientEvent('cancel', _source)

	elseif moonshineqty == 4 then
		local x2 = math.random(1,4)
		TriggerClientEvent('currentlySelling', _source)
		local moonshinePay = moonshinepayment * x2
		xPlayer.addAccountMoney('black_money', moonshinePay)
		xPlayer.removeInventoryItem('moonshine', x2)

		TriggerClientEvent("pNotify:SetQueueMax", _source, "gta", 5)
		TriggerClientEvent("pNotify:SendNotification", _source, {
			text = "You have sold " ..x2.. " pints of moonshine for $" .. moonshinePay,
			type = "success",
			progressBar = false,
			queue = "gta",
			timeout = 2000,
			layout = "CenterRight"
		})
		TriggerClientEvent('done', _source)
		TriggerClientEvent('cancel', _source)

	elseif moonshineqty == 3 then
		local x2 = math.random(1,3)
		TriggerClientEvent('currentlySelling', _source)
		local moonshinePay = moonshinepayment * x2
		xPlayer.addAccountMoney('black_money', moonshinePay)
		xPlayer.removeInventoryItem('moonshine', x2)

		TriggerClientEvent("pNotify:SetQueueMax", _source, "gta", 5)
		TriggerClientEvent("pNotify:SendNotification", _source, {
			text = "You have sold " ..x2.. " pints of moonshine for $" .. moonshinePay,
			type = "success",
			progressBar = false,
			queue = "gta",
			timeout = 2000,
			layout = "CenterRight"
		})
		TriggerClientEvent('done', _source)
		TriggerClientEvent('cancel', _source)

	elseif moonshineqty == 2 then
		local x2 = math.random(1,2)
		TriggerClientEvent('currentlySelling', _source)
		local moonshinePay = moonshinepayment * x2
		xPlayer.addAccountMoney('black_money', moonshinePay)
		xPlayer.removeInventoryItem('moonshine', x2)

		TriggerClientEvent("pNotify:SetQueueMax", _source, "gta", 5)
		TriggerClientEvent("pNotify:SendNotification", _source, {
			text = "You have sold " ..x2.. " pints of moonshine for $"..moonshinePay,
			type = "success",
			progressBar = false,
			queue = "gta",
			timeout = 2000,
			layout = "CenterRight"
		})
		TriggerClientEvent('done', _source)
		TriggerClientEvent('cancel', _source)

	elseif moonshineqty == 1 then
		TriggerClientEvent('currentlySelling', _source)
		xPlayer.addAccountMoney('black_money', moonshinepayment)
		xPlayer.removeInventoryItem('moonshine', 1)

		TriggerClientEvent("pNotify:SetQueueMax", _source, "gta", 5)
		TriggerClientEvent("pNotify:SendNotification", _source, {
			text = "You have sold 1 pint of moonshine for $" .. moonshinepayment,
			type = "success",
			progressBar = false,
			queue = "gta",
			timeout = 2000,
			layout = "CenterRight"
		})
		TriggerClientEvent('done', _source)
		TriggerClientEvent('cancel', _source)

----------------------------------------------------------------------------------
--
--
--
--                         Ketamine
--
--
----------------------------------------------------------------------------------

	elseif ketqty >= 5 then
		local x2 = math.random(1,5)
		TriggerClientEvent('currentlySelling', _source)
		local ketPay = ketpayment * x2
		xPlayer.addAccountMoney('black_money', ketPay)
		xPlayer.removeInventoryItem('step2', x2)

		TriggerClientEvent("pNotify:SetQueueMax", _source, "gta", 5)
		TriggerClientEvent("pNotify:SendNotification", _source, {
			text = "You have sold " ..x2.. " vials of Ketamine for $" .. ketPay,
			type = "success",
			progressBar = false,
			queue = "gta",
			timeout = 2000,
			layout = "CenterRight"
		})
		TriggerClientEvent('done', _source)
		TriggerClientEvent('cancel', _source)

	elseif ketqty == 4 then
		local x2 = math.random(1,4)
		TriggerClientEvent('currentlySelling', _source)
		local ketPay = ketpayment * x2
		xPlayer.addAccountMoney('black_money', ketPay)
		xPlayer.removeInventoryItem('step2', x2)

		TriggerClientEvent("pNotify:SetQueueMax", _source, "gta", 5)
		TriggerClientEvent("pNotify:SendNotification", _source, {
			text = "You have sold " ..x2.. " vials of ketamine for $" .. ketPay,
			type = "success",
			progressBar = false,
			queue = "gta",
			timeout = 2000,
			layout = "CenterRight"
		})
		TriggerClientEvent('done', _source)
		TriggerClientEvent('cancel', _source)

	elseif ketqty == 3 then
		local x2 = math.random(1,3)
		TriggerClientEvent('currentlySelling', _source)
		local ketPay = ketpayment * x2
		xPlayer.addAccountMoney('black_money', ketPay)
		xPlayer.removeInventoryItem('step2', x2)

		TriggerClientEvent("pNotify:SetQueueMax", _source, "gta", 5)
		TriggerClientEvent("pNotify:SendNotification", _source, {
			text = "You have sold " ..x2.. " vials of ketamine for $" .. ketPay,
			type = "success",
			progressBar = false,
			queue = "gta",
			timeout = 2000,
			layout = "CenterRight"
		})
		TriggerClientEvent('done', _source)
		TriggerClientEvent('cancel', _source)

	elseif ketqty == 2 then
		local x2 = math.random(1,2)
		TriggerClientEvent('currentlySelling', _source)
		local ketPay = ketpayment * x2
		xPlayer.addAccountMoney('black_money', ketPay)
		xPlayer.removeInventoryItem('step2', x2)

		TriggerClientEvent("pNotify:SetQueueMax", _source, "gta", 5)
		TriggerClientEvent("pNotify:SendNotification", _source, {
			text = "You have sold " ..x2.. " vials of ketamine for $"..ketPay,
			type = "success",
			progressBar = false,
			queue = "gta",
			timeout = 2000,
			layout = "CenterRight"
		})
		TriggerClientEvent('done', _source)
		TriggerClientEvent('cancel', _source)

	elseif ketqty == 1 then
		TriggerClientEvent('currentlySelling', _source)
		xPlayer.addAccountMoney('black_money', ketpayment)
		xPlayer.removeInventoryItem('step2', 1)

		TriggerClientEvent("pNotify:SetQueueMax", _source, "gta", 5)
		TriggerClientEvent("pNotify:SendNotification", _source, {
			text = "You have sold 1 vial of ketamine for $" .. ketpayment,
			type = "success",
			progressBar = false,
			queue = "gta",
			timeout = 2000,
			layout = "CenterRight"
		})
		TriggerClientEvent('done', _source)
		TriggerClientEvent('cancel', _source)


	----------------------------------------------------------------------------------
--
--
--
--                         NZT
--
--
----------------------------------------------------------------------------------

	elseif nztqty >= 5 then
		local x2 = math.random(1,5)
		TriggerClientEvent('currentlySelling', _source)
		local nztPay = nztpayment * x2
		xPlayer.addAccountMoney('black_money', nztPay)
		xPlayer.removeInventoryItem('nzt', x2)

		TriggerClientEvent("pNotify:SetQueueMax", _source, "gta", 5)
		TriggerClientEvent("pNotify:SendNotification", _source, {
			text = "You have sold " ..x2.. " capsules of NZT for $" .. nztPay,
			type = "success",
			progressBar = false,
			queue = "gta",
			timeout = 2000,
			layout = "CenterRight"
		})
		TriggerClientEvent('done', _source)
		TriggerClientEvent('cancel', _source)

	elseif nztqty == 4 then
		local x2 = math.random(1,4)
		TriggerClientEvent('currentlySelling', _source)
		local nztPay = nztpayment * x2
		xPlayer.addAccountMoney('black_money', nztPay)
		xPlayer.removeInventoryItem('nzt', x2)

		TriggerClientEvent("pNotify:SetQueueMax", _source, "gta", 5)
		TriggerClientEvent("pNotify:SendNotification", _source, {
			text = "You have sold " ..x2.. " capsules of NZT for $" .. nztPay,
			type = "success",
			progressBar = false,
			queue = "gta",
			timeout = 2000,
			layout = "CenterRight"
		})
		TriggerClientEvent('done', _source)
		TriggerClientEvent('cancel', _source)

	elseif nztqty == 3 then
		local x2 = math.random(1,3)
		TriggerClientEvent('currentlySelling', _source)
		local nztPay = nztpayment * x2
		xPlayer.addAccountMoney('black_money', nztPay)
		xPlayer.removeInventoryItem('nzt', x2)

		TriggerClientEvent("pNotify:SetQueueMax", _source, "gta", 5)
		TriggerClientEvent("pNotify:SendNotification", _source, {
			text = "You have sold " ..x2.. " capsules of NZT for $" .. nztPay,
			type = "success",
			progressBar = false,
			queue = "gta",
			timeout = 2000,
			layout = "CenterRight"
		})
		TriggerClientEvent('done', _source)
		TriggerClientEvent('cancel', _source)

	elseif nztqty == 2 then
		local x2 = math.random(1,2)
		TriggerClientEvent('currentlySelling', _source)
		local nztPay = nztpayment * x2
		xPlayer.addAccountMoney('black_money', nztPay)
		xPlayer.removeInventoryItem('nzt', x2)

		TriggerClientEvent("pNotify:SetQueueMax", _source, "gta", 5)
		TriggerClientEvent("pNotify:SendNotification", _source, {
			text = "You have sold " ..x2.. " capsules of NZT for $"..nztPay,
			type = "success",
			progressBar = false,
			queue = "gta",
			timeout = 2000,
			layout = "CenterRight"
		})
		TriggerClientEvent('done', _source)
		TriggerClientEvent('cancel', _source)

	elseif nztqty == 1 then
		TriggerClientEvent('currentlySelling', _source)
		xPlayer.addAccountMoney('black_money', nztpayment)
		xPlayer.removeInventoryItem('nzt', 1)

		TriggerClientEvent("pNotify:SetQueueMax", _source, "gta", 5)
		TriggerClientEvent("pNotify:SendNotification", _source, {
			text = "You have sold 1 capsule of NZT for $" .. nztpayment,
			type = "success",
			progressBar = false,
			queue = "gta",
			timeout = 2000,
			layout = "CenterRight"
		})
		TriggerClientEvent('done', _source)
		TriggerClientEvent('cancel', _source)

----------------------------------------------------------------------------------
--
--
--
--                         Weed
--
--
----------------------------------------------------------------------------------

	elseif weedqty >= 5 then
		local x3 = math.random(1,5)
		TriggerClientEvent('currentlySelling', _source)
		local weedPay = Weedpayment * x3
		xPlayer.addAccountMoney('black_money', weedPay)
		xPlayer.removeInventoryItem('weed_pooch', x3)

		TriggerClientEvent("pNotify:SetQueueMax", _source, "gta", 5)
		TriggerClientEvent("pNotify:SendNotification", _source, {
			text = "You have sold " ..x3.. " grams of Marijuana for $" .. weedPay,
			type = "success",
			progressBar = false,
			queue = "gta",
			timeout = 2000,
			layout = "CenterRight"
		})
		TriggerClientEvent('done', _source)
		TriggerClientEvent('cancel', _source)

	elseif weedqty == 4 then
		local x3 = math.random(1,4)
		TriggerClientEvent('currentlySelling', _source)
		local weedPay = Weedpayment * x3
		xPlayer.addAccountMoney('black_money', weedPay)
		xPlayer.removeInventoryItem('weed_pooch', x3)

		TriggerClientEvent("pNotify:SetQueueMax", _source, "gta", 5)
		TriggerClientEvent("pNotify:SendNotification", _source, {
			text = "You have sold " ..x3.. " grams of Marijuana for $" .. weedPay,
			type = "success",
			progressBar = false,
			queue = "gta",
			timeout = 2000,
			layout = "CenterRight"
		})
		TriggerClientEvent('done', _source)
		TriggerClientEvent('cancel', _source)

	elseif weedqty == 3 then
		local x3 = math.random(1,3)
		TriggerClientEvent('currentlySelling', _source)
		local weedPay = Weedpayment * x3
		xPlayer.addAccountMoney('black_money', weedPay)
		xPlayer.removeInventoryItem('weed_pooch', x3)

		TriggerClientEvent("pNotify:SetQueueMax", _source, "gta", 5)
		TriggerClientEvent("pNotify:SendNotification", _source, {
			text = "You have sold " ..x3.. " grams of Marijuana for $" .. weedPay,
			type = "success",
			progressBar = false,
			queue = "gta",
			timeout = 2000,
			layout = "CenterRight"
		})
		TriggerClientEvent('done', _source)
		TriggerClientEvent('cancel', _source)

	elseif weedqty == 2 then
		local x3 = math.random(1,2)
		TriggerClientEvent('currentlySelling', _source)
		local weedPay = Weedpayment * x3
		xPlayer.addAccountMoney('black_money', weedPay)
		xPlayer.removeInventoryItem('weed_pooch', x3)

		TriggerClientEvent("pNotify:SetQueueMax", _source, "gta", 5)
		TriggerClientEvent("pNotify:SendNotification", _source, {
			text = "You have sold " ..x3.. " grams of Marijuana for $"..weedPay,
			type = "success",
			progressBar = false,
			queue = "gta",
			timeout = 2000,
			layout = "CenterRight"
		})
		TriggerClientEvent('done', _source)
		TriggerClientEvent('cancel', _source)

	elseif weedqty == 1 then
		TriggerClientEvent('currentlySelling', _source)
		xPlayer.addAccountMoney('black_money', Weedpayment)
		xPlayer.removeInventoryItem('weed_pooch', 1)

		TriggerClientEvent("pNotify:SetQueueMax", _source, "gta", 5)
		TriggerClientEvent("pNotify:SendNotification", _source, {
			text = "You have sold 1 gram of Marijuana for $" .. Weedpayment,
			type = "success",
			progressBar = false,
			queue = "gta",
			timeout = 2000,
			layout = "CenterRight"
		})
		TriggerClientEvent('done', _source)
		TriggerClientEvent('cancel', _source)
----------------------------------------------------------------------------------
--
--
--
--                         HEROIN
--
--
----------------------------------------------------------------------------------

	elseif heroqty >= 5 then
		local x4 = math.random(1,5)
		TriggerClientEvent('currentlySelling', _source)
		local heroPay = Heropayment * x4
		xPlayer.addAccountMoney('black_money', heroPay)
		xPlayer.removeInventoryItem('opium_pooch', x4)

		TriggerClientEvent("pNotify:SetQueueMax", _source, "gta", 5)
		TriggerClientEvent("pNotify:SendNotification", _source, {
			text = "You have sold " ..x4.. " grams of opium for $" .. heroPay,
			type = "success",
			progressBar = false,
			queue = "gta",
			timeout = 2000,
			layout = "CenterRight"
		})
		TriggerClientEvent('done', _source)
		TriggerClientEvent('cancel', _source)

	elseif heroqty == 4 then
		local x4 = math.random(1,4)
		TriggerClientEvent('currentlySelling', _source)
		local heroPay = Heropayment * x4
		xPlayer.addAccountMoney('black_money', heroPay)
		xPlayer.removeInventoryItem('opium_pooch', x4)

		TriggerClientEvent("pNotify:SetQueueMax", _source, "gta", 5)
		TriggerClientEvent("pNotify:SendNotification", _source, {
			text = "You have sold " ..x4.. " grams of opium for $" .. heroPay,
			type = "success",
			progressBar = false,
			queue = "gta",
			timeout = 2000,
			layout = "CenterRight"
		})
		TriggerClientEvent('done', _source)
		TriggerClientEvent('cancel', _source)

	elseif heroqty == 3 then
		local x4 = math.random(1,3)
		TriggerClientEvent('currentlySelling', _source)
		local heroPay = Heropayment * x4
		xPlayer.addAccountMoney('black_money', heroPay)
		xPlayer.removeInventoryItem('opium_pooch', x4)

		TriggerClientEvent("pNotify:SetQueueMax", _source, "gta", 5)
		TriggerClientEvent("pNotify:SendNotification", _source, {
			text = "You have sold " ..x4.. " grams of opium for $" .. heroPay,
			type = "success",
			progressBar = false,
			queue = "gta",
			timeout = 2000,
			layout = "CenterRight"
		})
		TriggerClientEvent('done', _source)
		TriggerClientEvent('cancel', _source)

	elseif heroqty == 2 then
		local x4 = math.random(1,2)
		TriggerClientEvent('currentlySelling', _source)
		local heroPay = Heropayment * x4
		xPlayer.addAccountMoney('black_money', heroPay)
		xPlayer.removeInventoryItem('opium_pooch', x4)

		TriggerClientEvent("pNotify:SetQueueMax", _source, "gta", 5)
		TriggerClientEvent("pNotify:SendNotification", _source, {
			text = "You have sold " ..x4.. " grams of opium for $"..heroPay,
			type = "success",
			progressBar = false,
			queue = "gta",
			timeout = 2000,
			layout = "CenterRight"
		})
		TriggerClientEvent('done', _source)
		TriggerClientEvent('cancel', _source)

	elseif heroqty == 1 then
		TriggerClientEvent('currentlySelling', _source)
		xPlayer.addAccountMoney('black_money', Heropayment)
		xPlayer.removeInventoryItem('opium_pooch', 1)

		TriggerClientEvent("pNotify:SetQueueMax", _source, "gta", 5)
		TriggerClientEvent("pNotify:SendNotification", _source, {
			text = "You have sold 1 gram of opium for $" .. Heropayment,
			type = "success",
			progressBar = false,
			queue = "gta",
			timeout = 2000,
			layout = "CenterRight"
		})
		TriggerClientEvent('done', _source)
		TriggerClientEvent('cancel', _source)
	end
end)

RegisterServerEvent('sell:check')
AddEventHandler('sell:check', function()
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(_source)
	if xPlayer ~= nil then

		local cokeqty = xPlayer.getInventoryItem('coke_pooch').count
		local methqty = xPlayer.getInventoryItem('meth_pooch').count
		local weedqty = xPlayer.getInventoryItem('weed_pooch').count
		--local heroqty = xPlayer.getInventoryItem('opium_pooch').count
		local nztqty = xPlayer.getInventoryItem('nzt').count
		local moonshineqty = xPlayer.getInventoryItem('moonshine').count
		local ketqty = xPlayer.getInventoryItem('step2').count
		if cokeqty > 0 then
			TriggerClientEvent('notify', _source)
		elseif methqty > 0 then
			TriggerClientEvent('notify', _source)
		elseif weedqty > 0 then
			TriggerClientEvent('notify', _source)
		elseif moonshineqty > 0 then
			TriggerClientEvent('notify', _source)
		elseif ketqty > 0 then
			TriggerClientEvent('notify', _source)
		elseif nztqty > 0 then
			TriggerClientEvent('notify', _source)
		end
	end
end)

RegisterServerEvent('drugs:vTake')
AddEventHandler('drugs:vTake', function()
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('viagra', 1)
	TriggerClientEvent('esx:showNotification', _source, "Popped a Viagra")
end)

ESX.RegisterUsableItem('viagra', function(source)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('viagra', 1)
	-- TriggerClientEvent('esx_drugs:onTheV', _source)
end)

ESX.RegisterUsableItem('weed_pooch', function(source)
	local xPlayer  = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('weed_pooch', 1)

	TriggerClientEvent('esx_drugs:onPot', source)
	TriggerClientEvent('esx:showNotification', source, "Used 1 Weed")
end)


ESX.RegisterUsableItem('nzt', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('nzt', 1)

	TriggerClientEvent('esx_drugs:NZT', source)
	TriggerClientEvent('esx:showNotification', source,"Used 1 NZT")
end)

ESX.RegisterUsableItem('moonshine', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('moonshine', 1)
	TriggerClientEvent('drugs:Moonshine', source)
	TriggerClientEvent('esx_status:add', source, 'drunk', 500000)
	TriggerClientEvent('esx_status:add', source, 'hunger', -140000)
	TriggerClientEvent('esx_status:add', source, 'thirst', -140000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	TriggerClientEvent('esx:showNotification', source,"Used 1 Moonshine Jar")
end)
