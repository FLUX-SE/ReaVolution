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

local selectTouchPreview = reaper.NamedCommandLookup("_RSbc78d846aa454189b4ee0997bfb88ad0e07cdf41")

reaper.Main_OnCommandEx(41162, 0, 0) --Automation: Write current values for all writing envelopes from cursor to end of project
reaper.Main_OnCommandEx(selectTouchPreview, 0, 0)
reaper.Main_OnCommandEx(40401, 0, 0)
