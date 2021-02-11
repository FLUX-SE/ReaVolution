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

local x,y = reaper.GetMousePosition() -- get x,y of the mouuse
local winUnderMouse = reaper.JS_Window_FromPoint(x, y)
local title = reaper.JS_Window_GetTitle( winUnderMouse )
local class = reaper.JS_Window_GetClassName( winUnderMouse )

if title == "trackview" then
    -- getNextItemOnSelTr()
    reaper.Main_OnCommandEx(reaper.NamedCommandLookup("_SWS_SELNEXTITEM"), 0, 0) -- select next item
elseif title == "timeline" then
    setEditCursorToNextMarker()
elseif class == "REAPERMCPDisplay" then
    selectNextVisibleTrack_Mixer()
elseif class == "REAPERTCPDisplay" then
    reaper.Main_OnCommandEx(reaper.NamedCommandLookup("_SWS_UNCOLLAPSE"), 0, 0) -- cycle collapse folder
end
