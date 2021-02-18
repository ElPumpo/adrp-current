--https://scaleform.devtesting.pizza/#MP_MM_CARD_FREEMODE
function CreateSpectateScaleform()
	local self = {}

	self.currentPage = 0
	self.maxPages = 0
	self.selectedIndex = 0
	self.players = {}
	self.scaleform = ESX.Scaleform.Utils.RequestScaleformMovie('MP_MM_CARD_FREEMODE')

	self.setPlayers = function(players)
		self.players = players
		self.updateMaxPages()
	end

	self.nextPage = function()
		if self.currentPage < self.maxPages then
			self.currentPage = self.currentPage + 1
			self.updateScoreboard()
		end
	end

	self.onKeyUp = function()
		if self.currentPage > 0 then
			if self.currentIndex - 1 >= 0 then
				self.currentIndex = self.currentIndex + 1
				BeginScaleformMovieMethod(self.scaleform, 'SET_HIGHLIGHT')
				ScaleformMovieMethodAddParamInt(self.currentIndex)
				EndScaleformMovieMethod()
			else
				-- todo play sound
			end
		end
	end

	self.onKeyDown = function()
		if self.currentPage > 0 then
			if self.currentIndex + 1 < 16 then
				self.currentIndex = self.currentIndex + 1
				BeginScaleformMovieMethod(self.scaleform, 'SET_HIGHLIGHT')
				ScaleformMovieMethodAddParamInt(self.currentIndex)
				EndScaleformMovieMethod()
			else
				-- todo play sound
			end
		end
	end

	self.handleInputsThisFrame = function()
		-- TODO handle all key inputs related to this scaleform
	end

	self.updateScoreboard = function()
		self.clearScoreboard()
		local currentIndex = 0

		for k,v in ipairs(self.players) do
			v.index = nil
			if self.isRowSupposedToShow(currentIndex) then
				BeginScaleformMovieMethod(self.scaleform, 'SET_DATA_SLOT')

				-- assign index
				v.index = currentIndex
				ScaleformMovieMethodAddParamInt(currentIndex) -- index

				PushScaleformMovieMethodParameterString('') -- right text (rank?) DONTSET
				PushScaleformMovieMethodParameterString(player.name) --name
				ScaleformMovieMethodAddParamInt(111) -- white color
				ScaleformMovieMethodAddParamInt(66) -- right icon type SHOULD BE 0 WHEN NOT SELECTED&SPECTATED
				PushScaleformMovieMethodParameterString('') -- icon overlay text, unused? DONTSET
				PushScaleformMovieMethodParameterString('') -- job points text DONTSET
				PushScaleformMovieMethodParameterString('') -- crew label text DONTSET
				ScaleformMovieMethodAddParamInt(2) -- job points display type [number only: 0, icon: 1, none: 2] -- DONTSET
				PushScaleformMovieMethodParameterString(player.headshot or '') -- headshot string
				PushScaleformMovieMethodParameterString(player.headshot or '') -- headshot string
				PushScaleformMovieMethodParameterString(' ') -- friend type DONTSET
		
				EndScaleformMovieMethod()
			end

			currentIndex = currentIndex + 1
		end

		--BeginScaleformMovieMethod(self.scaleform, 'DISPLAY_VIEW')
		--EndScaleformMovieMethod()
	end

	self.clearScoreboard = function()
		for i=0, 16 do
			BeginScaleformMovieMethod(self.scaleform, 'SET_DATA_SLOT_EMPTY')
			ScaleformMovieMethodAddParamInt(i)
			EndScaleformMovieMethod()
		end
	end

	--https://github.com/citizenfx/fivem/blob/master/code/client/clrcore/External/Scaleform.cs
	self.drawThisFrame = function()
		if self.currentPage > 0 then
			local screenX, screenY = GetActiveScreenResolution()
			local safeZone = GetSafeZoneSize()
			local modifier = (safeZone - 0.89) / 0.11
	
			local locationX, locationY = ((modifier * 78) - 50) / screenX, ((modifier * 50) - 50) / screenY
			local sizeX, sizeY = 400 / screenX, 490 / screenY
	
			DrawScaleformMovie(self.scaleform, locationX + (sizeX / 2.0), locationY + (sizeY / 2.0), sizeX, sizeY, 255, 255, 255, 255, 0)
		end
	end

	self.setTitle = function(titleLeftText, titleRightText, titleIcon)
		BeginScaleformMovieMethod(self.scaleform, 'SET_TITLE')

		PushScaleformMovieMethodParameterString(titleLeftText)
		PushScaleformMovieMethodParameterString(titleRightText)
		PushScaleformMovieMethodParameterString(titleIcon) -- not a number?

		EndScaleformMovieMethod()
	end

	self.isRowSupposedToShow = function(rowIndex)
		if self.currentPage > 0 then
			local max = self.currentPage * 16
			local min = (self.currentPage * 16) - 16

			if rowIndex >= min and rowIndex < max then
				return true
			end
		end

		return false
	end

	self.updateHeadshots = function()
		for i=0, 150 do
			UnregisterPedheadshot(i)
		end

		for _,player in ipairs(self.players) do
			local clientId = GetPlayerFromServerId(player.serverId)

			if NetworkIsPlayerActive(clientId) then
				local playerPed = GetPlayerPed(clientId)
				local mugshot, headshotTxd = ESX.Game.GetPedMugshot(playerPed)

				if headshotTxd then
					player.headshot = headshotTxd
				end
			end
		end
	end

	self.updateMaxPages = function()
		self.maxPages = Ceil(#self.players / 16)
	end

	return self
end