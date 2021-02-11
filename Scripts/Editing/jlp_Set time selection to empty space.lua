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

function main()
    reaper.BR_GetMouseCursorContext()
    local track = reaper.BR_GetMouseCursorContext_Track()
    local itemUnderMouse = reaper.BR_GetMouseCursorContext_Item()
    local position = reaper.BR_PositionAtMouseCursor( false )
    local itemStart = {}
    local itemEnd = {}
    local closestEdge1, closestEdge2

    if reaper.CountTrackMediaItems(track) == 0 then return end

    if itemUnderMouse == nil then
        local j = 1
        for i=1, reaper.CountMediaItems(0) do
            local item = reaper.GetMediaItem( 0, i-1 )
            local isHold = reaper.MediaItemDescendsFromTrack(item, track)
            if isHold == 1 then
                itemStart[j] = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
                itemEnd[j] = itemStart[j] + reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
                -- table.insert(itemStart, reaper.GetMediaItemInfo_Value(item, "D_POSITION"))
                -- table.insert(itemEnd, itemStart[i] + reaper.GetMediaItemInfo_Value(item, "D_LENGTH"))
                -- print(itemStart[i])
                -- print(itemEnd[i])
                local val = position - itemEnd[j]
                if val < 0 then
                    closestEdge1 = itemEnd[j-1] or 0
                    closestEdge2 = itemStart[j]
                    if closestEdge2 ~= nil then reaper.GetSet_LoopTimeRange2(0, true, false, closestEdge1, closestEdge2, true) end
                    return
                end
                j = j+1
            end
        end
    end
end

main()