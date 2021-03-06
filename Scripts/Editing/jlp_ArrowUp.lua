--Script Name : ArrowRight.lua
--Author : Jean Loup Pecquais
--Description : take care of right arrow action depending of context
--v1.0.0

local libPath = reaper.GetExtState("Reaper Evolution", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Reaper Evolution library is not found. Please refer to user guide", "Library not found", 0)
    return
end

loadfile(libPath .. "reaVolutionLib.lua")()

-------------------------------------------------------------------------------------------------------------

local title = reaper.BR_GetMouseCursorContext()

if title == "arrange" then
    -- reaper.Main_OnCommandEx(reaper.NamedCommandLookup("_SWS_SELPREVITEM"), 0, 0) -- select prev item
    -- selectPrevVisibleTrack_JumpIfNoItems()
elseif title == "ruler" then
    --
elseif title == "mcp" then
    reaper.Main_OnCommandEx(41665, 0, 0) -- show/hide children
elseif title == "tcp" then
    selectPrevVisibleTrack()
end
