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
--print(winUnderMouse)

if winUnderMouse == "arrange" then
    -- getNextItemOnSelTr()
    reaper.Main_OnCommandEx(reaper.NamedCommandLookup("_SWS_SELNEXTITEM"), 0, 0) -- select next item
elseif winUnderMouse == "ruler" then
    setEditCursorToNextMarker()
elseif winUnderMouse == "mcp" then
    selectNextVisibleTrack_Mixer()
elseif winUnderMouse == "tcp" then
    reaper.Main_OnCommandEx(reaper.NamedCommandLookup("_SWS_UNCOLLAPSE"), 0, 0) -- cycle collapse folder
end
