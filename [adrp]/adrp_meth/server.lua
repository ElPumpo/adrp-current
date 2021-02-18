ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local MinCashReward = 5000
local MaxCashReward = 10000
local MinMethReward = 10
local MaxMethReward = 50

local Police = {}
local PoliceCount = 0

function RewardPlayers(playerA, PlayerB)
	local xPlayer = ESX.GetPlayerFromId(playerA)
	xPlayer.addAccountMoney('black_money', math.random(MinCashReward, MaxCashReward))
	xPlayer.addInventoryItem('meth', math.random(MinMethReward, MaxMethReward))
	local xPlayer = ESX.GetPlayerFromId(playerB)
	xPlayer.addAccountMoney('black_money', math.random(MinCashReward, MaxCashReward))
	xPlayer.addInventoryItem('meth', math.random(MinMethReward, MaxMethReward))
end

function NotifyPolice(pos)
	for k,v in pairs(Police) do
		TriggerClientEvent('adrp_meth:NotifyCops', v, pos)
	end
end

function PlayerDropped(source)
	local fullName = xPlayer.name
	MySQL.Async.fetcalAll('SELECT 1 FROM characters where fullname=@fullname', {['@fullname'] = fullName}, function(data)
		if data and data[1] and data[1].job then
			if data[1].job == 'police' then
				PoliceCount = PoliceCount - 1
				for k,v in pairs(Police) do
					if v == source then
						Police[k] = nil
					end
				end
			end
		end
	end)
end

function JoinPoliceOnJoin(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local job = xPlayer.getJob()
	if job and job.name == 'police' then
		table.insert(Police, source)
		PoliceCount = PoliceCount + 1
	end
end

function RemovePolice(source)
	for k,v in pairs(Police) do
		if v == source then
			Police[k] = nil
			PoliceCount = math.max(PoliceCount - 1, 0)
		end
	end
end

function JoinPolice(source)
	table.insert( Police, source)
	PoliceCount = PoliceCount + 1
end

ESX.RegisterServerCallback('adrp_meth:GetPolice', function(source, cb)
	cb(PoliceCount)
end)

RegisterNetEvent('adrp_meth:RemovePolice')
AddEventHandler('adrp_meth:RemovePolice', function()
	RemovePolice()
end)

RegisterNetEvent('adrp_meth:AddPolice')
AddEventHandler('adrp_meth:AddPolice', function()
	JoinPolice()
end)

RegisterNetEvent('adrp_meth:BeginCooking')
AddEventHandler('adrp_meth:BeginCooking', function(target)
	print(target)
	print(source)
	TriggerClientEvent('adrp_meth:BeginCooking', target, source)
end)

RegisterNetEvent('adrp_meth:FinishCook')
AddEventHandler('adrp_meth:FinishCook', function(target, result, msg)
	TriggerClientEvent('adrp_meth:FinishCook', target, result, msg)
end)

RegisterNetEvent('adrp_meth:SyncSmoke')
AddEventHandler('adrp_meth:SyncSmoke', function(netId)
	TriggerClientEvent('adrp_meth:SyncSmoke', -1, netId)
end)

RegisterNetEvent('adrp_meth:NotifyPolice')
AddEventHandler('adrp_meth:NotifyPolice', function(loc)
	Citizen.CreateThread(function()
		NotifyPolice(loc)
	end)
end)

RegisterNetEvent('adrp_meth:RemoveTruck')
AddEventHandler('adrp_meth:RemoveTruck', function(netId)
	TriggerClientEvent('adrp_meth:RemoveSmoke', -1, netId)
end)

RegisterNetEvent('adrp_meth:RewardPlayers')
AddEventHandler('adrp_meth:RewardPlayers', function(driver)
	RewardPlayers(source, driver)
end)

