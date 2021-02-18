RegisterServerEvent('chat:init')
RegisterServerEvent('chat:addTemplate')
RegisterServerEvent('chat:addMessage')
RegisterServerEvent('chat:addSuggestion')
RegisterServerEvent('chat:removeSuggestion')
RegisterServerEvent('_chat:messageEntered')
RegisterServerEvent('chat:clear')
RegisterServerEvent('__cfx_internal:commandFallback')
RegisterServerEvent('chat:setTyping')

local playersTyping = {}

AddEventHandler('chat:setTyping', function(state)
	playersTyping[source] = state

	TriggerClientEvent('chat:updateTyping', -1, playersTyping)
end)

AddEventHandler('playerDropped', function(reason)
	if playersTyping[source] then
		playersTyping[source] = nil
		TriggerClientEvent('chat:updateTyping', -1, playersTyping)
	end
end)

AddEventHandler('_chat:messageEntered', function(author, color, message)
	if not message or not author then
		return
	end

	author = sanitize(author)
	message = sanitize(message)

	TriggerEvent('chatMessage', source, author, message)

	if not WasEventCanceled() then
		TriggerClientEvent('chatMessage', -1, author,  { 255, 255, 255 }, message)
	end

	print(author .. ': ' .. message)
end)

AddEventHandler('__cfx_internal:commandFallback', function(command)
	local name = GetPlayerName(source)

	TriggerEvent('chatMessage', source, name, '/' .. command)

	if not WasEventCanceled() then
		TriggerClientEvent('chatMessage', -1, name, { 255, 255, 255 }, '/' .. command)
	end

	CancelEvent()
end)

RegisterCommand('say', function(source, args, rawCommand)
	local name = (source == 0) and 'console' or GetPlayerName(source)

	TriggerClientEvent('chatMessage', -1, name, { 255, 255, 255 }, rawCommand:sub(5))

	if source == 0 then
		print(('%s: %s'):format(name, rawCommand:sub(5)))
	end
end, true)

function sanitize(str)
	local replacements = {
		['&' ] = '&amp;', 
		['<' ] = '&lt;', 
		['>' ] = '&gt;', 
		['\n'] = '<br/>'
	}
	return str
		:gsub('[&<>\n]', replacements)
		:gsub(' +', function(s) return ' '..('&nbsp;'):rep(#s-1) end)
end