--Script Name : spatRevolutionLib
--Author : Jean Loup Pecquais
--Description : Spat Revolution related library
--v1.0.0

function getSpatTrackID(filter)
  local trackArr = {}

  for trIdx = 0, reaper.CountTracks(0)-1 do
    tr = reaper.GetTrack(0, trIdx)
    for fxIdx=0,reaper.TrackFX_GetCount(tr)-1 do
      local _, fxName = reaper.TrackFX_GetFXName(tr, fxIdx, '')
      if fxName:find('Spat Revolution') and fxName:find(filter) then
        table.insert(trackArr, tr)
      end
    end
  end

  return trackArr

end

function detectSpatPlugin(tr)
  output = false

  for fxIdx=0,reaper.TrackFX_GetCount(tr)-1 do
    local _, fxName = reaper.TrackFX_GetFXName(tr, fxIdx, '')
    if fxName:find('Spat Revolution') then
      output = true
    end
  end

  return output

end

function setSelTracksChannelsNumber( selTr, chNumber )
  for i = 1, selTr do
      local tr = reaper.GetSelectedTrack(0,i-1)
      reaper.SetMediaTrackInfo_Value(tr, "I_NCHAN", chNumber)
        for fxIdx=0,reaper.TrackFX_GetCount(tr)-1 do
      local _, fxName = reaper.TrackFX_GetFXName(tr, fxIdx, '')
        if fxName:find('Spat Revolution') then
          bitmask = calculateBitMask( chNumber )
          reaper.TrackFX_SetPinMappings( tr, fxIdx, 0, 0, bitmask, 0 )
          end
      end
  end
end