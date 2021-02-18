


local walkies = {}
local talkers = {}
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('walkie:setChannel')
AddEventHandler('walkie:setChannel', function(channel)
	local exists = false
	local _source = source
	for k,v in pairs(walkies) do
		if v.source == _source then
			exists = true
			v.channel = channel
		end
	end
	if exists == false then
		local t = {source = _source, channel = channel}
		table.insert(walkies, t)
	end
end)


RegisterServerEvent('walkie:setOff')
AddEventHandler('walkie:setOff', function()
	local _source = source
	for k,v in pairs(walkies) do
		if v.source == _source then
			table.remove(walkies, k)
		end
	end
end)


AddEventHandler('playerDropped', function()
	local _source = source
	for k,v in pairs(walkies) do
		if v.source == _source then
			table.remove(walkies, k)
		end
	end
	for k,v in pairs(talkers) do
		if v.talker == _source then
			table.remove(talkers, k)
		end
	end
end)




ESX.RegisterServerCallback('walkie:setTalking', function(source, cb, data)
	local channel = data.channel
	local hasTalker = false
	local _source = source
	for k,v in pairs(talkers) do
		if v.channel == channel then
			hasTalker = true
		end
	end


	if hasTalker then
		cb(false)
	else
		local t = {channel = channel, talker = source}
		table.insert(talkers, t)

		for k,v in pairs(walkies) do
			if v.channel == channel then
				TriggerClientEvent('walkie:setChannelTalker', v.source, _source)
			end
		end
		cb(true)
	end
end)



--[[RegisterServerEvent('walkie:setTalking')
AddEventHandler('walkie:setTalking', function(channel)
	local _source = source
	for k,v in pairs(walkies) do
		if v.channel == channel then
			TriggerClientEvent('walkie:setChannelTalker', v.source, _source)
		end
	end
end)]]--

RegisterServerEvent('walkie:setNotTalking')
AddEventHandler('walkie:setNotTalking', function(channel)
	local _source = source

	for k,v in pairs(talkers) do
		if v.channel == channel then
			table.remove(talkers, k)
		end
	end


	for k,v in pairs(walkies) do
		if v.channel == channel then
			TriggerClientEvent('walkie:removeChannelTalker', v.source, _source)
		end
	end
end)



RegisterServerEvent('walkie:playSoundOnChannel')
AddEventHandler('walkie:playSoundOnChannel', function(channel, sound)
	for k,v in pairs(walkies) do
		if v.channel == channel then
			TriggerClientEvent('walkie:playSound', v.source, sound)
		end
	end
end)