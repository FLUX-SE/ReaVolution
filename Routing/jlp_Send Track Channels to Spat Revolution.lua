--Script Name : Send track channels to Spat Revolution
--Author : Jean Loup Pecquais
--Description : This script send the selected tracks to Spat Revolution.
--v1.0.0

local libPath = reaper.GetExtState("Reaper Evolution", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Reaper Evolution library is not found. Please refer to user guide", "Library not found", 0)
    return
end

loadfile(libPath .. "reaVolutionLib.lua")()

function main()
  -- count selected track
  reaper.Undo_BeginBlock()

  local lapState =  tonumber(reaper.GetExtState( "ReaVolution", "Default LAP" ))
  local thruState =  tonumber(reaper.GetExtState( "ReaVolution", "Default thru" ))
  local autoOutState =  tonumber(reaper.GetExtState( "ReaVolution", "Automatic routing" ))
  local masterSendState =  tonumber(reaper.GetExtState( "ReaVolution", "Send_No master send" ))

  local noMoreHardware = 0

  local pathTheme = reaper.GetLastColorThemeFile()
  local _, pathTheme, _ = parseFilePath(pathTheme)
  
  local hardwareOut = getNextAvailableHardwareOut() or 0
  local numberOutput = reaper.GetNumAudioOutputs()

  local frames = 10
  reaper.PreventUIRefresh(-1*frames)
  local selTr = reaper.CountSelectedTracks(0)
  local trGUIDTable = {}

  -- if no track is selected then exit script
  if selTr == 0 then
    reaper.defer()
  end

  -- for each selected track..
  -- .. get their GUID
  for i=0, selTr-1 do
    local tr = reaper.GetSelectedTrack(0, i)
    table.insert( trGUIDTable, reaper.GetTrackGUID( tr ) )
  end

  -- then look over GUID track table
  for i=1, #trGUIDTable do
    local tr = reaper.BR_GetMediaTrackByGUID( 0, trGUIDTable[i]) -- Get tr by GUID (this resolve some conflicts with getChildTrack function)
    local _, trName = reaper.GetTrackName( tr )
    local ch = reaper.GetMediaTrackInfo_Value(tr, "I_NCHAN") --Get number of channels
    reaper.SetMediaTrackInfo_Value(tr, "B_MAINSEND", 0) --Turn off send to master

    local trTag = getTag( tr )
    
    if not detectSpatPlugin( tr ) then
      --..Verify if it is a folder. If true, get their child ID.

      if string.find( trTag, "#MultiBus" ) then

        local childArr = getChildTrack(tr, 1) -- Table of child trackID
        local retval, tr_name = reaper.GetTrackName(tr)
        local currCh = 0

        for j=0, #childArr-1 do

          local childTag = getTag(childArr[j+1])
          local childStreamType, childNumCh = getAudioStream( childArr[j+1] )--getNumberOfChannel(childArr[j+1]) --Get number of channels of child
          -- Create New Track at idx and get its trackID
          local idx = reaper.CountTracks(0) + 1
          reaper.InsertTrackAtIndex(idx, true)
          local trSend = reaper.GetTrack(0, idx-1)
          reaper.SetMediaTrackInfo_Value(trSend, 'I_PERFFLAGS', 2 ) --set perf
          -- Set New Track Name
          local trSendName = trName.." tr"..i.." ToSpat"
          reaper.GetSetMediaTrackInfo_String(trSend, "P_NAME", trSendName, true)
          -- Set tag and track number of channel
          reaper.SetMediaTrackInfo_Value( trSend, "I_NCHAN", childNumCh)
          if pathTheme == "ReaVolutionTheme.ReaperTheme" then 
            reaper.BR_SetMediaTrackLayouts(trSend, "B", "B" )
          end  
          setAudioStream( trSend, childStreamType, childNumCh )
          -- setTag( trSend, childTag, childNumCh )

          for k=0, childNumCh-1 do

            local sendIdx = reaper.CreateTrackSend(tr, trSend)
            reaper.SetTrackSendInfo_Value(tr, 0, sendIdx, 'I_SENDMODE', 0)
            reaper.SetTrackSendInfo_Value(tr, 0, sendIdx, 'I_SRCCHAN', currCh+1024) --add 1024 to access to mono channels
            reaper.SetTrackSendInfo_Value(tr, 0, sendIdx, 'I_DSTCHAN', k+1024) --add 1024 to access to mono channels

            if hardwareOut < numberOutput and autoOutState == 1 and noMoreHardware == 0 then
              local outputIndex = reaper.CreateTrackSend( trSend, nil )
              reaper.SetTrackSendInfo_Value( trSend, 1, outputIndex, "I_DSTCHAN", hardwareOut+1024)
              reaper.SetTrackSendInfo_Value( trSend, 1, outputIndex, "I_SRCCHAN", j+1024)
              hardwareOut = hardwareOut + 1
            elseif autoOutState == 1 then
              reaper.MB("No more hardware outputs available", "Error", 0)
              noMoreHardware = 1
              break
            end  

            currCh = currCh + 1
          end

          if masterSendState == 0 then
            reaper.SetMediaTrackInfo_Value( trSend, "B_MAINSEND", 0)
          end
            local spatSendFX = reaper.TrackFX_AddByName(trSend, "Spat Revolution - Send", false, -1)
          reaper.TrackFX_SetParamNormalized(trSend, spatSendFX, 57, (childNumCh-1)*0.015625)
          sleep(0.1)
          if lapState == 1 then
            reaper.TrackFX_SetParamNormalized(trSend, spatSendFX, 51, 1)  
          end
          if thruState == 0 then
            reaper.TrackFX_SetParamNormalized(trSend, spatSendFX, 52, 0)
          end  

          local returnID = getSpatTrackID('Return')
          if returnID then
            for k ,v in pairs(returnID) do
              reaper.CreateTrackSend(trSend, v)
            end
          end
        end

      else --IF NOT A MULTIBUS
  
        local streamType, trNumCh = getAudioStream( tr )--getNumberOfChannel( tr )
        -- Create New Track at idx and get its trackID
        local idx = reaper.CountTracks(0) + 1
        reaper.InsertTrackAtIndex(idx, true)
        local trSend = reaper.GetTrack(0, idx-1)
        reaper.SetMediaTrackInfo_Value(trSend, 'I_PERFFLAGS', 2 ) --set perf
        -- Set New Track Name
        local trSendName = trName.." tr"..i.." ToSpat"
        reaper.GetSetMediaTrackInfo_String(trSend, "P_NAME", trSendName, true)
        -- Set tag and track number of channel
        reaper.SetMediaTrackInfo_Value( trSend, "I_NCHAN", trNumCh)
        if pathTheme == "ReaVolutionTheme.ReaperTheme" then 
          reaper.BR_SetMediaTrackLayouts(trSend, "B", "B" )
        end
        setAudioStream( trSend, streamType, trNumCh )

        local currCh = 0
        for j=0, trNumCh-1 do

          local sendIdx = reaper.CreateTrackSend(tr, trSend)
          reaper.SetTrackSendInfo_Value(tr, 0, sendIdx, 'I_SENDMODE', 0)
          reaper.SetTrackSendInfo_Value(tr, 0, sendIdx, 'I_SRCCHAN', currCh+1024) --add 1024 to access to mono channels
          reaper.SetTrackSendInfo_Value(tr, 0, sendIdx, 'I_DSTCHAN', j+1024) --add 1024 to access to mono channels
          
          if hardwareOut < numberOutput and autoOutState == 1 and noMoreHardware == 0 then
            local outputIndex = reaper.CreateTrackSend( trSend, nil )
            reaper.SetTrackSendInfo_Value( trSend, 1, outputIndex, "I_DSTCHAN", hardwareOut+1024)
            reaper.SetTrackSendInfo_Value( trSend, 1, outputIndex, "I_SRCCHAN", j+1024)
            hardwareOut = hardwareOut + 1
          elseif noMoreHardware == 0 and autoOutState == 1 then
            reaper.MB("No more hardware outputs available", "Error", 0)
            noMoreHardware = 1
            break
          end   

          currCh = currCh + 1
        end

        -- print(trNumCh*0,015625)
        if masterSendState == 0 then
          reaper.SetMediaTrackInfo_Value( trSend, "B_MAINSEND", 0)
        end
        local spatSendFX = reaper.TrackFX_AddByName(trSend, "Spat Revolution - Send", false, -1)
        reaper.TrackFX_SetParamNormalized(trSend, spatSendFX, 57, (trNumCh-1)*0.015625)
        sleep(0.1)
        if lapState == 1 then
          reaper.TrackFX_SetParamNormalized(trSend, spatSendFX, 51, 1)
        end
        if thruState == 0 then
          reaper.TrackFX_SetParamNormalized(trSend, spatSendFX, 52, 0)
        end
  
        local returnID = getSpatTrackID('Return')
        if returnID then
          for k ,v in pairs(returnID) do
            reaper.CreateTrackSend(trSend, v)
          end
        end
      end
    else
      local _, trackName = reaper.GetTrackName(tr)
      reaper.ReaScriptError(trackName..' has a Spat Revolution plugin inserted. Please unselect this track.')
    end
  end
  reaper.PreventUIRefresh(frames)
  reaper.Undo_EndBlock("Send tracks to Spat Revolution", -1)

end

main()