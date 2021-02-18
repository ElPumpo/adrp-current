GUIAction = {
	closeGui() {
		$('#identity').css("display", "none");
		$('#register').css("display", "none");
	},

	openGuiIdentity(data) {
		data = data || {};
		let infoMissing = 'Fake ID';

		if (data.dateNaissance) {
			data.dateNaissance = data.dateNaissance.substr(0, 11);
		}

		if (data.sexe !== undefined) {
			$('#identity').css('background-image', "url('carteV3_" + data.sexe + ".png')");
			data.sexe = data.sexe === 'h' ? 'Male' : 'Female';
		}

		if (data.taille !== undefined) {
			data.taille = data.taille + ' cm';
		}

		['nom', 'prenom', 'jobs', 'dateNaissance', 'sexe', 'taille'].forEach(k => {
			$('#' + k).text(data[k] || infoMissing);
		});

		$('#identity').css("display", "block");
	}
};

window.addEventListener('message', function (event) {
	let method = event.data.method;

	if (GUIAction[method] !== undefined) {
		GUIAction[method](event.data.data);
	}
});
