--Script Name : jlp_Insert time and paste items
--Author : Jean Loup Pecquais
--Description : Insert time and paste items
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
    globalPaste()
    reaper.Undo_EndBlock("Paste and replace time selection", -1)

end

local frames = 10
reaper.PreventUIRefresh(-1*frames)
main()
reaper.PreventUIRefresh(frames)