--Script Name : Receive from Spat Revolution
--Author : Jean Loup Pecquais
--Description : Receive signal from Spat Revolution.
--v1.0.0

local libPath = reaper.GetExtState("Reaper Evolution", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Reaper Evolution library is not found. Please refer to user guide", "Library not found", 0)
    return
end

loadfile(libPath .. "reaVolutionLib.lua")()

function main()

  for i = 1, reaper.CountSelectedTracks(0) do
    local tr = reaper.GetSelectedTrack(0,i-1)
    if tr then
      local trNumCh = getNumberOfChannel( tr )
      local lapState =  tonumber(reaper.GetExtState( "ReaVolution", "Default LAP" ))
      local overrideState =  tonumber(reaper.GetExtState( "ReaVolution", "Default override" ))

      reaper.SetMediaTrackInfo_Value( tr, "I_NCHAN", trNumCh)
      local spatReturn = reaper.TrackFX_AddByName(tr, "Spat Revolution - Return", false, -1)
      reaper.TrackFX_SetParamNormalized(tr, spatReturn, 7, (trNumCh-1)*0.015625)

      if lapState == 1 then
        reaper.TrackFX_SetParamNormalized(tr, spatReturn, 3, 1)
      end
      if overrideState == 0 then
        reaper.TrackFX_SetParamNormalized(tr, spatReturn, 4, 0)
      end

      reaper.SetMediaTrackInfo_Value(tr, 'B_SHOWINTCP', 0 )
      reaper.SetMediaTrackInfo_Value(tr, 'I_PERFFLAGS', 2 )
      local _, currName = reaper.GetSetMediaTrackInfo_String(tr, "P_NAME", "", 0)
      if not currName:find('FromSpat') then
        reaper.GetSetMediaTrackInfo_String(tr, "P_NAME", currName..'FromSpat', 1)
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
    end
  end
end

main()