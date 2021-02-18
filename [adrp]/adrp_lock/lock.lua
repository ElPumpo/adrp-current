AddEventHandler('playerConnecting', function(name, setCallback, deferrals)
	deferrals.defer()

	deferrals.done("You're early to the party, the server is locked.\n\nQ: Locked?!?!\nA: The server was recently started and is still booting up. If the server crashed then it will take extra time to sync up all characters to the database hive. Please be patient.")
	print('adrp_lock: remember that the server is still locked. Use command ^1/stop adrp_lock^7 to unlock server.')
end)