--Script Name : jlp_Copy all items in time selection
--Author : Jean Loup Pecquais
--Description : Copy all items in time selection
--v1.0.0

local libPath = reaper.GetExtState("Reaper Evolution", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Reaper Evolution library is not found. Please refer to user guide", "Library not found", 0)
    return
end

loadfile(libPath .. "reaVolutionLib.lua")()

-------------------------------------------------------------------------------------------------------------

function main()
    reaper.Undo_BeginBlock()  
    
    reaper.Main_OnCommandEx(40717, 0, 0)--Select all item in time selection
    startTime, endTime = reaper.GetSet_LoopTimeRange(false, false, 0, 0, true)
    globalCopy( startTime, endTime )
    
    reaper.Undo_EndBlock("Copy", -1)
end

local frames = 10
reaper.PreventUIRefresh(-1*frames)
main()
reaper.PreventUIRefresh(frames)