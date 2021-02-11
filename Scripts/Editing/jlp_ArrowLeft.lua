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
    -- getPrevItemOnSelTr()
    reaper.Main_OnCommandEx(reaper.NamedCommandLookup("_SWS_SELPREVITEM"), 0, 0) -- select prev item
elseif title == "timeline" then
    setEditCursorToPrevMarker()
elseif class == "REAPERMCPDisplay" then
    selectPrevVisibleTrack_Mixer()
elseif class == "REAPERTCPDisplay" then
    reaper.Main_OnCommandEx(reaper.NamedCommandLookup("_SWS_COLLAPSE"), 0, 0) -- cycle collapse folder
end
