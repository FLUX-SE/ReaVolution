--Script Name : jlp_Special Select Item
--Author : Jean Loup Pecquais
--Description : Special Select Item
--v1.0.0

local libPath = reaper.GetExtState("Reaper Evolution", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Reaper Evolution library is not found. Please refer to user guide", "Library not found", 0)
    return
end

loadfile(libPath .. "reaVolutionLib.lua")()

-------------------------------------------------------------------------------------------------------------

reaper.Undo_BeginBlock()
reaper.Main_OnCommandEx(40310, 0, 0) --Set ripple editing per-track
reaper.Main_OnCommandEx(40307, 0, 0) --Remove item
reaper.Main_OnCommandEx(40309, 0, 0) --Set ripple editing off
reaper.Main_OnCommandEx(40635, 0, 0) --Time selection: Remove time selection
reaper.Undo_EndBlock("Remove content of time selection, following tracks (moving later items)", -1)
