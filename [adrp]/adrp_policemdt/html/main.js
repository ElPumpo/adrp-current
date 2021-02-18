var officer;
var resourceName = "adrp_policemdt";

$(function () {
	$('.homeButton').click(function () {
		setPage('home');
	});

	$('.items .item').click(function () {
		var page = $(this).data('page');
		setPage(page);
	});

	window.addEventListener('message', function (event) {
		if (event.data.type == "MDT") {
			if (event.data.action == "open") {
				setPage('home');
				$('#mdt').fadeIn();
			} else if (event.data.action == "scanVehicle") {
				setPage('searchVehicles');
				$('#vehSearch').val(event.data.plate);
				$('#mdt').fadeIn();
				requestVehicle(event.data.plate);
			}
			officer = event.data.name;
			$('.upbar p').html('Welcome ' + officer + '!');
		}
	});

	/* Close with ESC */
	$(document).keyup(function (e) {
		if (e.keyCode == 27) {
			$.post('http://' + resourceName + '/closeMDT');
			$('#mdt').fadeOut();
		}
	});

	$('#searchPls').click(function () {
		var val = $('#playerSearch').val();
		requestPlayersLike(val);
	});

	$('#searchVehs').click(function () {
		var val = $('#vehSearch').val();
		requestVehicle(val);
	});

	$('#searchPlayers .ctable').on('click', '.more', function () {
		var target = $(this).data('req');
		var charid = $(this).data('charid');
		requestPlayer(target, charid);
	});

	$('#searchVehicles .ctable').on('click', '.more', function () {
		var target = $(this).data('req');
		var charid = $(this).data('charid');
		requestPlayer(target, charid);
	});

	$('#searchVehicles .ctable').on('click', '.placebolo', function () {
		var target = $(this).data('plate');
		placeBolo(target);
	});

	$('#searchVehicles .ctable').on('click', '.removebolo', function () {
		var target = $(this).data('plate');
		removeBolo(target);
	});

	$('#createRecord button').click(function (event) {
		event.preventDefault();
		createRecord();
	});
});

function setPage(page) {
	$('.page').removeClass('active');
	$('#' + page).addClass('active');
}

function startLoading(text) {
	$('.loading span').html(text);
	$('.loading').fadeIn();
}

function stopLoading() {
	$('.loading').fadeOut();
}

// Profile Page Data -> {name: "Cem Ayder", driverLicense: "Yes", adress: "...", records: {record, record}}
// Record Data -> {id: "...", issuer: "...", type: "...", note: "...", player: "..."}
//

function fillProfilePage(data) {
	$('#playerProfile .page-title span').html('Viewing ' + data.userdata.fullname);
	$('#playerProfile #fullName .value').html(data.userdata.fullname);

	var licenses = "";
	for (var i = 0; i < data.licenses.length; i++) {
		var currentLicense = data.licenses[i];
		licenses += currentLicense.label + ", ";
	}

	if (data.licenses.length == 0) {
		$('#playerProfile #dLicenses .value').html('No license');
	} else {
		$('#playerProfile #dLicenses .value').html(licenses);
	}

	var properties = "";
	for (var i = 0; i < data.propertydata.length; i++) {
		var currentProperty = data.propertydata[i];
		properties += currentProperty.label + ", ";
	}

	if (data.propertydata.length == 0) {
		$('#playerProfile #properties .value').html('No properties');
	} else {
		$('#playerProfile #properties .value').html(properties);
	}

	$('#playerProfile #recordsProfile tbody').html('');

	for (var i = data.records.length - 1; i >= 0; i--) {
		var r = data.records[i];
		var item = '<tr><td>' + r.issuer + '</td><td>' + r.type + '</td><td><button class="cbtn more" onclick="requestRecord(' + r.recordid + ')">More</button></td></tr>';

		$('#playerProfile #recordsProfile tbody').append(item);
	}
}

function fillRecordPage(data) {
	$('#seeRecord #issuerView').val(data.issuer);
	$('#seeRecord #playerNameView').val(data.player);
	$('#seeRecord #typeView').val(data.type);
	$('#seeRecord #notesView').val(data.notes);
	$('#seeRecord button').attr('onclick', 'removeRecord(' + data.recordid + ')');
}

function fillSearchPlayer(data) {
	$('#searchPlayers tbody').html('');

	for (var i = data.length - 1; i >= 0; i--) {
		var p = data[i];
		var item = '<tr><td>' + p.firstname + ' ' + p.lastname + '</td><td>' + p.job + '</td><td><button class="cbtn more" data-req="' + p.identifier + '" data-charid="' + p.characterID + '">More</button></td></tr>';
		$('#searchPlayers tbody').append(item);
	}

	if (data.length == 0) {
		$('#searchPlayers tbody').html('No results found.');
	}
}

