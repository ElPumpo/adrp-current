var rgbStart = [139, 195, 74];
var rgbEnd = [183, 28, 28];

$(function () {
	$('#ui').hide();
	$('#jail').hide();

	window.addEventListener('message', function (event) {
		if (event.data.action == "setValue") {
			if (event.data.key == "job") {
				setJobIcon(event.data.icon);
				setValue(event.data.key, event.data.value);
			} else if (event.data.key == "gang") {
				setGangIcon(event.data.icon);
			} else if (event.data.key == "dirtymoney") {
				if (event.data.value == "$0") {
					$('#dirtymoney').hide();
				} else {
					$('#dirtymoney').show();
				}
			} else if (event.data.key == "jail") {
				if (event.data.value == "00:00") {
					$('#jail').hide();
				} else {
					$('#jail').show();
				}
			}

			setValue(event.data.key, event.data.value);
		} else if (event.data.action == "updateStatus") {
			updateStatus(event.data.status);
		} else if (event.data.action == "setTalking") {
			setTalking(event.data.value);
		} else if (event.data.action == "setProximity") {
			setProximity(event.data.value);
		} else if (event.data.action == "toggleUI") {
			if (event.data.show) {
				$('#ui').show();
			} else {
				$('#ui').hide();
			}
		} else if (event.data.action == "toggleSociety") {
			if (event.data.state) {
				$('#society').show();
			} else {
				$('#society').hide();
			}
		} else if (event.data.action == "toggleGang") {
			if (event.data.state) {
				$('#gang').show();
			} else {
				$('#gang').hide();
			}
		} else if (event.data.action == "toggleCar") {
			if (event.data.show) {
				$('.carStats').show();
			} else {
				$('.carStats').hide();
			}
		} else if (event.data.action == "updateCarStatus") {
			updateCarStatus(event.data.status);
		} else if (event.data.action == "updateWeight") {
			updateWeight(event.data.weight);
		}
	});

});

function updateWeight(weight) {
	var bgcolor = colourGradient(weight / 100, rgbEnd, rgbStart);

	$('#weight .bg').css('height', weight + '%');
	$('#weight .bg').css('background-color', 'rgb(' + bgcolor[0] + ',' + bgcolor[1] + ',' + bgcolor[2] + ')');
}

function updateCarStatus(status) {
	var gas = status[0];
	$('#gas .bg').css('height', gas.percent + '%');
	var bgcolor = colourGradient(gas.percent / 100, rgbStart, rgbEnd);

	//var bgcolor = colourGradient(0.1, rgbStart, rgbEnd)
	//$('#gas .bg').css('height', '10%')
	$('#gas .bg').css('background-color', 'rgb(' + bgcolor[0] + ',' + bgcolor[1] + ',' + bgcolor[2] + ')');
}

function setValue(key, value) {
	$('#' + key + ' span').html(value);
}

function setJobIcon(value) {
	$('#job img').attr('src', 'img/jobs/' + value + '.png');
}

function setGangIcon(value) {
	$('#gang img').attr('src', 'img/gangs/' + value + '.png');
}

function updateStatus(status) {
	$.each(status, function(index, element) {
		switch (element.name) {
			case 'hunger':
				$('#hunger .bg').css('height', element.percent + '%');
				break;

			case 'thirst':
				$('#water .bg').css('height', element.percent + '%');
				break;

			case 'drunk':
				$('#drunk .bg').css('height', element.percent + '%');

				if (element.percent > 0) {
					$('#drunk').show();
				} else {
					$('#drunk').hide();
				}

				break;

			case 'oxygen':
				$('#oxygen .bg').css('height', element.percent + '%');

				if (element.percent > 0) {
					$('#oxygen').show();
				} else {
					$('#oxygen').hide();
				}

				break;

			default:
				console.log('adrp_ui: unknown status!');
				break;
		}
	});
}

function setProximity(value) {
	var color;
	var speaker;

	if (value == "whisper") {
		color = "#FFEB3B";
		speaker = 1;
	} else if (value == "normal") {
		color = "#039BE5";
		speaker = 2;
	} else if (value == "shout") {
		color = "#e53935";
		speaker = 3;
	}

	$('#voice .bg').css('background-color', color);
	$('#voice img').attr('src', 'img/speaker' + speaker + '.png');
}

function setTalking(value) {
	if (value) {
		$('#voice').css('border', '3px solid #03A9F4')
	} else {
		$('#voice').css('border', 'none')
	}
}

function colourGradient(p, rgb_beginning, rgb_end) {
	var w = p * 2 - 1;

	var w1 = (w + 1) / 2.0;
	var w2 = 1 - w1;

	var rgb = [parseInt(rgb_beginning[0] * w1 + rgb_end[0] * w2),

	parseInt(rgb_beginning[1] * w1 + rgb_end[1] * w2),
	parseInt(rgb_beginning[2] * w1 + rgb_end[2] * w2)];

	return rgb;
};