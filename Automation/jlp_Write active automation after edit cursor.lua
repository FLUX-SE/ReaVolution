--Script Name : jlp_Write active automation after edit cursor.lua
--Author : Jean Loup Pecquais
--Description : Write active automation after edit cursor
--v1.0.0

local libPath = reaper.GetExtState("Reaper Evolution", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Reaper Evolution library is not found. Please refer to user guide", "Library not found", 0)
    return
end

loadfile(libPath .. "reaVolutionLib.lua")()

-------------------------------------------------------------------------------------------------------------

local selectTouchPreview = reaper.NamedCommandLookup("_RSbc78d846aa454189b4ee0997bfb88ad0e07cdf41")

reaper.Main_OnCommandEx(42015, 0, 0) --Automation: Write current values for actively-writing envelopes from cursor to end of project
reaper.Main_OnCommandEx(selectTouchPreview, 0, 0)
reaper.Main_OnCommandEx(40401, 0, 0)
