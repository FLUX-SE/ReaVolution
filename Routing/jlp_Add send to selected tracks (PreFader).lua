--Script Name : Add send to selected Track - Pre Fader
--Author : Jean Loup Pecquais
--Description : Add send to selected Track - Pre Fader.
--v1.0.0

local libPath = reaper.GetExtState("Reaper Evolution", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Reaper Evolution library is not found. Please refer to user guide", "Library not found", 0)
    return
end

loadfile(libPath .. "reaVolutionLib.lua")()

local arr = {}
    
function main()

  reaper.Undo_BeginBlock()

  local frame = 10
  reaper.PreventUIRefresh(-1*frame)

  for i = 1, reaper.CountSelectedTracks(0) do
    local tr = reaper.GetSelectedTrack(0,i-1)
    if tr then 
      _, srcName = reaper.GetTrackName ( tr )
      local srcStream, srcCh = getAudioStream( tr )

      reaper.InsertTrackAtIndex( reaper.GetNumTracks(0), true )
      dstTr =  reaper.CSurf_TrackFromID( reaper.GetNumTracks(0), false )
      setAudioStream( dstTr, srcStream, srcCh )
      
      sendId = reaper.CreateTrackSend( tr, dstTr)
      if sendId >= 0 then
        newName = "From"..' '..srcName
        if dstTr then
          reaper.GetSetMediaTrackInfo_String( dstTr, 'P_NAME', newName ,true)
          reaper.SetTrackSendInfo_Value( tr, 0, sendId, 'I_SENDMODE', 3)
          table.insert( arr, dstTr )
        end
      end
    end
    reaper.TrackList_AdjustWindows( false )
  end

  reaper.Main_OnCommand( 40297, 0 ) --unselect all tracks
  selectTracksFromArray( arr )
  reaper.PreventUIRefresh(frame)

  reaper.Undo_EndBlock("Create pre-fader sends", -1)

end

main()