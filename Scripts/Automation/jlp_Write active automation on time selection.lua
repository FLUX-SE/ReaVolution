--Script Name : jlp_Write active automation on time selection.lua
--Author : Jean Loup Pecquais
--Description : Write active automation on time selection
--v1.0.0

local libPath = reaper.GetExtState("Reaper Evolution", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Reaper Evolution library is not found. Please refer to user guide", "Library not found", 0)
    return
end

loadfile(libPath .. "reaVolutionLib.lua")()

-------------------------------------------------------------------------------------------------------------

local selectTouchPreview = reaper.NamedCommandLookup("_RSbc78d846aa454189b4ee0997bfb88ad0e07cdf41")

reaper.Main_OnCommandEx(42013, 0, 0) --Automation: Write current values for actively-writing envelopes to time selection
reaper.Main_OnCommandEx(selectTouchPreview, 0, 0)
reaper.Main_OnCommandEx(40401, 0, 0)

