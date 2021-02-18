RegisterNetEvent('adrp:openAnimationMenu')
AddEventHandler('adrp:openAnimationMenu', function()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_actions', {
		title    = 'Animation List',
		align    = 'bottom-right',
		elements = {
			{label = 'Cancel animation', value = 'cancel'},
			{label = 'Scenarios', value = 'scenarios'},
			{label = 'Scenarios 2', value = 'scenarios2'},
			{label = 'Scenarios 3', value = 'scenarios3'},
			{label = 'Job Scenarios', value = 'scenarios4'},
			{label = 'Friendly', value = 'friendly'},
			{label = 'Male Dances', value = 'maledances'},
			{label = 'Female Dances', value = 'femaledances'},
			{label = 'Sit', value = 'sitting'},
			{label = 'Sleep', value = 'sleeping'},
			{label = 'Fitness', value = 'fitness'},
			{label = 'Walking Styles', value = 'menuperso_actions_walking'}
		}}, function(data2, menu2)
			if data2.current.value == 'scenarios' then
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'scenarios', {
					title    = 'Scenarios',
					align    = 'bottom-right',
					elements = {
						{label = 'Binoculars', value = 'binoculars'},
						{label = 'Slumped', value = 'slumped'},
						{label = 'Bummed', value = 'bummed'},
						{label = 'Cheering', value = 'cheering'},
						{label = 'Drinking', value = 'drinking'},
						{label = 'Use Map', value = 'map'},
						{label = 'Take Picture', value = 'picture'},
						{label = 'Record', value = 'record'},
						{label = 'Guard Idles', value = 'guard'},
						{label = 'Hang Out', value = 'hangout'},
						{label = 'Smoking', value = 'smoke'},
						{label = 'Smoking Reefer', value = 'smokepot'},
				}}, function(data3, menu3)
					if data3.current.value == 'binoculars' then
						animsActionScenario({anim = 'WORLD_HUMAN_BINOCULARS'})
					elseif data3.current.value == 'slumped' then
						animsActionScenario({anim = 'WORLD_HUMAN_BUM_SLUMPED'})
					elseif data3.current.value == 'bummed' then
						animsActionScenario({anim = 'WORLD_HUMAN_BUM_STANDING'})
					elseif data3.current.value == 'cheering' then
						animsActionScenario({anim = 'WORLD_HUMAN_CHEERING'})
					elseif data3.current.value == 'drinking' then
						animsActionScenario({anim = 'WORLD_HUMAN_DRINKING'})
					elseif data3.current.value == 'map' then
						animsActionScenario({anim = 'WORLD_HUMAN_TOURIST_MAP'})
					elseif data3.current.value == 'picture' then
						animsActionScenario({anim = 'WORLD_HUMAN_TOURIST_MOBILE'})
					elseif data3.current.value == 'record' then
						animsActionScenario({anim = 'WORLD_HUMAN_MOBILE_FILM_SHOCKING'})
					elseif data3.current.value == 'guard' then
						animsActionScenario({anim = 'WORLD_HUMAN_GUARD_STAND'})
					elseif data3.current.value == 'hangout' then
						animsActionScenario({anim = 'WORLD_HUMAN_HANG_OUT_STREET'})
					elseif data3.current.value == 'smoke' then
						animsActionScenario({anim = 'WORLD_HUMAN_SMOKING'})
					elseif data3.current.value == 'smokepot' then
						animsActionScenario({anim = 'WORLD_HUMAN_SMOKING_POT'})
					end
				end, function(data3, menu3)
					menu3.close()
				end)
			elseif data2.current.value == 'scenarios2' then
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'scenarios2', {
					title    = 'Scenarios 2',
					align    = 'bottom-right',
					elements = {
						{label = 'Sunbathe', value = 'sunbathe'},
						{label = 'Sunbathe on Back', value = 'sunbatheback'},
						{label = 'Leaning', value = 'leaning'},
						{label = 'Cleaning', value = 'cleaning'},
						{label = 'Partying', value = 'partying'},
						{label = 'High Class', value = 'highclass'},
						{label = 'Low Class', value = 'lowclass'},
						{label = 'Impatient', value = 'impatient'},
						{label = 'Impatient 2', value = 'impatient2'},
						{label = 'Impatient 3', value = 'impatient3'},
				}}, function(data3, menu3)
					if data3.current.value == 'sunbathe' then
						animsActionScenario({anim = 'WORLD_HUMAN_SUNBATHE'})
					elseif data3.current.value == 'sunbatheback' then
						animsActionScenario({anim = 'WORLD_HUMAN_SUNBATHE_BACK'})
					elseif data3.current.value == 'leaning' then
						animsActionScenario({anim = 'WORLD_HUMAN_LEANING'})
					elseif data3.current.value == 'cleaning' then
						animsActionScenario({anim = 'WORLD_HUMAN_MAID_CLEAN'})
					elseif data3.current.value == 'partying' then
						animsActionScenario({anim = 'WORLD_HUMAN_PARTYING'})
					elseif data3.current.value == 'highclass' then
						animsActionScenario({anim = 'WORLD_HUMAN_PROSTITUTE_HIGH_CLASS'})
					elseif data3.current.value == 'lowclass' then
						animsActionScenario({anim = 'WORLD_HUMAN_PROSTITUTE_LOW_CLASS'})
					elseif data3.current.value == 'impatient' then
						animsActionScenario({anim = 'WORLD_HUMAN_STAND_IMPATIENT'})
					elseif data3.current.value == 'impatient2' then
						animsActionScenario({anim = 'WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT'})
					elseif data3.current.value == 'impatient3' then
						animsActionScenario({anim = 'PROP_HUMAN_STAND_IMPATIENT'})
					end
				end, function(data3, menu3)
					menu3.close()
				end)
			elseif data2.current.value == 'scenarios3' then
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'scenarios3', {
					title    = 'Scenarios 3',
					align    = 'bottom-right',
					elements = {
						{label = 'Bum Rail', value = 'bumrail'},
						{label = 'Human Statue', value = 'humanstatue'},
						{label = 'Bum Freeway', value = 'bumfreeway'},
						{label = 'Bum Standing', value = 'bumstanding'},
						{label = 'Bum Wash', value = 'bumwash'},
				}}, function(data3, menu3)
					if data3.current.value == 'bumrail' then
						animsActionScenario({anim = 'PROP_HUMAN_BUM_SHOPPING_CART'})
					elseif data3.current.value == 'humanstatue' then
						animsActionScenario({anim = 'WORLD_HUMAN_HUMAN_STATUE'})
					elseif data3.current.value == 'bumfreeway' then
						animsActionScenario({anim = 'WORLD_HUMAN_BUM_FREEWAY'})
					elseif data3.current.value == 'bumstanding' then
						animsActionScenario({anim = 'WORLD_HUMAN_BUM_STANDING'})
					elseif data3.current.value == 'bumwash' then
						animsActionScenario({anim = 'WORLD_HUMAN_BUM_WASH'})
					end
				end, function(data3, menu3)
					menu3.close()
				end)
			elseif data2.current.value == 'scenarios4' then
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'scenarios4', {
					title    = 'Job Scenarios',
					align    = 'bottom-right',
					elements = {
						{label = 'Cop Idles', value = 'copemote'},
						{label = 'Write on Notepad', value = 'notepad'},
						{label = 'Drilling', value = 'drilling'},
						{label = 'Hammering', value = 'hammering'},
						{label = 'Welding', value = 'welding'},
						{label = 'Fishing', value = 'fishing'},
						{label = 'Janitor', value = 'janitor'},
						{label = 'Gardener', value = 'gardener'},
				}}, function(data3, menu3)
					if data3.current.value == 'copemote' then
						animsActionScenario({anim = 'WORLD_HUMAN_COP_IDLES'})
					elseif data3.current.value == 'notepad' then
						animsActionScenario({anim = 'CODE_HUMAN_MEDIC_TIME_OF_DEATH'})
					elseif data3.current.value == 'drilling' then
						animsActionScenario({anim = 'WORLD_HUMAN_CONST_DRILL'})
					elseif data3.current.value == 'hammering' then
						animsActionScenario({anim = 'WORLD_HUMAN_HAMMERING'})
					elseif data3.current.value == 'welding' then
						animsActionScenario({anim = 'WORLD_HUMAN_WELDING'})
					elseif data3.current.value == 'fishing' then
						animsActionScenario({anim = 'WORLD_HUMAN_STAND_FISHING'})
					elseif data3.current.value == 'janitor' then
						animsActionScenario({anim = 'WORLD_HUMAN_JANITOR'})
					elseif data3.current.value == 'gardener' then
						animsActionScenario({anim = 'WORLD_HUMAN_GARDENER_PLANT'})
					end
				end, function(data3, menu3)
					menu3.close()
				end)
			elseif data2.current.value == 'friendly' then
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'friendly', {
					title    = 'Friendly',
					align    = 'bottom-right',
					elements = {
						{label = 'Salute', value = 'saulte'},
						{label = 'Wave 1', value = 'wave1'},
						{label = 'Wave 2', value = 'wave2'},
						{label = 'Hug 1',  value = 'hug1'},
						{label = 'Hug 2',  value = 'hug2'},
						{label = 'Kiss 1', value = 'kiss1'},
						{label = 'Kiss 2', value = 'kiss2'},
						{label = 'Pet dog', value = 'petdog'},
				}}, function(data3, menu3)
					if data3.current.value == 'salute' then
						halfanimPlayer('mp_player_int_uppersalute', 'mp_player_int_salute')
					elseif data3.current.value == 'wave1' then
						halfanimPlayer('random@car_thief@victimpoints_ig_3', 'arms_waving')
					elseif data3.current.value == 'wave2' then
						halfanimPlayer('random@gang_intimidation@', '001445_01_gangintimidation_1_female_idle_b')
					elseif data3.current.value == 'hug1' then
						animPlayer('mp_ped_interaction', 'hugs_guy_a')
					elseif data3.current.value == 'hug2' then
						animPlayer('mp_ped_interaction', 'hugs_guy_b')
					elseif data3.current.value == 'kiss1' then
						animPlayer('mp_ped_interaction', 'kisses_guy_a')
					elseif data3.current.value == 'kiss2' then
						animPlayer('mp_ped_interaction', 'kisses_guy_b')
					elseif data3.current.value == 'petdog' then
						animPlayer('creatures@rottweiler@tricks@', 'petting_franklin')
					end
				end, function(data3, menu3)
					menu3.close()
				end)
			elseif data2.current.value == 'maledances' then
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'maledances', {
					title    = 'Male Dances',
					align    = 'bottom-right',
					elements = {
						{label = 'Dance 1', value = 'dance1'},
						{label = 'Dance 2', value = 'dance2'},
						{label = 'Dance 3', value = 'dance3'},
						{label = 'Dance 4', value = 'dance4'},
						{label = 'Dance 5', animType = 'anim', data = {lib = 'anim@amb@nightclub@dancers@club_ambientpeds@med-hi_intensity', anim = 'mi-hi_amb_club_10_v1_male^6'}},
						{label = 'Dance 6', animType = 'anim', data = {lib = 'amb@code_human_in_car_mp_actions@dance@bodhi@ds@base', anim = 'idle_a_fp'}},
						{label = 'Dance 7', animType = 'anim', data = {lib = 'amb@code_human_in_car_mp_actions@dance@bodhi@rds@base', anim = 'idle_b'}},
						{label = 'Dance 8', animType = 'anim', data = {lib = 'amb@code_human_in_car_mp_actions@dance@std@ds@base', anim = 'idle_a'}},
						{label = 'Dance 9', animType = 'anim', data = {lib = 'anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity', anim = 'hi_dance_facedj_09_v2_male^6'}},
						{label = 'Dance 10', animType = 'anim', data = {lib = 'anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity', anim = 'li_dance_facedj_09_v1_male^6'}},
						{label = 'Dance 11', animType = 'anim', data = {lib = 'anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity', anim = 'trans_dance_facedj_hi_to_li_09_v1_male^6'}},
						{label = 'Dance 12', animType = 'anim', data = {lib = 'anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity', anim = 'trans_dance_facedj_li_to_hi_07_v1_male^6'}},
						{label = 'Dance 13', animType = 'anim', data = {lib = 'anim@amb@nightclub@dancers@crowddance_groups@hi_intensity', anim = 'hi_dance_crowd_13_v2_male^6'}},
						{label = 'Dance 14', animType = 'anim', data = {lib = 'anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity', anim = 'trans_dance_crowd_hi_to_li__07_v1_male^6'}},
						{label = 'Dance 15', animType = 'anim', data = {lib = 'anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity', anim = 'hi_dance_prop_13_v1_male^6'}},
						{label = 'Dance 16', animType = 'anim', data = {lib = 'anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity', anim = 'trans_crowd_prop_mi_to_li_11_v1_male^6'}},
						{label = 'Dance 17', animType = 'anim', data = {lib = 'anim@amb@nightclub@mini@dance@dance_solo@male@var_a@', anim = 'med_center_up'}},
						{label = 'Dance 18', animType = 'anim', data = {lib = 'anim@amb@nightclub@mini@dance@dance_solo@male@var_a@', anim = 'med_right_up'}},
						{label = 'Dance 19', animType = 'anim', data = {lib = 'anim@amb@nightclub@dancers@crowddance_groups@low_intensity', anim = 'li_dance_crowd_17_v1_male^6'}},
						{label = 'Dance 20', animType = 'anim', data = {lib = 'anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity', anim = 'trans_dance_facedj_mi_to_li_09_v1_male^6'}},
						{label = 'Dance 21', animType = 'anim', data = {lib = 'timetable@tracy@ig_5@idle_b', anim = 'idle_e'}},
						{label = 'Dance 22', animType = 'anim', data = {lib = 'mini@strip_club@idles@dj@idle_04', anim = 'idle_04'}},
						{label = 'Dance 23', animType = 'anim', data = {lib = 'special_ped@mountain_dancer@monologue_1@monologue_1a', anim = 'mtn_dnc_if_you_want_to_get_to_heaven'}},
						{label = 'Dance 24', animType = 'anim', data = {lib = 'special_ped@mountain_dancer@monologue_4@monologue_4a', anim = 'mnt_dnc_verse'}},
						{label = 'Dance 25', animType = 'anim', data = {lib = 'special_ped@mountain_dancer@monologue_3@monologue_3a', anim = 'mnt_dnc_buttwag'}},
						{label = 'Dance 26', animType = 'anim', data = {lib = 'anim@amb@nightclub@dancers@black_madonna_entourage@', anim = 'hi_dance_facedj_09_v2_male^5'}},
						{label = 'Dance 27', animType = 'anim', data = {lib = 'anim@amb@nightclub@dancers@crowddance_single_props@', anim = 'hi_dance_prop_09_v1_male^6'}},
						{label = 'Dance 28', animType = 'anim', data = {lib = 'anim@amb@nightclub@dancers@dixon_entourage@', anim = 'mi_dance_facedj_15_v1_male^4'}},
						{label = 'Dance 29', animType = 'anim', data = {lib = 'anim@amb@nightclub@dancers@podium_dancers@', anim = 'hi_dance_facedj_17_v2_male^5'}},
						{label = 'Dance 30', animType = 'anim', data = {lib = 'anim@amb@nightclub@dancers@tale_of_us_entourage@', anim = 'mi_dance_prop_13_v2_male^4'}},
						{label = 'Dance 31', animType = 'anim', data = {lib = 'misschinese2_crystalmazemcs1_cs', anim = 'dance_loop_tao'}},
						{label = 'Dance 32', animType = 'anim', data = {lib = 'misschinese2_crystalmazemcs1_ig', anim = 'dance_loop_tao'}},
						{label = 'Dance 33', animType = 'anim', data = {lib = 'anim@mp_player_intcelebrationmale@cats_cradle', anim = 'cats_cradle'}},
						{label = 'Dance 34', animType = 'anim', data = {lib = 'anim@mp_player_intupperbanging_tunes', anim = 'idle_a'}},
						{label = 'Dance 35', animType = 'anim', data = {lib = 'anim@amb@nightclub@mini@dance@dance_solo@male@var_b@', anim = 'high_center'}},
						{label = 'Dance 36', animType = 'anim', data = {lib = 'anim@amb@nightclub@lazlow@hi_podium@', anim = 'danceidle_hi_06_base_laz'}},
						{label = 'Dance 37', animType = 'anim', data = {lib = 'special_ped@zombie@monologue_4@monologue_4l', anim = 'iamtheundead_11'}},
				}}, function(data3, menu3)
					if data3.current.animType then
						local animType = data3.current.animType
						local lib  = data3.current.data.lib
						local anim = data3.current.data.anim

						if animType == 'scenario' then
							startScenario(anim)
						elseif animType == 'attitude' then
							startAttitude(lib, anim)
						elseif animType == 'anim' then
							startAnim(lib, anim)
						end
					else
						if data3.current.value == 'dance1' then
							halfanimPlayer('misschinese2_crystalmazemcs1_cs', 'dance_loop_tao')
						elseif data3.current.value == 'dance2' then
							animPlayer('move_clown@p_m_two_idles@', 'fidget_short_dance')
						elseif data3.current.value == 'dance3' then
							animPlayer('special_ped@mountain_dancer@monologue_3@monologue_3a', 'mnt_dnc_buttwag')
						elseif data3.current.value == 'dance4' then
							animPlayer('missfbi3_sniping', 'dance_m_default')
						end
					end
				end, function(data3, menu3)
					menu3.close()
				end)
			elseif data2.current.value == 'femaledances' then
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'femaledances', {
					title    = 'Female Dances',
					align    = 'bottom-right',
					elements = {
						{label = 'Dance 1', value = 'fdance1'},
						{label = 'Dance 2', value = 'fdance2'},
						{label = 'Dance 3', value = 'fdance3'},
						{label = 'Dance 4', value = 'fdance4'},
						{label = 'Dance 5', animType = 'anim', data = {lib = 'anim@mp_player_intcelebrationfemale@uncle_disco', anim = 'uncle_disco'}},
						{label = 'Dance 6', animType = 'anim', data = {lib = 'anim@mp_player_intcelebrationfemale@raise_the_roof', anim = 'raise_the_roof'}},
						{label = 'Dance 7', animType = 'anim', data = {lib = 'anim@amb@nightclub@mini@dance@dance_solo@female@var_a@', anim = 'high_center'}},
						{label = 'Dance 8', animType = 'anim', data = {lib = 'anim@amb@nightclub@mini@dance@dance_solo@female@var_b@', anim = 'high_center'}},
						{label = 'Dance 9', animType = 'anim', data = {lib = 'anim@amb@nightclub@dancers@crowddance_facedj_transitions@', anim = 'trans_dance_facedj_hi_to_mi_11_v1_female^6'}},
						{label = 'Dance 10', animType = 'anim', data = {lib = 'anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity', anim = 'trans_dance_facedj_hi_to_li_07_v1_female^6'}},
						{label = 'Dance 11', animType = 'anim', data = {lib = 'anim@amb@nightclub@dancers@crowddance_facedj@', anim = 'hi_dance_facedj_09_v1_female^6'}},
						{label = 'Dance 12', animType = 'anim', data = {lib = 'anim@amb@nightclub@dancers@crowddance_groups@hi_intensity', anim = 'hi_dance_crowd_09_v1_female^6'}},
				}}, function(data3, menu3)
					if data3.current.animType then
						local animType = data3.current.animType
						local lib  = data3.current.data.lib
						local anim = data3.current.data.anim

						if animType == 'scenario' then
							startScenario(anim)
						elseif animType == 'attitude' then
							startAttitude(lib, anim)
						elseif animType == 'anim' then
							startAnim(lib, anim)
						end
					else
						if data3.current.value == 'fdance1' then
							animPlayer('mini@strip_club@private_dance@part1', 'priv_dance_p1')
						elseif data3.current.value == 'fdance2' then
							animPlayer('mini@strip_club@private_da32nce@part2', 'priv_dance_p2')
						elseif data3.current.value == 'fdance3' then
							animPlayer('mini@strip_club@private_dance@part3', 'priv_dance_p3')
						elseif data3.current.value == 'fdance4' then
							animPlayer('mp_am_stripper','lap_dance_girl')
						end
					end
				end, function(data3, menu3)
					menu3.close()
				end)
			elseif data2.current.value == 'sitting' then
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'sitting', {
					title    = 'Sitting',
					align    = 'bottom-right',
					elements = {
						{label = 'Sit 1', value = 'sit1'},
						{label = 'Sit 2', value = 'sit2'},
						{label = 'Sit 3', value = 'sit3'},
						{label = 'Sit 4', value = 'sit4'},
						{label = 'Sit 5', value = 'sit5'},
						{label = 'Sit 6', value = 'sit6'},
						{label = 'Sit 7', value = 'sit7'},
				}}, function(data3, menu3)
					if data3.current.value == 'sit1' then
						animPlayer('rcm_barry3', 'barry_3_sit_loop')
					elseif data3.current.value == 'sit2' then
						animPlayer('switch@michael@sitting', 'idle')
					elseif data3.current.value == 'sit3' then
						animPlayer('switch@michael@restaurant', '001510_02_gc_mics3_ig_1_base_amanda')
					elseif data3.current.value == 'sit4' then
						animPlayer('timetable@amanda@ig_12', 'amanda_idle_a')
					elseif data3.current.value == 'sit5' then
						animPlayer('amb@prop_human_seat_deckchair@female@idle_a', 'idle_a')
					elseif data3.current.value == 'sit6' then
						animPlayer('amb@world_human_picnic@female@idle_a', 'idle_b')
					elseif data3.current.value == 'sit7' then
						animPlayer('amb@world_human_picnic@male@idle_a', 'idle_b')
					end
				end, function(data3, menu3)
					menu3.close()
				end)
			elseif data2.current.value == 'sleeping' then
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'sleeping', {
					title    = 'Sleeping',
					align    = 'bottom-right',
					elements = {
						{label = 'Sleep 1', value = 'sleep1'},
				}}, function(data3, menu3)
					if data3.current.value == 'sleep1' then
						animPlayer('timetable@tracy@sleep@', 'idle_c')
					end
				end, function(data3, menu3)
					menu3.close()
				end)
			elseif data2.current.value == 'fitness' then
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fitness', {
					title    = 'Fitness',
					align    = 'bottom-right',
					elements = {
						{label = 'Meditate', value = 'meditate'},
						{label = 'Jogging', value = 'jogging'},
						{label = 'Flexing', value = 'flexing'},
						{label = 'Sit Ups', value = 'situps'},
						{label = 'Push Ups', value = 'pushups'},
						{label = 'Yoga 1', value = 'yoga1'},
						{label = 'Yoga 2', value = 'yoga2'},
						{label = 'Yoga 3', value = 'yoga3'},
						{label = 'Random Yoga', value = 'yoga4'},
				}}, function(data3, menu3)
					local action = data3.current.value
					if action == 'meditate' then
						animPlayer('rcmcollect_paperleadinout@', 'meditiate_idle')
					elseif action == 'jogging' then
						animsActionScenario({anim = 'WORLD_HUMAN_JOG_STANDING'})
					elseif action == 'flexing' then
						animsActionScenario({anim = 'WORLD_HUMAN_MUSCLE_FLEX'})
					elseif action == 'situps' then
						animPlayer('amb@world_human_sit_ups@male@base', 'base')
					elseif action == 'pushups' then
						animPlayer('amb@world_human_push_ups@male@base', 'base')
					elseif action == 'yoga1' then
						animPlayer('amb@world_human_yoga@female@base', 'base_a')
					elseif action == 'yoga2' then
						animPlayer('amb@world_human_yoga@female@base', 'base_b')
					elseif action == 'yoga3' then
						animPlayer('amb@world_human_yoga@female@base', 'base_c')
					elseif action == 'yoga4' then
						animsActionScenario({anim = 'WORLD_HUMAN_YOGA'})
					end
				end, function(data3, menu3)
					menu3.close()
				end)
			elseif data2.current.value == 'cancel' then
				ClearPedTasks(PlayerPedId())
			elseif data2.current.value == 'menuperso_actions_walking' then
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_actions_walking', {
					title    = 'Walking Styles',
					align    = 'bottom-right',
					elements = {
						{label = 'Default', value = 'default'},
						{label = 'Brave', value = 'brave'},
						{label = 'Gangster', value = 'gangster'},
						{label = 'Generic 1', value = 'generic'},
						{label = 'Generic 2', value = 'generic2'},
						{label = 'Injured', value = 'injured'},
						{label = 'Slow', value = 'slow'},
						{label = 'Posh', value = 'posh'},
						{label = 'Tough Guy', value = 'tough'},
						{label = 'Sexy', value = 'sexy'},
				}}, function(data3, menu3)
					if data3.current.value == 'default' then
						resetWalk()
					elseif data3.current.value == 'brave' then
						walker('move_m@brave')
					elseif data3.current.value == 'gangster' then
						walker('MOVE_M@GANGSTER@NG')
					elseif data3.current.value == 'generic' then
						walker('move_characters@michael@fire')
					elseif data3.current.value == 'generic2' then
						walker('move_ped_mop')
					elseif data3.current.value == 'injured' then
						walker('move_injured_generic')
					elseif data3.current.value == 'slow' then
						walker('move_p_m_zero_slow')
					elseif data3.current.value == 'posh' then
						walker('MOVE_M@POSH@')
					elseif data3.current.value == 'tough' then
						walker('MOVE_M@TOUGH_GUY@')
					elseif data3.current.value == 'sexy' then
						walker('move_f@sexy@a')
					end
				end, function(data3, menu3)
					menu3.close()
				end)
			end
	end, function(data2, menu2)
		menu2.close()
	end)
end)

function startScenario(anim)
	TaskStartScenarioInPlace(PlayerPedId(), anim, 0, false)
end

function startAttitude(lib, anim)
	ESX.Streaming.RequestAnimSet(lib, function()
		SetPedMovementClipset(PlayerPedId(), anim, true)
	end)
end

function startAnim(lib, anim)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0.0, false, false, false)
	end)
end