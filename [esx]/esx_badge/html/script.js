GUIAction = {
	closeGui() {
		$('#policebadge').css('display', 'none');
		$('#bcso').css('display', 'none');
		$('#lspd').css('display', 'none');
		$('#sahp').css('display', 'none');
		$('#marshal').css('display', 'none');
		$('#fib').css('display', 'none');
		$('#dod').css('display', 'none');
		$('#doj').css('display', 'none');
	},

	openGuiBadge(data) {
		data = data || {};
		let infoMissing = 'N\/A';

		['fullname', 'job', 'badgeid'].forEach(k => {
			$('#' + k).text(data[k] || infoMissing);
		});

		$('#policebadge').css('display', 'block');

		if (data.job == 'BCSO') {
			$('#bcso').css('display', 'block');
		};

		if (data.job == 'LSPD') {
			$('#lspd').css('display', 'block');
		};

		if (data.job == 'SAHP') {
			$('#sahp').css('display', 'block');
		};

		if (data.job == 'Marshal') {
			$('#marshal').css('display', 'block');
		};

		if (data.job == 'dod') {
			$('#dod').css('display', 'block');
		};

		if (data.job == 'DOJ') {
			$('#doj').css('display', 'block');
		};

		if (data.job == 'FIB') {
			$('#fib').css('display', 'block');
		}
	}
};

window.addEventListener('message', function (event) {
	let method = event.data.method;

	if (GUIAction[method] !== undefined) {
		GUIAction[method](event.data.data);
	}
});
