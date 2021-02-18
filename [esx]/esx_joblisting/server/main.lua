ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('esx_joblisting:getJobsList', function(source, cb)
	MySQL.Async.fetchAll('SELECT * FROM jobs WHERE whitelisted = @whitelisted', {
		['@whitelisted'] = false
	}, function(result)
		local data = {}

		for i=1, #result, 1 do
			table.insert(data, {
				job   = result[i].name,
				label = result[i].label
			})
		end

		cb(data)
	end)
end)

RegisterServerEvent('esx_joblisting:setJob')
AddEventHandler('esx_joblisting:setJob', function(job)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if not xPlayer then
		return
	end

	MySQL.Async.fetchAll('SELECT whitelisted FROM jobs WHERE name = @name', {
		['@name'] = job,
	}, function(result)
		if not result[1].whitelisted then
			xPlayer.setJob(job, 0)
		else
			local date = os.date('%Y-%m-%d %H:%M')
			local identifier = GetPlayerIdentifiers(source)[1]
			local message = (('esx_joblisting: player attempted to run event :setJob with whitelisted job argument!\n\nSource: %s | %s\nTime & Day: %s'):format(source, identifier, date))
			print(message)
		
			TriggerEvent('adrp_anticheat:cheaterDetected', message)
			TriggerEvent('adrp_anticheat:banCheater', source)
		end
	end)
end)
