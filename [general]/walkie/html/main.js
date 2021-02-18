var micOn;
var micOff;

$(function(){

	micOn = document.createElement('audio');
	micOn.setAttribute('src', 'mic_click_on.wav');
	$(micOn).prop('volume', 0.1)

	micOff = document.createElement('audio');
	micOff.setAttribute('src', 'mic_click_off.wav');
	$(micOff).prop('volume', 0.1)

	window.addEventListener('message', function(event) {
		if (event.data.action == "setChannel"){
			setChannel(event.data.channel);
		}else if (event.data.action == "open"){
			$('.walkie').show();
		}else if (event.data.action == "close"){
			$('.walkie').hide();
		}else if (event.data.action == "playSound"){
			if (event.data.sound == "on"){
				micOn.play();
			}else{
				micOff.play();
			}
		}

	});


});


function setChannel(channel){
	$('.channel').html('Hz: ' + channel)
	//micOn.play();
}
