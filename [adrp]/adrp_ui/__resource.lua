resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ADRP UI'

version '1.1.0'

client_scripts {
	'client.lua',
	'voice.lua'
}

ui_page 'html/ui.html'

files {
	'html/ui.html',
	'html/style.css',
	'html/grid.css',
	'html/main.js',

	'html/img/credit-card.png',
	'html/img/money-bag.png',
	'html/img/wallet.png',
	'html/img/society.png',
	'html/img/jail.png',

	'html/img/jobs/ambulance.png',
	'html/img/jobs/banker.png',
	'html/img/jobs/securoserv.png',

	'html/img/jobs/cardealer.png',
	'html/img/jobs/detective.png',
	'html/img/jobs/fisherman.png',
	'html/img/jobs/fuel.png',
	'html/img/jobs/garbage.png',
	'html/img/jobs/heli.png',
	'html/img/jobs/lumberjack.png',
	'html/img/jobs/mecano.png',
	'html/img/jobs/miner.png',
	'html/img/jobs/state.png',
	'html/img/jobs/pizza.png',
	'html/img/jobs/police.png',
	'html/img/jobs/realestateagent.png',
	'html/img/jobs/sheriff.png',
	'html/img/jobs/slaughterer.png',
	'html/img/jobs/swat.png',
	'html/img/jobs/tailor.png',
	'html/img/jobs/taxi.png',
	'html/img/jobs/textil.png',
	'html/img/jobs/trucker.png',
	'html/img/jobs/unemployed.png',
	'html/img/jobs/unicorn.png',
	'html/img/jobs/fib.png',
	'html/img/jobs/dod.png',
	'html/img/jobs/doj.png',
	'html/img/jobs/usmarshal.png',

	'html/img/gangs/armsdealer.png',
	'html/img/gangs/company.png',
	'html/img/gangs/dondadda.png',
	'html/img/gangs/los.png',
	'html/img/gangs/lostmc.png',
	'html/img/gangs/lostmotors.png',
	'html/img/gangs/nogang.png',
	'html/img/gangs/oconnor.png',
	'html/img/gangs/redlinecrew.png',
	'html/img/gangs/volt.png',
	'html/img/gangs/liberty.png',
	'html/img/gangs/ballas.png',

	'html/img/vehicle/damage.png',
	'html/img/vehicle/gas.png',
	'html/img/vehicle/speed.png',
	'html/img/vehicle/locked.png',
	'html/img/vehicle/unlocked.png',

	'html/img/hunger.png',
	'html/img/water.png',
	'html/img/speaker1.png',
	'html/img/speaker2.png',
	'html/img/speaker3.png',
	'html/img/backpack.png',
	'html/img/drunk.png',
	'html/img/oxygen.png'
}

dependency 'es_extended'