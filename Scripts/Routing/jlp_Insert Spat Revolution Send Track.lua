--Script Name : Insert Spat Revolution Send Track
--Author : Jean Loup Pecquais
--Description : Create a track to send signal from Spat.
--v1.0.0

local libPath = reaper.GetExtState("Reaper Evolution", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Reaper Evolution library is not found. Please refer to user guide", "Library not found", 0)
    return
end

loadfile(libPath .. "reaVolutionLib.lua")()

function main()
  local newTrackIdx = reaper.CountTracks(0)
  reaper.InsertTrackAtIndex(newTrackIdx, false)
    local tr = reaper.GetTrack(0, newTrackIdx)
    reaper.SetMediaTrackInfo_Value(tr, 'B_SHOWINTCP', 0 )
    reaper.SetMediaTrackInfo_Value(tr, 'I_PERFFLAGS', 2 )
    reaper.TrackFX_AddByName(tr, "SpatRevolution/SpatRevolution_Send.rfxchain", false, -1)
    reaper.GetSetMediaTrackInfo_String( tr, 'P_NAME', "ToSpat" ,true)
    local returnID = getSpatTrackID('Return')
    if returnID then
      for k ,v in pairs(returnID) do
        reaper.CreateTrackSend(tr, v)
      end
    end
end

main()