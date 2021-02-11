--Script Name : jlp_Set Edit Cursor to Mouse Position
--Author : Jean Loup Pecquais
--Description : Set Edit Cursor to Mouse Position
--v1.0.0

local libPath = reaper.GetExtState("Reaper Evolution", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Reaper Evolution library is not found. Please refer to user guide", "Library not found", 0)
    return
end

loadfile(libPath .. "reaVolutionLib.lua")()

-------------------------------------------------------------------------------------------------------------

local position =  reaper.SnapToGrid(0, reaper.BR_PositionAtMouseCursor( false ))
reaper.SetEditCurPos(position, true, false)
