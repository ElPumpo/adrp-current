local configminutes = 10
local prefix = "^1[Server Message]^7"
local suffix = "^7"
local announcements = {
	"Use ^1/ooc^7 for out of character conversations, ^1'K'^7 will access MOST the menus you need and ^1LeftAlt^7 accesses any job menus",
	"Apply for Police, EMS, or Public Works at www.^1American^7Dream^4RP^7.com",
	"Comfortable, soft, clean design merch now available (^1Limited supply!^7) @ www.^1American^7Dream^4RP^7.com",
	"This is an RP server, not a GTA Online server",
	"Go out and make some friends! This isn't a money simulator",
	"Ask all questions on the ADRP Discord Help Desk Channel: discord.io/ADRP",
	"Do not spam ^1/ooc^7 with RDM reports, use ^1/report^7 instead"
}

local count = 0
for _ in pairs(announcements) do count = count + 1 end

local timeout = configminutes * 60000
local i = 1

Citizen.CreateThread(function()
	Citizen.Wait(2000)

	while true do
		TriggerEvent('chatMessage', '', { 255, 0, 0 }, prefix .. " " .. announcements[i] .. suffix)
		i = i + 1

		if (i ==(count + 1)) then i = 1 end

		Citizen.Wait(timeout)
	end
end)