--Script Name : jlp_Select track in Write mode.lua
--Author : Jean Loup Pecquais
--Description : Select track in Write mode
--v1.0.0

local libPath = reaper.GetExtState("Reaper Evolution", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Reaper Evolution library is not found. Please refer to user guide", "Library not found", 0)
    return
end

loadfile(libPath .. "reaVolutionLib.lua")()

-------------------------------------------------------------------------------------------------------------
reaper.Undo_BeginBlock() -- Begining of the undo block. Leave it at the top of your main function.
selectTrackByAutomationState( 4 )
reaper.Undo_EndBlock("Select only tracks with Latch automation mode", -1)
