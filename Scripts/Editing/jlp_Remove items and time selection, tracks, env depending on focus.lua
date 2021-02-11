--Script Name : jlp_Remove items and time selection, tracks, env depending on focus
--Author : Jean Loup Pecquais
--Description : Remove items and time selection, tracks, env depending on focus
--v1.0.0

local libPath = reaper.GetExtState("Reaper Evolution", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Reaper Evolution library is not found. Please refer to user guide", "Library not found", 0)
    return
end

loadfile(libPath .. "reaVolutionLib.lua")()

-------------------------------------------------------------------------------------------------------------

local frames = 10
reaper.PreventUIRefresh(-1*frames)
reaper.Undo_BeginBlock()

local delete = reaper.NamedCommandLookup("_SWS_SMARTREMOVE")
reaper.Main_OnCommandEx(delete, 0, 0)
reaper.Main_OnCommandEx(40289, 0, 0)

if reaper.GetCursorContext() == 1 then 
    if reaper.GetToggleCommandState(40573) ~= 1 then
        reaper.Main_OnCommandEx(40635, 0, 0) --Time selection: Remove time selection
    end
end

reaper.Undo_EndBlock("Remove items, tracks or envelope depending on focus", -1)
reaper.PreventUIRefresh(frames)