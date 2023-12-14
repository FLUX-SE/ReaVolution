--@noindex
--@author FLUX::
--@version 23.12.0

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
    -- reaper.Main_OnCommandEx(reaper.NamedCommandLookup("_SWS_SELPREVITEM"), 0, 0) -- select prev item
    -- getNextTrackAcrossTrack()
elseif title == "timeline" then
    --
elseif class == "REAPERMCPDisplay" then
    reaper.Main_OnCommandEx(41665, 0, 0) -- show/hide children
elseif class == "REAPERTCPDisplay" then
    selectNextVisibleTrack()
end
