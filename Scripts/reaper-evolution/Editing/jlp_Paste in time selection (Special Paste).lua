--Script Name : jlp_Paste in time selection (Special Paste)
--Author : Jean Loup Pecquais
--Description : Paste in time selection (Special Paste)
--v1.0.0

local libPath = reaper.GetExtState("Reaper Evolution", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Reaper Evolution library is not found. Please refer to user guide", "Library not found", 0)
    return
end

loadfile(libPath .. "reaVolutionLib.lua")()

-------------------------------------------------------------------------------------------------------------

local frames = 10

function main()
    -- local pasteItemGUID
    -- local replacedItemGUID
    reaper.Undo_BeginBlock()
    reaper.Main_OnCommandEx(40309, 0, 0) --Set ripple editing off
    reaper.Main_OnCommandEx(40630, 0, 0) --Go to start of time selection
    reaper.Main_OnCommandEx(40058, 0, 0) --Item: Paste items/tracks
    reaper.Main_OnCommandEx(40508, 0, 0) --Item: Trim items to selected area
    reaper.Main_OnCommandEx(reaper.NamedCommandLookup("_SWS_LOOPITEMSECTION"), 0, 0) --
    reaper.Main_OnCommandEx(40631, 0, 0) --Go to end of time selection
    reaper.Main_OnCommandEx(41311, 0, 0) --Item edit: Trim right edge of item to edit cursor
    reaper.Main_OnCommandEx(reaper.NamedCommandLookup("_SWS_SELNEXTITEM"), 0, 0) --SWS: Select next item (across tracks)
    reaper.Main_OnCommandEx(41305, 0, 0) --Item edit: Trim left edge of item to edit cursor
    reaper.Main_OnCommandEx(reaper.NamedCommandLookup("_SWS_SELPREVITEM"), 0, 0) --SWS: Select previous item (across tracks)
    reaper.Main_OnCommandEx(40225, 0, 0) --Item edit: Grow left edge of items
    reaper.Main_OnCommandEx(40225, 0, 0) --Item edit: Grow left edge of items
    reaper.Main_OnCommandEx(40228, 0, 0) --Item edit: Grow right edge of items
    reaper.Main_OnCommandEx(40228, 0, 0) --Item edit: Grow right edge of items

    -- local pasteItem = reaper.BR_GetMediaItemByGUID( 0, pasteItemGUID )
    -- local replacedItem = reaper.BR_GetMediaItemByGUID( 0, replacedItemGUID )


    reaper.Undo_EndBlock("Paste in time selection (Special Paste)", -1)
end

reaper.PreventUIRefresh(-1*frames)
main()
reaper.PreventUIRefresh(frames)