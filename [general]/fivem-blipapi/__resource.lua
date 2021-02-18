resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

name 'Blip Info Utility'
author 'glitchdetector'
contact 'glitchdetector@gmail.com'
version '1.0.0'

description 'Enables the ability to assign extra information for blips, visible when hovering over them in the pause menu map'

usage [[
	exports['fivem-blipapi']:ResetBlipInfo(blip)
	exports['fivem-blipapi']:SetBlipInfo(blip, infoData)
	exports['fivem-blipapi']:SetBlipInfoTitle(blip, title, rockstarVerified)
	exports['fivem-blipapi']:SetBlipInfoImage(blip, dict, tex)
	exports['fivem-blipapi']:SetBlipInfoEconomy(blip, rp, money)
	exports['fivem-blipapi']:AddBlipInfoText(blip, leftText, rightText)
	exports['fivem-blipapi']:AddBlipInfoName(blip, leftText, rightText)
	exports['fivem-blipapi']:AddBlipInfoHeader(blip, leftText, rightText)
	exports['fivem-blipapi']:AddBlipInfoIcon(blip, leftText, rightText, iconId, iconColor, checked)
]]

client_script 'client.lua'

exports {
	'ResetBlipInfo',
	'SetBlipInfo',
	'SetBlipInfoTitle',
	'SetBlipInfoImage',
	'SetBlipInfoEconomy',
	'AddBlipInfoText',
	'AddBlipInfoName',
	'AddBlipInfoHeader',
	'AddBlipInfoIcon'
}
