--Script Name : Collapse mono item to stereo.lua
--Author : Jean Loup Pecquais
--Description : Collapse mono item to stereo.lua
--v1.0.0

-- local libPath = reaper.GetExtState("Reaper Evolution", "libPath")
-- if not libPath or libPath == "" then
--     reaper.MB("Reaper Evolution library is not found. Please refer to user guide", "Library not found", 0)
--     return
-- end

-- loadfile(libPath .. "reaVolutionLib.lua")()

-------------------------------------------------------------------------------------------------------------

reaper.Undo_BeginBlock()

local selItems = reaper.CountSelectedMediaItems(0)
if selItems ~= 2 then
    return
end

local item1 = reaper.GetMediaItem(0, 0)
local item2 = reaper.GetMediaItem(0, 1)

if reaper.CountTakes(item1) > 1 or reaper.CountTakes(item2) > 2 then return end

local item1_pos = reaper.GetMediaItemInfo_Value( item1, "D_POSITION" )

local take1 = reaper.GetMediaItemTake(item1, 0)
local take2 = reaper.GetMediaItemTake(item2, 0)

local take1_offset = reaper.GetMediaItemTakeInfo_Value(take1, "D_STARTOFFS" )

reaper.SetMediaItemTakeInfo_Value( take1, "D_PAN" , -1)
reaper.SetMediaItemTakeInfo_Value( take2, "D_PAN" , 1)

local pcm_source1 = reaper.GetMediaItemTake_Source(take1)
local pcm_source2 = reaper.GetMediaItemTake_Source(take2)

local source1_length = reaper.GetMediaSourceLength(pcm_source1)
local source2_length = reaper.GetMediaSourceLength(pcm_source2)

local source1_chCount = reaper.GetMediaSourceNumChannels(pcm_source1)
local source2_chCount = reaper.GetMediaSourceNumChannels(pcm_source2)

if source1_length == source2_length and source1_chCount == 1 and source2_chCount == 1 then
    reaper.SetMediaItemInfo_Value( item2, "D_POSITION", item1_pos )
    reaper.SetMediaItemTakeInfo_Value( take2, "D_STARTOFFS", take1_offset )
    reaper.MoveMediaItemToTrack( item2, reaper.GetMediaItem_Track( item1 ))
    reaper.Main_OnCommandEx( 41588, 1, 0 )
else
    return
end

reaper.Undo_EndBlock("Collapse mono to stereo", 0)