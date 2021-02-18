var resourceName = 'esx_atm';

$(function () {
	window.addEventListener('message', function (event) {
		if (event.data.action === 'openGeneral') {
			$('#waiting').fadeIn();
			$('body').addClass('active');
		} else if (event.data.action === 'setBalance') {
			$('.curbalance').html(event.data.balance);
		} else if (event.data.action === 'setPlayerName') {
			$('.username1').html(event.data.playerName);
		} else if (event.data.action === 'closeAll') {
			$('#waiting, #general, #transferUI, #withdrawUI, #depositUI, #topbar').fadeOut();
			$('body').removeClass('active');
		}
	});

	$('.btn-sign-out').click(function () {
		$('#general, #waiting, #transferUI, #withdrawUI, #depositUI, #topbar').fadeOut();
		$('body').removeClass('active');
		$.post('http://' + resourceName + '/focus_off', JSON.stringify({}));
	});

	$('.back').click(function () {
		$('#depositUI, #withdrawUI, #transferUI').hide();
		$('#general').show();
	});

	$('#deposit').click(function () {
		$('#general').hide();
		$('#depositUI').show();
	});

	$('#withdraw').click(function () {
		$('#general').hide();
		$('#withdrawUI').show();
	});

	$('#transfer').click(function () {
		$('#general').hide();
		$('#transferUI').show();
	});

	$('#fingerprint-content').click(function () {
		$('.fingerprint-active, .fingerprint-bar').addClass('active');
		setTimeout(function () {
			$('#general').css('display', 'block');
			$('#topbar').css('display', 'flex');
			$('#waiting').css('display', 'none');
			$('.fingerprint-active, .fingerprint-bar').removeClass('active');
		}, 1400);
	});

	$('#deposit1').submit(function (e) {
		e.preventDefault(); // Prevent form from submitting
		$.post('http://' + resourceName + '/deposit', JSON.stringify({
			amount: $('#amount').val()
		}));

		$('#depositUI').hide();
		$('#general').show();
		$('#amount').val('');
	});

	$('#transfer1').submit(function (e) {
		e.preventDefault(); // Prevent form from submitting
		$.post('http://' + resourceName + '/transfer', JSON.stringify({
			to: $('#to').val(),
			amount: $('#amountt').val()
		}));
		$('#transferUI').hide();
		$('#general').show();
		$('#amountt').val('');
	});

	$('#withdraw1').submit(function (e) {
		e.preventDefault(); // Prevent form from submitting
		$.post('http://' + resourceName + '/withdraw', JSON.stringify({
			amount: $('#amountw').val()
		}));

		$('#withdrawUI').hide();
		$('#general').show();
		$('#amountw').val('');
	});

	document.onkeyup = function (data) {
		if (data.which == 27) {
			$('#general, #waiting, #transferUI, #withdrawUI, #depositUI, #topbar').fadeOut();
			$('body').removeClass('active');
			$.post('http://' + resourceName + '/focus_off', JSON.stringify({}));
		}
	};
});