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
    -- getPrevItemOnSelTr()
    reaper.Main_OnCommandEx(reaper.NamedCommandLookup("_SWS_SELPREVITEM"), 0, 0) -- select prev item
elseif title == "ruler" then
    setEditCursorToPrevMarker()
elseif title == "mcp" then
    selectPrevVisibleTrack_Mixer()
elseif title == "tcp" then
    reaper.Main_OnCommandEx(reaper.NamedCommandLookup("_SWS_COLLAPSE"), 0, 0) -- cycle collapse folder
end
