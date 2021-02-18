local chatInputActive = false
local chatInputActivating = false
local chatEnabled = true

RegisterNetEvent('chatMessage')
RegisterNetEvent('chat:addTemplate')
RegisterNetEvent('chat:removeTemplate')
RegisterNetEvent('chat:addMessage')
RegisterNetEvent('chat:addSuggestion')
RegisterNetEvent('chat:removeSuggestion')
RegisterNetEvent('chat:clear')
RegisterNetEvent('chat:updateTyping')

-- internal events
RegisterNetEvent('__cfx_internal:serverPrint')

RegisterNetEvent('_chat:messageEntered')

RegisterCommand('togglechat', function()
	if chatEnabled then
		TriggerEvent('chat:addMessage', { args = { '^1SYSTEM', 'Chat has been disabled.' } })
		chatEnabled = false
	else
		chatEnabled = true
		TriggerEvent('chat:addMessage', { args = { '^1SYSTEM', 'Chat has been enabled.' } })
	end
end, false)

Citizen.CreateThread(function()
	TriggerEvent('chat:addSuggestion', '/togglechat', 'Toggle the chat')
end)

AddEventHandler('chat:cancelChatMessage', function()
	if not chatEnabled then
		CancelEvent()
	end
end)

--deprecated, use chat:addMessage
AddEventHandler('chatMessage', function(author, color, text)
	TriggerEvent('chat:cancelChatMessage')

	if not WasEventCanceled() then

		author = sanitize(author)
		text = sanitize(text)

		local args = { text }

		if author ~= "" then
			table.insert(args, 1, author)
		end
	
		SendNUIMessage({
			type = 'ON_MESSAGE',
			message = {
				color = color,
				multiline = true,
				args = args
			}
		})
	end
end)

AddEventHandler('__cfx_internal:serverPrint', function(msg)
	print(msg)

	SendNUIMessage({
		type = 'ON_MESSAGE',
		message = {
			multiline = true,
			args = { msg }
		}
	})
end)

AddEventHandler('chat:addMessage', function(message)
	for k,v in pairs(message.args) do
		message.args[k] = sanitize(v)
	end

	TriggerEvent('chat:cancelChatMessage')

	if not WasEventCanceled() then
		SendNUIMessage({
			type = 'ON_MESSAGE',
			message = message
		})
	end
end)

AddEventHandler('chat:addSuggestion', function(name, help, params)
	SendNUIMessage({
		type = 'ON_SUGGESTION_ADD',
		suggestion = {
			name = name,
			help = help,
			params = params or nil
		}
	})
end)

AddEventHandler('chat:removeSuggestion', function(name)
	SendNUIMessage({
		type = 'ON_SUGGESTION_REMOVE',
		name = name
	})
end)

AddEventHandler('chat:addTemplate', function(id, html)
	SendNUIMessage({
		type = 'ON_TEMPLATE_ADD',
		template = {
			id = id,
			html = html
		}
	})
end)

AddEventHandler('chat:removeTemplate', function(id)
	SendNUIMessage({
		type = 'ON_TEMPLATE_REMOVE',
		template = {
			id = id
		}
	})
end)

AddEventHandler('chat:clear', function()
	SendNUIMessage({
		type = 'ON_CLEAR'
	})
end)

RegisterNUICallback('chatResult', function(data, cb)
	chatInputActive = false
	TriggerServerEvent('chat:setTyping', false)
	SetNuiFocus(false)

	if not data.canceled then
		local id = PlayerId()

		--deprecated
		local r, g, b = 0, 0x99, 255

		if data.message:sub(1, 1) == '/' then
			ExecuteCommand(data.message:sub(2))
		else
			TriggerServerEvent('_chat:messageEntered', GetPlayerName(id), { r, g, b }, data.message)
		end

		TriggerServerEvent('_chat:networkMessage', data.message)
	end

	cb('ok')
end)

RegisterNUICallback('loaded', function(data, cb)
	TriggerServerEvent('chat:init')

	cb('ok')
end)

Citizen.CreateThread(function()
	SetTextChatEnabled(false)
	SetNuiFocus(false)

	while true do
		Citizen.Wait(0)

		if not chatInputActive then
			if IsControlPressed(0, 245) then
				chatInputActive = true
				chatInputActivating = true

				TriggerServerEvent('chat:setTyping', true)

				SendNUIMessage({
					type = 'ON_OPEN'
				})
			end
		end

		if chatInputActivating then
			if not IsControlPressed(0, 245) then
				SetNuiFocus(true)

				chatInputActivating = false
			end
		end
	end
end)

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