function fillSearchVehicle(data) {
	$('#searchVehicles tbody').html('');

	for (var i = data.length - 1; i >= 0; i--) {
		var v = data[i];
		var item;
		var warrant = "";

		if (v.ownerData.warrants.length > 0) {
			warrant = '<i style="color: red; margin-left: 5px;" class="fa fa-exclamation-triangle" aria-hidden="true"></i>';
		}

		if (v.bolo == "false") {
			item = '<tr><td>' + v.plate + '</td><td>' + v.ownerData.fullname + warrant + '</td><td><button class="cbtn more" data-req="' + v.owner + '" data-charid="' + v.ownerData.characterID + '">More</button> <button style="margin-left: 5px;" class="cbtn placebolo" data-plate="' + v.plate + '">Place Bolo</button></td></tr>';
		} else {
			item = '<tr><td>' + v.plate + '</td><td>' + v.ownerData.fullname + warrant + '</td><td><button class="cbtn more" data-req="' + v.owner + '" data-charid="' + v.ownerData.characterID + '">More</button> <button style="margin-left: 5px;" class="cbtn removebolo" data-plate="' + v.plate + '">Remove Bolo</button><i style="color: red; margin-left: 5px;" class="fa fa-car" aria-hidden="true"></i></td></tr>';
		}

		$('#searchVehicles tbody').append(item);
	}

	if (data.length == 0) {
		$('#searchVehicles tbody').html('No results found.');
	}
}

function fillCheckWarrants(data) {
	$('#checkWarrants tbody').html('');

	for (var i = 0; i < data.length; i++) {
		var w = data[i];
		var item = '<tr><td>' + w.issuer + '</td><td>' + w.player + '</td><td><button class="cbtn more" onclick="requestRecord(' + w.recordid + ')">More</button></td></tr>';
		$('#checkWarrants tbody').append(item);
	}
}

/* Requests, Fills, redirects */
function createRecord() {
	var actionName = "createRecord";
	var citizenName = $('#createRecord #playerName').val();
	//var type = $('#createRecord #type').val();
	var notes = $('#createRecord #notes').val();
	var issuer = officer;
	var type;

	$('#typeList').children('input').each(function () {
		if ($(this).prop("checked") == true) {
			type = $(this).data('type');
		}
	});

	var data = { "action": actionName, data: { "issuer": issuer, "player": citizenName, "type": type, "notes": notes } };

	startLoading("Creating Record...");

	$.post('http://' + resourceName + '/mdtAction', JSON.stringify(data)).done(function (resp) {

		if (resp.success == true) {
			stopLoading();

			$('#createRecord #playerName').val('');
			$('#createRecord #notes').val();
			setPage('home');
			//requestPlayer(citizenName);
		} else {
			$('#createRecord .alerts').html('');
			$('#createRecord .alerts').append("<li>" + resp.message + "</li>");
			stopLoading();
		}
	});
}

function removeRecord(id) {
	startLoading("Removing Record...");
	var data = { "action": "removeRecord", "recordid": id };
	$.post('http://' + resourceName + '/mdtAction', JSON.stringify(data)).done(function (resp) {
		setPage('home');
		stopLoading();
	});
}

function requestPlayersLike(name) {
	startLoading("Searching...");
	var data = { "action": "requestPlayersLike", "name": name };

	$.post('http://' + resourceName + '/mdtAction', JSON.stringify(data)).done(function (resp) {
		fillSearchPlayer(resp);
		stopLoading();
		setPage('searchPlayers');
	});
}

function requestPlayer(identifier, charID) {
	startLoading("Getting user data...");
	var data = { "action": "requestPlayer", "identifier": identifier, "characterID": charID };

	$.post('http://' + resourceName + '/mdtAction', JSON.stringify(data)).done(function (resp) {
		fillProfilePage(resp);
		stopLoading();
		setPage('playerProfile');
	});
}

function requestRecord(recordid) {
	startLoading("Getting user data...");
	var data = { "action": "getRecord", "recordid": recordid };

	$.post('http://' + resourceName + '/mdtAction', JSON.stringify(data)).done(function (resp) {
		fillRecordPage(resp);
		stopLoading();
		setPage('seeRecord');
	});
}

function requestVehicle(plate) {
	startLoading("Searching vehicles...");
	var data = { "action": "requestVehicle", "plate": plate };

	$.post('http://' + resourceName + '/mdtAction', JSON.stringify(data)).done(function (resp) {
		fillSearchVehicle(resp);
		stopLoading();
		setPage('searchVehicles');
	});
}

function placeBolo(plate) {
	startLoading("Placing bolo...");
	var data = { "action": "placeBolo", "plate": plate };

	$.post('http://' + resourceName + '/mdtAction', JSON.stringify(data)).done(function (resp) {
		stopLoading();
		requestVehicle(plate);
	});
}

function removeBolo(plate) {
	startLoading("Removing bolo...");
	var data = { "action": "removeBolo", "plate": plate };

	$.post('http://' + resourceName + '/mdtAction', JSON.stringify(data)).done(function (resp) {
		stopLoading();
		requestVehicle(plate);
	});
}

function checkWarrants() {
	startLoading("Checking active warrants");
	var data = { "action": "checkWarrants" };

	$.post('http://' + resourceName + '/mdtAction', JSON.stringify(data)).done(function (resp) {
		fillCheckWarrants(resp);
		stopLoading();
		setPage('checkWarrants');
	});
}