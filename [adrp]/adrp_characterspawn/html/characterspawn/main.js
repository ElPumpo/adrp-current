var resourceName = "adrp_characterspawn";
var canClose = false;

String.prototype.capitalize = function () {
	return this.replace(/(?:^|\s)\S/g, function (a) { return a.toUpperCase(); });
};

$(function () {
	$('.char button.togglepane').click(function () {
		var pane = $(this).data('pane');
		$('#' + pane).slideToggle();
	});

	$('.char .pane').on('click', 'button.create', function () {
		var characterId = $(this).data('char');
		createCharacter(characterId);
	});

	$('.char .pane').on('click', 'button.select', function () {
		var networkId = $(this).data('network');
		setCharacter(networkId);
	});

	$('.char .pane').on('click', 'button.delete', function () {
		var networkId = $(this).data('network');
		var characterId = $(this).parent().attr('data-char');

		$.confirm({
			title: 'Confirm deleting character',
			content: 'That is right, are you sure that you want to delete your character?',
			icon: 'fa fa-question-circle',
			animation: 'scale',
			closeAnimation: 'scale',
			boxWidth: '30%',
			useBootstrap: false,
			opacity: 0.5,
			buttons: {
				'confirm': {
					text: 'Proceed',
					btnClass: 'btn-orange',
					action: function () {
						$.confirm({
							title: 'There is no going back!',
							content: 'If you delete your character the action cannot be undone, do you understand?',
							icon: 'fa fa-warning',
							animation: 'scale',
							closeAnimation: 'zoom',
							boxWidth: '30%',
							useBootstrap: false,
							buttons: {
								confirm: {
									text: 'Delete character',
									btnClass: 'btn-red',
									action: function () {
										deleteCharacter(networkId, characterId);
									}
								}, cancel: function () { }
							}
						});
					}
				}, cancel: function () { }
			}
		});
	});

	window.addEventListener('message', function (event) {
		if (event.data.type == "char") {
			if (event.data.action == "open") {
				fillCharacters(event.data.charData);
				$('.main').fadeIn();

			} else if (event.data.action == "close") {
				$('.main').fadeOut();
				$.post('http://' + resourceName + '/close');
			}
		}
	});

	$(document).keyup(function (e) {
		if (canClose) {
			if (e.keyCode == 27) {
				$.post('http://' + resourceName + '/close');
				$('.main').fadeOut();
			}
		}
	});

	$(':input[type="number"]').keydown(function (e) {
		if (!((e.keyCode <= 57 && e.keyCode >= 48) || (e.keyCode <= 105 && e.keyCode >= 96)) && e.keyCode != 8) {
			e.preventDefault();
		}
	});
});

/* Loading */
function startLoading(text) {
	$('.loading span').html(text);
	$('.loading').fadeIn();
}

function stopLoading() {
	$('.loading').fadeOut();
}

function fillCharacters(data) {
	for (var i = 0; i < data.length; i++) {
		var char = data[i];
		var characterID = char.characterID;
		var character = '#char' + characterID + ' ';

		$(character + '#firstname').val(char.firstname);
		$(character + '#lastname').val(char.lastname);
		$(character + '#dob').attr('type', 'text');

		var date = char.dateofbirth.split('-');
		date = date[1] + "/" + date[2] + "/" + date[0];

		$(character + '#dob').val(date);
		$(character + '#height').val(char.height);

		$(character).children('input').each(function () {
			$(this).attr('disabled', 'true');
		});

		$(character + '.sex input').attr('disabled', 'true');

		if (char.sex == "male") {
			$(character + '.sex input.male').attr('checked', 'true');
		} else {
			$(character + '.sex input.female').attr('checked', 'true');
		}

		$(character + 'button').removeClass('create');
		$(character + 'button').addClass('select');
		$(character + 'button').html('Play');
		$(character + 'button.cbtn.delete').remove();
		$(character + 'button.cbtn.select').after('<button class="cbtn delete">🗑️</button>');
		$(character + 'button').attr('data-network', char.networkID);

		$('#character' + characterID + ' .togglepane').hide();
		$('#character' + characterID + ' .pane').show();
	}
}

function createCharacter(characterId) {
	var character = '#char' + characterId + ' ';
	var firstname = $(character + '#firstname').val().capitalize();
	var lastname = $(character + '#lastname').val().capitalize();
	var dob = $(character + '#dob').val();
	var height = $(character + '#height').val();
	var sex;

	if ($(character + '.sex input.male').is(':checked')) {
		sex = "male";
	} else {
		sex = "female";
	}

	var data = { "characterID": characterId, "firstname": firstname, "lastname": lastname, "dateofbirth": dob, "height": height, "sex": sex };

	for (var key in data) {
		if (data[key] == null || data[key] == undefined || data[key] == "") {
			showAlertMessage("Please fill everything.");
			return;
		}
	}

	if (height > 210) {
		showAlertMessage("Invalid height! The highest value allowed is 210 cm.");
		return;
	}

	startLoading('Creating Character...');

	data = { "action": "createCharacter", "data": data };

	$.post('http://' + resourceName + '/charAction', JSON.stringify(data)).done(function (resp) {
		if (resp.success) {
			stopLoading();
			getCharacters();
		} else {
			showAlertMessage(resp.message);
		}
	});
}

function getCharacters() {
	startLoading('Loading Characters...');
	var data = { "action": "getCharacters" };

	$.post('http://' + resourceName + '/charAction', JSON.stringify(data)).done(function (resp) {
		fillCharacters(resp);
		stopLoading();
	});
}

function setCharacter(networkId) {
	startLoading('Setting Character...');

	var data = { "action": "selectCharacter", "networkID": networkId };

	$.post('http://' + resourceName + '/charAction', JSON.stringify(data)).done(function (resp) {
		if (resp.success) {
			stopLoading();
		} else {
			showAlertMessage(resp.message);
			$('.main').fadeIn();
			getCharacters();
		}
	});
}

function deleteCharacter(networkId, characterId) {
	startLoading('Deleting Character...');

	var data = { "action": "deleteCharacter", "networkID": networkId, "characterID": characterId };

	$.post('http://' + resourceName + '/charAction', JSON.stringify(data)).done(function (resp) {
		if (resp.success) {
			resetCharacterInput(characterId);
			getCharacters();
		} else {
			$('.main').fadeIn();
			getCharacters();
		}
	});
}

function resetCharacterInput(characterId) {
	var character = '#char' + characterId + ' ';

	$(character + '#dob').attr('type', 'date');
	$(character + '#firstname').val('');
	$(character + '#lastname').val('');
	$(character + '#height').val('');
	$(character).find("*").prop('disabled', false);
	$(character + '.sex input').attr('checked', 'false');
	$(character + 'button').removeClass('select');
	$(character + 'button').addClass('create');
	$(character + 'button').html('Create');
	$(character + 'button').attr('data-network', null);
	$(character + 'button.cbtn.delete').remove();
	$('#character' + characterId + ' .togglepane').show();
	$('#character' + characterId + ' .pane').hide();
}

function showAlertMessage(message) {
	$.confirm({
		title: 'An exception was catched!',
		content: message,
		icon: 'fa fa-exclamation-triangle',
		animation: 'scale',
		closeAnimation: 'scale',
		boxWidth: '30%',
		useBootstrap: false,
		opacity: 0.5,
		buttons: {
			close: function () {}
		}
	});
}