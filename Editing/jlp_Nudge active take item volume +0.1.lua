--Script Name : jlp_Nudge item volume +1.lua
--Author : Jean Loup Pecquais
--Description : Nudge item volume +1
--v1.0.0

local libPath = reaper.GetExtState("Reaper Evolution", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Reaper Evolution library is not found. Please refer to user guide", "Library not found", 0)
    return
end

loadfile(libPath .. "reaVolutionLib.lua")()

-------------------------------------------------------------------------------------------------------------

local selItem = reaper.CountSelectedMediaItems( 0 )
for i = 0, selItem-1 do
    local item = reaper.GetMediaItem( 0, i )
    local take = reaper.GetActiveTake(item)
    local takeVol = reaper.GetMediaItemTakeInfo_Value( take, "D_VOL" )
    local gainDB = 0.1
    local gainLinear = 10^(gainDB/20)
    local takeVol = takeVol*gainLinear
    reaper.SetMediaItemTakeInfo_Value( take, "D_VOL", takeVol )
    reaper.UpdateTimeline()
end
