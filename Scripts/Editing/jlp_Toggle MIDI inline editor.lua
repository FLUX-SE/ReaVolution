--Script Name : jlp_Toggle MIDI inline editor
--Author : Jean Loup Pecquais
--Description : Toggle MIDI inline editor
--v1.0.0

local libPath = reaper.GetExtState("Reaper Evolution", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Reaper Evolution library is not found. Please refer to user guide", "Library not found", 0)
    return
end

loadfile(libPath .. "reaVolutionLib.lua")()

-------------------------------------------------------------------------------------------------------------

function main()
    local itemSel = reaper.CountSelectedMediaItems( 0 )
    for i = 0, itemSel-1 do
        local item = reaper.GetSelectedMediaItem( 0, i )
        local take = reaper.GetActiveTake( item )
        local isInline = reaper.BR_IsMidiOpenInInlineEditor( take )
        if isInline then
            reaper.Main_OnCommandEx(41887 , 0, 0)
        else
            reaper.Main_OnCommandEx( 40847, 0, 0 )
        end
        -- isInline = nil
    end
    reaper.UpdateArrange()
end

reaper.defer(main)