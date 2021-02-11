--Script Name : jlp_Route selected tracks to hardware out
--Author : Jean Loup Pecquais
--Description : route selected track to next available hardware out
--v1.0.0

local libPath = reaper.GetExtState("Reaper Evolution", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Reaper Evolution library is not found. Please refer to user guide", "Library not found", 0)
    return
end

loadfile(libPath .. "reaVolutionLib.lua")()

-------------------------------------------------------------------------------------------------------------

-- local selTracks = reaper.CountSelectedTracks()

-- for i = 0, selTracks-1 do

-- 	local tr = reaper.GetSelectedTrack( 0, i )
-- 	local _, trChannels = getNumberOfChannel( tr )

-- 	local hardwareOut = getNextAvailableHardwareOut() or 0
-- 	local numberOutput = reaper.GetNumAudioOutputs()

-- 	if hardwareOut < numberOutput then
-- 		reaper.SetMediaTrackInfo_Value( tr, "B_MAINSEND", 0 )
-- 		for j = 0, trChannels-1 do
-- 			local outputIndex = reaper.CreateTrackSend( tr, nil )
-- 			reaper.SetTrackSendInfo_Value( tr, 1, outputIndex, "I_DSTCHAN", hardwareOut+1024)
-- 			hardwareOut = hardwareOut + 1
-- 		end
-- 	else
-- 		reaper.MB("No more hardware outputs available", "Error", 0)
-- 	end

-- end

function main()
  -- count selected track
  local selTr = reaper.CountSelectedTracks(0)

  -- if no track is selected then exit script
  if selTr == 0 then
    reaper.defer()
  end

  -- for each selected track..
  for i=0, selTr-1 do
    local tr = reaper.GetSelectedTrack(0, i)
    local ch = reaper.GetMediaTrackInfo_Value(tr, "I_NCHAN") --Get number of channels
    reaper.SetMediaTrackInfo_Value(tr, "B_MAINSEND", 0) --Turn off send to master

    local trTag = getTag( tr )
    local trStream = getStreamType( tr )

    local hardwareOut = getNextAvailableHardwareOut() or 0
    local numberOutput = reaper.GetNumAudioOutputs()

      --..Verify if it is a folder. If true, get their child ID.
    if string.find( trStream, "MultiBus" ) then

      local childArr = getChildTrack(tr, 1) -- Table of child trackID
      local retval, tr_name = reaper.GetTrackName(tr)

      for i=0, #childArr-1 do

        local childTag = getTag(childArr[i+1])
        local _, childNumCh = getNumberOfChannel(childArr[i+1]) --Get number of channels of child

		  reaper.SetMediaTrackInfo_Value( tr, "B_MAINSEND", 0 )


        for j=0, childNumCh-1 do

    			if hardwareOut < numberOutput then
    				local outputIndex = reaper.CreateTrackSend( tr, nil )
    				reaper.SetTrackSendInfo_Value( tr, 1, outputIndex, "I_DSTCHAN", hardwareOut+1024)
            reaper.SetTrackSendInfo_Value( tr, 1, outputIndex, "I_SRCCHAN", j+1024)
    				hardwareOut = hardwareOut + 1
    			else
    				reaper.MB("No more hardware outputs available", "Error", 0)
    				return
    			end

        end
      end

    else
      
      local _, trNumCh = getNumberOfChannel( tr )
    	reaper.SetMediaTrackInfo_Value( tr, "B_MAINSEND", 0 )

      local currCh = 0
      for j=0, trNumCh-1 do

  			if hardwareOut < numberOutput then
  				local outputIndex = reaper.CreateTrackSend( tr, nil )
  				reaper.SetTrackSendInfo_Value( tr, 1, outputIndex, "I_DSTCHAN", hardwareOut+1024)
          reaper.SetTrackSendInfo_Value( tr, 1, outputIndex, "I_SRCCHAN", j+1024)
  				hardwareOut = hardwareOut + 1
  			else
  				reaper.MB("No more hardware outputs available", "Error", 0)
  			end

      end
    end
  end
end

main()