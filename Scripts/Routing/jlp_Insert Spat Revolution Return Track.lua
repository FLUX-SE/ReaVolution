--Script Name : Insert Spat Revolution Return Track
--Author : Jean Loup Pecquais
--Description : Create a track to receive signal from Spat.
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
  reaper.TrackFX_AddByName(tr, "SpatRevolution/SpatRevolution_Return.rfxchain", false, -1)
  reaper.GetSetMediaTrackInfo_String( tr, 'P_NAME', "FromSpat" ,true)
  local SendID = getSpatTrackID('Send')
  if SendID then
    for k, v in pairs(SendID) do
      local parentFold = reaper.GetMediaTrackInfo_Value(v, "P_PARTRACK")
      local receiveNumber = reaper.GetTrackNumSends(tr, -1)

      if parentFold == 0 then
        reaper.CreateTrackSend(v, tr)
      else
        v = parentFold
        if receiveNumber ~= 0 then
          local rcvIdx = 0
          while (rcvIdx < receiveNumber) do
            local rcvSource = reaper.GetTrackSendInfo_Value(tr, -1, rcvIdx, "P_SRCTRACK")
            if rcvSource == v then
              rcvIdx = rcvIdx + 1
            else
              reaper.CreateTrackSend(v, tr)
              receiveNumber = receiveNumber + 1
            end
          end
        else
          reaper.CreateTrackSend(v, tr)              
        end
      end
    end
  end
end

main()