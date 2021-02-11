--Script Name : jlp_Past items to replace time selection
--Author : Jean Loup Pecquais
--Description : Past items to replace time selection
--v1.0.0

local libPath = reaper.GetExtState("Reaper Evolution", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Reaper Evolution library is not found. Please refer to user guide", "Library not found", 0)
    return
end

loadfile(libPath .. "reaVolutionLib.lua")()

-------------------------------------------------------------------------------------------------------------

function main()
    local frames = 10
    local startTime, endTime = reaper.GetSet_LoopTimeRange(false, false, 0, 0, true)

    if startTime ~= endTime then
        reaper.Undo_BeginBlock()
        reaper.PreventUIRefresh(-1*frames)
        
        globalPaste( startTime, endTime )
        
        reaper.PreventUIRefresh(frames)
        reaper.Undo_EndBlock("Paste and replace time selection", -1)
    else
        return
    end
    
end

main()