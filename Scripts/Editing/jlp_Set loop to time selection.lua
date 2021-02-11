--Script Name : scriptTemplate
--Author : Jean Loup Pecquais
--Description : Simple template
--v1.0.0

local libPath = reaper.GetExtState("Reaper Evolution", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Reaper Evolution library is not found. Please refer to user guide", "Library not found", 0)
    return
end

loadfile(libPath .. "reaVolutionLib.lua")()

-------------------------------------------------------------------------------------------------------------

local timeStart, timeEnd = reaper.GetSet_LoopTimeRange2( 0, false, false, 0, 0, false)
reaper.GetSet_LoopTimeRange2(0, true, true, timeStart, timeEnd, false)