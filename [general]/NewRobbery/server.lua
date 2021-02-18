

RegisterServerEvent("vault:syncOpenServer")
AddEventHandler("vault:syncOpenServer", function()
	TriggerClientEvent("vault:syncOpen", -1)
end)

RegisterServerEvent("vault:syncCloseServer")
AddEventHandler("vault:syncCloseServer", function()
	TriggerClientEvent("vault:syncClose", -1)
end)

