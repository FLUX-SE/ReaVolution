--Script Name : jlp_Go to next marker (no seeking).lua
--Author : Jean Loup Pecquais
--Description : Go to next marker (no seeking)
--v1.0.0

local libPath = reaper.GetExtState("Reaper Evolution", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Reaper Evolution library is not found. Please refer to user guide", "Library not found", 0)
    return
end

loadfile(libPath .. "reaVolutionLib.lua")()

-------------------------------------------------------------------------------------------------------------

setEditCursorToPrevMarker()