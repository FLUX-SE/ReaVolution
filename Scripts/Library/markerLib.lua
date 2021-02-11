--Script Name : markerLib.lua
--Author : Jean Loup Pecquais
--Description : General marker lib
--v1.0.0

function getNextMarker()
    local numMark = reaper.CountProjectMarkers(0)
    local cursorTime = reaper.GetCursorPosition()
    for i = 0, numMark-1 do
        local retval, isrgn, pos, rgnend, name, markrgnindexnumber = reaper.EnumProjectMarkers( i )
        if pos > cursorTime then
            return pos
        end
    end
end

function setEditCursorToNextMarker()
    local pos = getNextMarker() or reaper.GetCursorPosition()
    reaper.SetEditCurPos( pos, true, false )
end

function getPrevMarker()
    local numMark = reaper.CountProjectMarkers(0)
    local cursorTime = reaper.GetCursorPosition()
    for i = numMark-1, 0, -1 do
        local retval, isrgn, pos, rgnend, name, markrgnindexnumber = reaper.EnumProjectMarkers( i )
        if pos < cursorTime then
            return pos
        end
    end
end

function setEditCursorToPrevMarker()
    local pos = getPrevMarker() or 0
    reaper.SetEditCurPos( pos, true, false )
end