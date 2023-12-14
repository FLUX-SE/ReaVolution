--@noindex
--@author FLUX::
--@version 23.12.0

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
    local itemVol = reaper.GetMediaItemInfo_Value( item, "D_VOL" )
    local gainDB = -0.1
    local gainLinear = 10^(gainDB/20)
    local itemVol = itemVol*gainLinear
    reaper.SetMediaItemInfo_Value( item, "D_VOL", itemVol )
    reaper.UpdateTimeline()
end

--reaper.GetActiveTake(MediaItem item)