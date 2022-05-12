--Script Name : tagSystemLib.lua
--Author : Jean Loup Pecquais
--Description : ReaVolution tag system lib
--v1.0.0

local resourcePath = reaper.GetResourcePath()


function getTag( tr )
	local _, tag = reaper.GetSetMediaTrackInfo_String(tr, "P_EXT:xyz", "", false)
	return tag
end

function setTag( tr, newValue )
	local bool = reaper.GetSetMediaTrackInfo_String(tr, "P_EXT:xyz", newValue, true)
	return bool
	
end

function getChannelsFromString( input )
	local chNumber = 0
	local counter = 0
	for w in string.gmatch(input,"%d+") do
		chNumber = chNumber + tonumber(w)
		counter = counter + 1
		if counter >2 then break end
	end

	if chNumber < 1 then chNumber = 1
	elseif chNumber > 64 then chNumber = 64 end

	return chNumber
end

function getHOA2DCh( input )
	local input = tonumber(input)
	if input < 1 then input = 1
	elseif input > 7 then input = 7 end
	local ch = 2*input
	ch = ch+1
	return ch
end

function getHOA3DCh( input )
	local input = tonumber(input)
	if input < 1 then input = 1
	elseif input > 7 then input = 7 end
	local ch = input+1
	ch = ch * ch
	return ch
end

function getNumberOfChannel( tr )
	local audioStreamIdx = reaper.TrackFX_AddByName( tr, "Audio Stream", false, 0)
	local chNum, minVal, maxVal = reaper.TrackFX_GetParam( tr, audioStreamIdx, 1)
	return chNum
end

function getStreamType( tr )
	-- stream definition
	-- 0 = Channel Based / 1 = MS / 2 = A-Format / 3 = B-Format / 4 = UHJ / 5 = HOA 2D / 6 = HOA 3D / 7 = Binaural / 8 = Transaural

	local audioStreamIdx = reaper.TrackFX_AddByName( tr, "Audio Stream", false, 0)
	local stream, minVal, maxVal = reaper.TrackFX_GetParam( tr, audioStreamIdx, 0)

	return stream
end

function getAudioStream( tr )
	local streamType = getStreamType( tr )
	local chNumber = getNumberOfChannel( tr )
	return streamType, chNumber
end

function setAudioStream( tr, streamNumber, ch )
	local ch = ch or 1
	if 	   streamNumber == 1 or streamNumber == 7 or streamNumber == 8 then ch = 2
	elseif streamNumber == 2 or streamNumber == 3 or streamNumber == 4 then ch = 4 end

	reaper.SetMediaTrackInfo_Value(tr, "I_NCHAN", ch)

	--set stream type of the track
	local audioStreamIdx = reaper.TrackFX_AddByName( tr, "Audio Stream", false, 1)
	reaper.TrackFX_SetParam( tr, audioStreamIdx, 0, streamNumber)

	--set real ch number of the track
	if ch % 2 == 0 then
		reaper.TrackFX_SetParam( tr, audioStreamIdx, 2, 0)
	else
		reaper.TrackFX_SetParam( tr, audioStreamIdx, 2, 1)
	end
	reaper.TrackFX_SetParam( tr, audioStreamIdx, 1, ch)
end