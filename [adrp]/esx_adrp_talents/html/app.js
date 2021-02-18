$(function () {
	window.addEventListener('message', function (event) {
		var action = event.data.action;

		if (action == 'show') {
			$('#wrap').fadeIn();
		} else if (action == 'hide') {
			$('#wrap').fadeOut();
		}
	});
});
