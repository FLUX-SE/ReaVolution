--Script Name : scriptTemplate
--Author : Jean Loup Pecquais
--Description : Simple template
--v1.0.0

local libPath = reaper.GetExtState("Reaper Evolution", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Reaper Evolution library is not found. Please refer to user guide", "Library not found", 0)
    return
end

loadfile(libPath .. "reaVolutionLib.lua")()

-------------------------------------------------------------------------------------------------------------

reaper.Main_OnCommandEx(40528, 0, 0)--Item: Select item under mouse cursor
local selItem = reaper.GetMediaItem(0, 0)

if itemIsInTimeSelection(selItem) or itemCrossTimeInterval(selItem) then
    reaper.Main_OnCommandEx(40635, 0, 0)--Time selection: Remove time selection
    
end
