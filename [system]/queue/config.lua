Config = {}

-- Waiting time for antispam
Config.AntiSpamTimer = 2

-- Verification and allocation of a free place
Config.TimerCheckPlaces = 3

-- Update of the message (emojis) and access to the free place for the lucky one
Config.TimerRefreshClient = 3

-- Number of points updating
Config.TimerUpdatePoints = 6

-- Number of points earned for those who are waiting
Config.AddPoints = 1

-- Number of points lost for those who entered the server
Config.RemovePoints = 1

-- Number of points earned for those who have 3 identical emojis (lottery)
Config.LoterieBonusPoints = 25

-- If steam is not detected
Config.NoSteam = "Steam is not started. Start steam, then restart FiveM and reconnect!"
	
-- "points" for RP purpose
Config.PointsRP = "miles"

-- position in the queue
Config.Position = "You are in position "

-- Text before emojis
Config.EmojiMsg = "If the emojis are frozen, restart your client: "

-- When the player win the lottery
Config.EmojiBoost = "!!! Yippee, " .. Config.LoterieBonusPoints .. " " .. Config.PointsRP .. " won !!!"

-- Should never be displayed
Config.Accident = "Oops, you just had an accident ... If it happens again, you should contact ADRP :/"

-- In case of negative points
Config.Error = "ERROR: CONTACT ADRP STAFF! (QUEUE NEEDS RESTART)"

Config.EmojiList = {
	'🐌',
	'🐍',
	'🐎',
	'🐑',
	'🐒',
	'🐘',
	'🐙',
	'🐛',
	'🐜',
	'🐝',
	'🐞',
	'🐟',
	'🐠',
	'🐡',
	'🐢',
	'🐤',
	'🐦',
	'🐧',
	'🐩',
	'🐫',
	'🐬',
	'🐲',
	'🐳',
	'🐴',
	'🐅',
	'🐈',
	'🐉',
	'🐋',
	'🐀',
	'🐇',
	'🐏',
	'🐐',
	'🐓',
	'🐕',
	'🐖',
	'🐪',
	'🐆',
	'🐄',
	'🐃',
	'🐂',
	'🐁',
	'🔥'
}
