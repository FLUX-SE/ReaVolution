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

function main()
    
    for i = 0, reaper.CountSelectedMediaItems( 0 )-1 do
        local item = reaper.GetSelectedMediaItem(0, i)
        moveItemSnapOffsetToEditCursor( item )
    end
end

reaper.Undo_BeginBlock()
main()
reaper.Undo_EndBlock("Move selected item(s) snap offset to edit cursor", -1)
