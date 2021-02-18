Config2 = {}

Config2.Zones = {
	CokeFarm      = {location = vector3(-2952.5, 50.6, 11.6), label = '~o~Farm Coke~s~', item = 'coke', required = nil, required_count = 1, time = 10},
	CokeTreatment = {location = vector3(1100.6, -3195.9, -38.9), label = '~o~Process Coke~s~', item = 'coke_pooch', required = 'coke', required_count = 5, time = 15},

	MethCollect = {location = vector3(1602.5, 6622.6, 15.6), label = '~o~Farm Meth~s~', item = 'meth', required = nil, required_count = 1, time = 10},
	MethProcess = {location = vector3(1004.7, -3198.3, -38.9), label = '~o~Process Meth~s~', item = 'meth_pooch', required = 'meth', required_count = 5, time = 15},

	ShineCollect = {location = vector3(1988.1, 5023.6, 41.0), label = '~o~Farm Moonshine~s~', item = 'corn', required = nil, required_count = 1, time = 3},
	ShineProcess = {location = vector3(125.3, -1182.1, 29.5), label = '~o~Process Moonshine~s~', item = 'moonshine', required = 'corn', required_count = 5, time = 5},

}

Config2.WhitelistedDrugs = {
	NZTCollect = {location = vector3(-7304.3, 4205.8, 2.8), label = '~o~Farm NZT~s~', item = 'alphagpc', required = nil, required_count = 5, time = 5},
	NZTProcess = {location = vector3(-7296.2, 4199.5, 2.9), label = '~o~Process NZT~s~', item = 'nzt', required = 'alphagpc', required_count = 1, time = 1},

	CompanyCollect = {location = vector3(3537.3, 3666.8, 28.1), label = '~o~Farm Chlorophenyl~s~', item = 'step1', required = nil, required_count = 1, time = 2},
	CompanyProcess = {location = vector3(330.9, 4827.4, -59.6), label = '~o~Process Chlorophenyl into Ketamine~s~', item = 'step2', required = 'step1', required_count = 5, time = 5}
}
