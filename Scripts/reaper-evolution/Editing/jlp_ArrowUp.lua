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

local winUnderMouse, segUnderMouse, detUnderMouse = reaper.BR_GetMouseCursorContext()

if winUnderMouse == "arrange" then
    -- reaper.Main_OnCommandEx(reaper.NamedCommandLookup("_SWS_SELPREVITEM"), 0, 0) -- select prev item
    -- selectPrevVisibleTrack_JumpIfNoItems()
elseif winUnderMouse == "ruler" then
    --
elseif winUnderMouse == "mcp" then
    reaper.Main_OnCommandEx(41665, 0, 0) -- show/hide children
elseif winUnderMouse == "tcp" then
    selectPrevVisibleTrack()
end
