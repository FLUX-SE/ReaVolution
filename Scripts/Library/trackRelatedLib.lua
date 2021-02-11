--Script Name : trackRelated.lua
--Author : Jean Loup Pecquais
--Description : Track related library
--v1.0.0

function getTacksAverageColor(selTr)

local t = {}
local red = {}
local green = {}
local blue = {}

  --fill table
  for i = 1, selTr do
    local tr = reaper.GetSelectedTrack(0,i-1)
    t[i] = reaper.GetTrackColor(tr)
  end

  local count = 0
  --remove non set up track getColor
  for i, n in pairs(t) do
    if n == 0 then
      table.remove(t,i)
    else
      count = count + 1
      red[i], green[i], blue[i] = reaper.ColorFromNative(t[i])
    end
  end

  local sumR = 0
  local sumG = 0
  local sumB = 0
  for i = 1, count do
    sumR = sumR + red[i]
    sumG = sumG + green[i]
    sumB = sumB + blue[i]
  end
  if count == 0 then
    count = 1
  end
  newColor = reaper.ColorToNative(sumR//count, sumG//count, sumB//count)

  return newColor

end

function getSelTracksVis( selTr )
    --get send table
    local globalMCPvis = 0
    local globalTCPvis = 0

    for i = 1, selTr do
      local tr = reaper.GetSelectedTrack(0,i-1)
      local trTCPVis = reaper.GetMediaTrackInfo_Value(tr, "B_SHOWINTCP")
      local trMCPVis = reaper.GetMediaTrackInfo_Value(tr, "B_SHOWINMIXER")

      if trTCPVis == 1 then globalTCPvis = 1 end
      if trMCPVis == 1 then globalMCPvis = 1 end
  end

  return globalMCPvis, globalTCPvis

end

function isSelTrMono( selTr )
    --get send table
  local bool = 1
  local lastTr = 0

  for i = 1, selTr do
    local tr = reaper.GetSelectedTrack(0,i-1)
    local bool = isTrMono( tr )
    if lastTr ~= 0 then
    if reaper.GetMediaTrackInfo_Value(tr, "C_MAINSEND_OFFS") ~= reaper.GetMediaTrackInfo_Value(lastTr, "C_MAINSEND_OFFS") then bool = 0 end
    end
    if bool == 0 then return bool end
    lastTr = tr
  end
  return bool

end

function isTrMono( tr )

  local bool = 1

  local chNum = getNumberOfChannel( tr )
  local pan = reaper.GetMediaTrackInfo_Value(tr, "D_PAN")

  if chNum > 1 then bool = 0 end
  if pan ~= 0 then bool = 0 end

  return bool

end

function setTrackVis( tr, MCPVis, TCPVis )
  reaper.SetMediaTrackInfo_Value(tr, "B_SHOWINMIXER", MCPVis)
  reaper.SetMediaTrackInfo_Value(tr, "B_SHOWINTCP", TCPVis)
end

function deleteSends(selTr, arr)
	--array with destination of send.
  for k, v in ipairs(arr) do
    for i = 1, selTr do
      local tr = reaper.GetSelectedTrack(0,i-1)
      local sndNumber = reaper.GetTrackNumSends(tr, 0)
      if sndNumber ~= 0 then
        local sndIdx = 0
        while (sndIdx < sndNumber) do
          local sndDst = reaper.GetTrackSendInfo_Value(tr, 0, sndIdx, "P_DESTTRACK")
          if v == sndDst then
            reaper.RemoveTrackSend(tr, 0, sndIdx)
          else
            sndIdx = sndIdx + 1
          end
        end
      end
    end
  end
end

function deleteOuts(selTr)
  --array with destination of send.
  for i = 1, selTr do
    local tr = reaper.GetSelectedTrack(0,i-1)
    local sndNumber = reaper.GetTrackNumSends(tr, 1)
    if sndNumber ~= 0 then
      for sndIdx = 0, sndNumber do
          reaper.RemoveTrackSend(tr, 1, sndIdx)
      end
    end
  end
end


function isSendIdentical(arr1, arr2)
  local value = true
  local iter = 9
  for i = 0, iter do
    if arr1[i] ~= arr2[i] then
      value = false
    end
  end     
  return value
end

function getSendsTable( selTr )
    --get send table
    local sndTable = {}
    local sndIdx = {}

    for i = 1, selTr do
      local tr = reaper.GetSelectedTrack(0,i-1)
      local sndNumber = reaper.GetTrackNumSends(tr, 0)
      if sndNumber ~= 0 then
        for sndIdx = 0, sndNumber-1 do
            local sndParam = {}

            local sndDstCh  = reaper.GetTrackSendInfo_Value(tr, 0, sndIdx, "I_DSTCHAN")
            local sndDst    = reaper.GetTrackSendInfo_Value(tr, 0, sndIdx, "P_DESTTRACK")
            local sndMono   = reaper.GetTrackSendInfo_Value(tr, 0, sndIdx, "B_MONO")
            local sndMute   = reaper.GetTrackSendInfo_Value(tr, 0, sndIdx, "B_MUTE")
            local sndPhase  = reaper.GetTrackSendInfo_Value(tr, 0, sndIdx, "B_PHASE")
            local sndVol    = reaper.GetTrackSendInfo_Value(tr, 0, sndIdx, "D_VOL")
            local sndPan    = reaper.GetTrackSendInfo_Value(tr, 0, sndIdx, "D_PAN")
            local sndPanLaw = reaper.GetTrackSendInfo_Value(tr, 0, sndIdx, "D_PANLAW")
            local sndType   = reaper.GetTrackSendInfo_Value(tr, 0, sndIdx, "I_SENDMODE")
            local sndEnv    = reaper.GetTrackSendInfo_Value(tr, 0, sndIdx, "P_ENV")

            sndParam[0] = sndDstCh
            sndParam[1] = sndDst
            sndParam[2] = sndMono
            sndParam[3] = sndMute
            sndParam[4] = sndPhase
            sndParam[5] = sndVol
            sndParam[6] = sndPan
            sndParam[7] = sndPanLaw
            sndParam[8] = sndType
            sndParam[9] = sndEnv
            sndParam[10] = sndIdx
            sndParam[11] = tr

            table.insert(sndTable, sndParam)
        end
      end
  end

  return sndTable

end

function getOutsTable( selTr )
  --get send table
  local outTable = {}
  local sndIdx = {}

  for i = 1, selTr do
    local tr = reaper.GetSelectedTrack(0,i-1)
    local sndNumber = reaper.GetTrackNumSends(tr, 1)
    if sndNumber ~= 0 then
      for sndIdx = 0, sndNumber-1 do
          local sndParam = {}

          local sndDstCh  = reaper.GetTrackSendInfo_Value(tr, 1, sndIdx, "I_DSTCHAN")
          local sndDst    = reaper.GetTrackSendInfo_Value(tr, 1, sndIdx, "P_DESTTRACK")
          local sndMono   = reaper.GetTrackSendInfo_Value(tr, 1, sndIdx, "B_MONO")
          local sndMute   = reaper.GetTrackSendInfo_Value(tr, 1, sndIdx, "B_MUTE")
          local sndPhase  = reaper.GetTrackSendInfo_Value(tr, 1, sndIdx, "B_PHASE")
          local sndVol    = reaper.GetTrackSendInfo_Value(tr, 1, sndIdx, "D_VOL")
          local sndPan    = reaper.GetTrackSendInfo_Value(tr, 1, sndIdx, "D_PAN")
          local sndPanLaw = reaper.GetTrackSendInfo_Value(tr, 1, sndIdx, "D_PANLAW")
          local sndType   = reaper.GetTrackSendInfo_Value(tr, 1, sndIdx, "I_SENDMODE")
          local sndEnv    = reaper.GetTrackSendInfo_Value(tr, 1, sndIdx, "P_ENV")

          sndParam = {sndDstCh, sndDst, sndMono, sndMute, sndPhase, sndVol, sndPan, sndPanLaw, sndType, sndEnv, sndIdx, tr}

          table.insert(outTable, sndParam)
      end
    end
  end
-- print(outTable)
  return outTable

end

function selTracksFromTable(arr)
  reaper.Main_OnCommandEx(40297, 1, 0) --unselect all tracks
  for k, v in pairs(arr) do
    reaper.SetMediaTrackInfo_Value(v, "I_SELECTED", 1)
  end
end

function getChildTrack(tr, limitDepth)

  local trFolderDepth = reaper.GetMediaTrackInfo_Value(tr, "I_FOLDERDEPTH")
  local trIdx = reaper.GetMediaTrackInfo_Value(tr, "IP_TRACKNUMBER")
  local trTable = {}

  reaper.Main_OnCommandEx(40297, 1, 0)

  while trFolderDepth > 0 do
    local trChild = reaper.GetTrack(0, trIdx)
    if trFolderDepth <= limitDepth then
      table.insert(trTable, trChild)
    end
    trFolderDepth = trFolderDepth + reaper.GetMediaTrackInfo_Value(trChild, "I_FOLDERDEPTH")
    trIdx = trIdx + 1
  end 

  return trTable
end

function createFolderFromSelectedTracks(chNumber, chOffset, busType)
  --This function create a new folder (bus) for the selected track by inserting a new track. This also setup the JSFX audiostream
  --of the new folder track.
  --Bus Type : use 0 to do nothing, use 1 to qualify it as a normal bus, use 2 to qualify it as MultiBus. This value is linked to
  --the use with Spat Revolution

  chNumber = chNumber or 2
  chOffset = chOffset or 0

  local tr1 = reaper.GetSelectedTrack(0,0)
  local tr1Idx = reaper.GetMediaTrackInfo_Value(tr1, "IP_TRACKNUMBER")
  reaper.InsertTrackAtIndex(tr1Idx-1, true)
  reaper.ReorderSelectedTracks(tr1Idx, 1)

  local folderTr = reaper.GetTrack(0, tr1Idx-1)

  local selTr = reaper.CountSelectedTracks()
  local folderMCPVis, folderTCPvis = getSelTracksVis( selTr )
  setTrackVis( folderTr, folderMCPVis, folderTCPvis )
  
  if busType == 1 then
    setTag( folderTr, "#Bus" )
    if isSelTrMono( selTr ) == 1 then chNumber = 1 elseif chNumber == 1 then chNumber = 2 end
  elseif busType == 2 then setTag( folderTr, "#MultiBus" ) end
  
  setAudioStream( folderTr, 0, chNumber )
  reaper.SetMediaTrackInfo_Value( folderTr, 'C_MAINSEND_OFFS', chOffset )
    
  return folderTr 
end

-- function setTrackToFolderType(tr, chNumber, chOffset, busType)
--   --This function create a new folder (bus) for the selected track by inserting a new track. This also setup the JSFX audiostream
--   --of the new folder track.
--   --Bus Type : use 0 to do nothing, use 1 to qualify it as a normal bus, use 2 to qualify it as MultiBus. This value is linked to
--   --the use with Spat Revolution

--   chNumber = chNumber or 2
--   chOffset = chOffset or 0

--   local tr1 = reaper.GetSelectedTrack(0,0)
--   local tr1Idx = reaper.GetMediaTrackInfo_Value(tr1, "IP_TRACKNUMBER")
--   reaper.InsertTrackAtIndex(tr1Idx-1, true)
--   reaper.ReorderSelectedTracks(tr1Idx, 1)

--   local folderTr = reaper.GetTrack(0, tr1Idx-1)

--   local selTr = reaper.CountSelectedTracks()
--   local folderMCPVis, folderTCPvis = getSelTracksVis( selTr )
--   setTrackVis( folderTr, folderMCPVis, folderTCPvis )
  
--   if busType == 1 then
--     setTag( folderTr, "#Bus" )
--     if isSelTrMono( selTr ) == 1 then chNumber = 1 elseif chNumber == 1 then chNumber = 2 end
--   elseif busType == 2 then setTag( folderTr, "#MultiBus" ) end
  
--   setAudioStream( folderTr, 0, chNumber )
--   reaper.SetMediaTrackInfo_Value( folderTr, 'C_MAINSEND_OFFS', chOffset )
    
--   return folderTr 
-- end

function getTrackGUID( tr )
  local t = {}
  t[#t+1] = reaper.GetTrackGUID( tr )
  return t 
end

function searchTrackByName( string )
  local value = 0
        for trIdx = 0, reaper.CountTracks(0)-1 do
              local tr = reaper.GetTrack(0, trIdx)
              local _, trName = reaper.GetTrackName(tr)
              if trName == string then
                    value = tr
              end
        end
  if value == 0 then return false
  else return value end
end

function AnyTrackMute()

  local allTr = reaper.CountTracks()
  for i = 0, allTr-1 do
    local tr = reaper.GetTrack( 0, i )
    local _, mute = reaper.GetTrackUIMute(tr)
    if mute then
      return true
    end
  end

  return false

end

function getTrackbyGUID( proj, guid )
  local trNumber = reaper.CountTracks( proj )
  for i = 0, trNumber-1 do

    local tr = reaper.GetTrack( proj, i )
    local trGUID = reaper.GetTrackGUID( tr )
    print(guid)
    print(trGUID)

    if trGUID == guid then
      return tr
    end

  end
end

function getNextAvailableHardwareOut()
  local arr = {}
  local proj = 0
  local trNumber = reaper.CountTracks( proj )

  local mstTrack = reaper.GetMasterTrack( 0 )
  local numHwOutMst = reaper.GetTrackNumSends( mstTrack, 1 )
  for j = 0, numHwOutMst-1 do
    local hwChannel = reaper.GetTrackSendInfo_Value( mstTrack, 1, j, "I_DSTCHAN" )
    hwChannel = hwChannel + 1
    if hwChannel >= 1024 then
      table.insert( arr, hwChannel-1024 )
    else
      table.insert( arr, hwChannel )
      table.insert( arr, hwChannel+1 )
    end

  end


  for i = 0, trNumber-1 do
    local tr = reaper.GetTrack( proj, i )
    local numHwOut = reaper.GetTrackNumSends( tr, 1 )

    for j = 0, numHwOut-1 do
      local hwChannel = reaper.GetTrackSendInfo_Value( tr, 1, j, "I_DSTCHAN" )
      hwChannel = hwChannel + 1
      if hwChannel >= 1024 then
        table.insert( arr, hwChannel-1024 )
      else
        table.insert( arr, hwChannel )
        table.insert( arr, hwChannel+1 )
      end
    end
  end

  table.sort( arr )

  return arr[#arr]

end

function selectTracksFromArray( arr )
  for k, v in pairs(arr) do
    reaper.SetMediaTrackInfo_Value( v, "I_SELECTED" , 1 )
  end
end

function selectNextVisibleTrack()
  local lastTouchTrack = reaper.GetLastTouchedTrack()
  local folderDepth = reaper.GetMediaTrackInfo_Value(lastTouchTrack, "I_FOLDERDEPTH")
  local totalTrack = reaper.CountTracks( 0 )
  if folderDepth == 1 and reaper.GetMediaTrackInfo_Value(lastTouchTrack, "I_FOLDERCOMPACT") > 0 then
    local trID = reaper.GetMediaTrackInfo_Value(lastTouchTrack, "IP_TRACKNUMBER")
    local tr = reaper.GetTrack(0, trID)
    folderDepth = folderDepth + reaper.GetMediaTrackInfo_Value(tr, "I_FOLDERDEPTH")
    while folderDepth > 0 do
      trID = trID + 1
      tr = reaper.GetTrack(0, trID)
      folderDepth = folderDepth + reaper.GetMediaTrackInfo_Value(tr, "I_FOLDERDEPTH")
      if trID == totalTrack-1 then
        break
      end
    end
    tr = reaper.GetTrack(0, trID+1)
    tr = tr or lastTouchTrack
    reaper.Main_OnCommandEx(40297, 0, 0) -- Track: Unselect all tracks
    reaper.SetMediaTrackInfo_Value(tr, "I_SELECTED" , 1)  
  else
    reaper.Main_OnCommandEx(40285, 0, 0) -- select next track
  end
end

function selectPrevVisibleTrack()
  local lastTouchTrack = reaper.GetLastTouchedTrack()
  local trID = reaper.GetMediaTrackInfo_Value(lastTouchTrack, "IP_TRACKNUMBER") - 2
  local tr = reaper.GetTrack(0, trID)
  if tr then
    local folderDepth = reaper.GetMediaTrackInfo_Value(tr, "I_FOLDERDEPTH")
    if folderDepth <= 0 then
      folderDepth = folderDepth + reaper.GetMediaTrackInfo_Value(tr, "I_FOLDERDEPTH")
      local parentTrack = reaper.GetParentTrack(tr)
      if parentTrack then
        if reaper.GetMediaTrackInfo_Value(parentTrack, "I_FOLDERCOMPACT" ) > 0 then
          tr = parentTrack
          parentTrack = reaper.GetParentTrack( tr )
        end
      end
    end
    tr = tr or lastTouchTrack
    reaper.Main_OnCommandEx(40297, 0, 0) -- Track: Unselect all tracks
    reaper.SetMediaTrackInfo_Value(tr, "I_SELECTED" , 1)  
  else
    reaper.Main_OnCommandEx(40286, 0, 0) -- select prev track
  end
end

function selectNextVisibleTrack_Mixer()
  local lastTouchTrack = reaper.GetLastTouchedTrack()
  local folderDepth = nil
  if lastTouchTrack then
    folderDepth = reaper.GetMediaTrackInfo_Value(lastTouchTrack, "I_FOLDERDEPTH")
  else return end
  if folderDepth == 1 then
    local trID = reaper.GetMediaTrackInfo_Value(lastTouchTrack, "IP_TRACKNUMBER")
    local tr = reaper.GetTrack(0, trID)
    while reaper.GetMediaTrackInfo_Value(tr, "I_MCPW") == 0 do
      trID = trID + 1
      tr = reaper.GetTrack(0, trID)
      if tr == nil then
        break
      end
    end
    tr = tr or lastTouchTrack
    reaper.Main_OnCommandEx(40297, 0, 0) -- Track: Unselect all tracks
    reaper.SetMediaTrackInfo_Value(tr, "I_SELECTED" , 1)
  else
    reaper.Main_OnCommandEx(40285, 0, 0) -- select next track
  end
end

function selectPrevVisibleTrack_Mixer()
  local lastTouchTrack = reaper.GetLastTouchedTrack()
  if lastTouchTrack then
    local folderDepth = reaper.GetMediaTrackInfo_Value(lastTouchTrack, "I_FOLDERDEPTH")
    local trID = reaper.GetMediaTrackInfo_Value(lastTouchTrack, "IP_TRACKNUMBER")-2
    local tr = reaper.GetTrack(0, trID)
    if tr then
      local parentTrack = reaper.GetParentTrack( tr )
      if parentTrack then
        while reaper.GetMediaTrackInfo_Value(tr, "I_MCPW") == 0 do
          trID = trID - 1
          tr = reaper.GetTrack(0, trID)
          if tr == nil then
            break
          end
        end
        tr = tr or lastTouchTrack
        reaper.Main_OnCommandEx(40297, 0, 0) -- Track: Unselect all tracks
        reaper.SetMediaTrackInfo_Value(tr, "I_SELECTED" , 1)
      else
        reaper.Main_OnCommandEx(40286, 0, 0) -- select prev track
      end
    end
  end
end