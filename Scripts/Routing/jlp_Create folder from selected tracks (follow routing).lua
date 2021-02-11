--Script Name : jlp_Create folder from selected tracks (follow routing).lua
--Author : Jean Loup Pecquais
--Description : Create a folder from selected tracks. It follow the routing of the children tracks and of some track status (visibility, merge identical sends etc...)
--v1.0.0

local libPath = reaper.GetExtState("Reaper Evolution", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Reaper Evolution library is not found. Please refer to user guide", "Library not found", 0)
    return
end

loadfile(libPath .. "reaVolutionLib.lua")()

-----------------------------------------------
-----------Functions---------------------------
-----------------------------------------------
local resourcePath = reaper.GetResourcePath()


function checkRouting(selTr)

  local t1 = {}
  local t2 = {}
  local t3 = {}

  local sndTable = {}
  local sndParam = {}
  local sndIdx = {}
  local _ = nil

  local isEqual = true

  --fill table
  for i = 1, selTr do
    local tr = reaper.GetSelectedTrack(0,i-1)
    t1[i] = reaper.GetMediaTrackInfo_Value( tr, 'C_MAINSEND_OFFS')
    t2[i] = getNumberOfChannel( tr )
    t3[i] = getNumberOfChannel( tr ) + reaper.GetMediaTrackInfo_Value( tr, 'C_MAINSEND_OFFS')
  end

  --get t_min t_max
  t1_min, t1_max = getMinMaxFromTable(t1)
  t2_min, t2_max = getMinMaxFromTable(t2)
  t3_min, t3_max = getMinMaxFromTable(t3)

  --reroot child track
  for i = 1, selTr do
    local tr = reaper.GetSelectedTrack(0,i-1)
    reaper.SetMediaTrackInfo_Value(tr, 'C_MAINSEND_OFFS', t1[i]-t1_min)
  end

  local mainSnd  =  t1_min
  local chNumber =  t3_max-t1_min

  return mainSnd, chNumber

end

-----------------------------------------------
-----------Variables---------------------------
-----------------------------------------------
local tracks = reaper.CountTracks()
local selTr = reaper.CountSelectedTracks()
if selTr == 0 then reaper.defer() return end
local mainSend, chNumber = checkRouting(selTr)
local newColor = getTacksAverageColor(selTr)
local sendToCreate = {}
local userConfirmation = -1
local answer = false
local frame = 10


reaper.Undo_BeginBlock()
reaper.PreventUIRefresh(-1*frame)


--------------------------------------------------------
-----Check and handle send from selected tracks---------
--------------------------------------------------------
if selTr ~= 0 then 
  local sndtable = getSendsTable(selTr)
  local tablesize = tablelength(sndtable)
  for i = 1, tablesize do
    local number = 0
    for j = i+1, tablesize do
      if isSendIdentical(sndtable[i], sndtable[j]) then
        number = number + 1
      end
    end
    if number >= selTr-1 then
      table.insert(sendToCreate, sndtable[i][1])
      answer = true
    end
  end
end

if answer then
  userConfirmation = reaper.ShowMessageBox("Do you want to merge identical sends on folder track ?", "Identical Sends Found", 4)
  sendToCreate = tableCleanDouble(sendToCreate)
  reaper.PreventUIRefresh(-1)
  deleteSends(selTr, sendToCreate)
  reaper.PreventUIRefresh(1)
end

---------------------------------------
-----Create and setup folder-----------
---------------------------------------

local idFolder = createFolderFromSelectedTracks(chNumber, mainSend, 1)

if userConfirmation == 6 then
  numberOfSendToCreate = tablelength(sendToCreate)
  for i = 1, numberOfSendToCreate do
    reaper.CreateTrackSend( idFolder, sendToCreate[i])
  end
end

if newColor ~= 0 then
  reaper.SetTrackColor( idFolder, newColor)
end

reaper.Main_OnCommand( 40297, 0 ) --unselect all tracks
reaper.SetMediaTrackInfo_Value( idFolder, "I_SELECTED" , 1 )

reaper.PreventUIRefresh(frame)

reaper.Main_OnCommand( 40696, 0 ) --Track: Rename last touched track
reaper.Undo_EndBlock('Create folder from selected tracks', -1)