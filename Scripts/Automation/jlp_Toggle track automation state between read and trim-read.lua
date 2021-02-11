--Script Name : jlp_Toggle track automation state between read and trim-read.lua
--Author : Jean Loup Pecquais
--Description : Toggle track automation state between read and trim-read
--v1.0.0

local libPath = reaper.GetExtState("Reaper Evolution", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Reaper Evolution library is not found. Please refer to user guide", "Library not found", 0)
    return
end

loadfile(libPath .. "reaVolutionLib.lua")()

-------------------------------------------------------------------------------------------------------------

local selTr = reaper.CountSelectedTracks()
advToggleBetweenTwoAutomation( selTr, 0, 1)