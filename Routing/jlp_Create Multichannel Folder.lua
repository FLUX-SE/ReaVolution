--Script Name : jlp_Create Multichannel Folder.lua
--Author : Jean Loup Pecquais
--Description : Create a multichannel folder where each first level children is routed to one channel of the parent
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

  local ch = 0

  for j=0, selTr-1 do

    local  tr = reaper.GetSelectedTrack(0, j)
    local moduloTr = j % 2
    local thisTrNumberOfChannel = getNumberOfChannel(  tr )

    if thisTrNumberOfChannel == 1 then
      reaper.SetMediaTrackInfo_Value( tr, 'B_MAINSEND', 1 )
      -- local numHardwareOutput = reaper.GetTrackNumSends( thisTr, 1 )

      if moduloTr == 0 then
        reaper.SetMediaTrackInfo_Value( tr, 'D_PAN', -1)
        reaper.SetMediaTrackInfo_Value( tr, 'C_MAINSEND_OFFS', ch )
      else
        reaper.SetMediaTrackInfo_Value( tr, 'D_PAN', 1)
        reaper.SetMediaTrackInfo_Value( tr, 'C_MAINSEND_OFFS', ch-1 )
      end
    else
      reaper.SetMediaTrackInfo_Value( tr, 'C_MAINSEND_OFFS', ch )
    end
    ch = math.floor(ch + thisTrNumberOfChannel)
  end

  return 0, ch
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
local outToCreate = {}
local userConfirmation = -1
local answer = false
local frame = 10

--------------------------------------------------------
--Check and handle physical output from selected tracks-
--------------------------------------------------------

if selTr ~= 0 then 
  local outTable = getOutsTable(selTr)
  local tablesize = tablelength(outTable)
  for i = 1, tablesize do
      table.insert(outToCreate, outTable[i][1])
  end
end

  reaper.PreventUIRefresh(-1)
  deleteOuts(selTr, outToCreate)
  reaper.PreventUIRefresh(1)


---------------------------------------
-----Create and setup folder-----------
---------------------------------------

reaper.Undo_BeginBlock()
reaper.PreventUIRefresh(-1*frame)

local idFolder = createFolderFromSelectedTracks(chNumber, mainSend, 2)

if newColor ~= 0 then
  reaper.SetTrackColor( idFolder, newColor )
end

reaper.Main_OnCommand( 40297, 0 ) --unselect all tracks
reaper.SetMediaTrackInfo_Value( idFolder, "I_SELECTED" , 1 )

reaper.PreventUIRefresh(frame)

reaper.Main_OnCommand( 40696, 0 ) --Track: Rename last touched track
reaper.Undo_EndBlock('Create folder from selected tracks', -1)