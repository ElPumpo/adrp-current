function DrawCountDownScaleform(scaleform, number, sec, r, g, b)
	BeginScaleformMovieMethod(scaleform, 'SET_MESSAGE')

	if number == 0 then
		PushScaleformMovieMethodParameterString('GO')
		PushScaleformMovieMethodParameterInt(30)
		PushScaleformMovieMethodParameterInt(230)
		PushScaleformMovieMethodParameterInt(30)

		PlaySoundFrontend(-1, 'GO', 'HUD_MINI_GAME_SOUNDSET', false)
	else
		PushScaleformMovieMethodParameterString(number)
		PushScaleformMovieMethodParameterInt(r)
		PushScaleformMovieMethodParameterInt(g)
		PushScaleformMovieMethodParameterInt(b)

		PlaySoundFrontend(-1, '3_2_1', 'HUD_MINI_GAME_SOUNDSET', false)
	end

	PushScaleformMovieMethodParameterBool(true)
	EndScaleformMovieMethod()

	while sec > 0 do
		Citizen.Wait(0)
		sec = sec - 0.01

		DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
	end
end