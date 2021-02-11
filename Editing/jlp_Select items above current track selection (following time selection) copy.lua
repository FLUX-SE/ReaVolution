--Script Name : jlp_Select bellow item (following time selection)
--Author : Jean Loup Pecquais
--Description : Select item bellow
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
    reaper.Undo_BeginBlock()
    -- local selItem = reaper.CountSelectedMediaItems( 0 )
    local item = reaper.GetSelectedMediaItem( 0, 0 )
    if item then
        local tr = reaper.GetMediaItemTrack(item)
        local trIp = reaper.GetMediaTrackInfo_Value( tr, "IP_TRACKNUMBER")
        reaper.Main_OnCommandEx(40297, 0, 0) --Track: Unselect all tracks
        for i = 0, reaper.CountTracks(0)-1 do
            tr = reaper.GetTrack(0, i)
            local tr2Ip = reaper.GetMediaTrackInfo_Value( tr, "IP_TRACKNUMBER")
            if tr2Ip == trIp - 1 then tr2Ip = reaper.SetMediaTrackInfo_Value( tr, "I_SELECTED", 1) end
        end
    else 
        reaper.Main_OnCommandEx(40286, 0, 0) --Go to previous track 
    end
    reaper.Main_OnCommandEx(40289, 0, 0) --Item: Unselect all items
    reaper.Main_OnCommandEx(40718, 0, 0) --Item: Select all items on selected tracks in current time selection


    reaper.Undo_EndBlock("Select item bellow", -1)
end

reaper.PreventUIRefresh(-1*frames)
main()
reaper.PreventUIRefresh(frames)

--40285 Track: Go to next track