--Script Name : Go to marker.lua
--Author : Jean Loup Pecquais
--Description : Go to marker by index or name
--v1.0.0

-- local libPath = reaper.GetExtState("Reaper Evolution", "libPath")
-- if not libPath or libPath == "" then
--     reaper.MB("Reaper Evolution library is not found. Please refer to user guide", "Library not found", 0)
--     return
-- end

-- loadfile(libPath .. "reaVolutionLib.lua")()

-------------------------------------------------------------------------------------------------------------

local seekForPlayback = true

local isOk, answer = reaper.GetUserInputs("Got to marker..", 1, "Choose mrkr by name or idx", "")

if isOk then
    local _, num_markers, num_regions = reaper.CountProjectMarkers(0)
    for i = 0, num_markers-1 do
        local retval, isrgn, pos, rgnend, name, markrgnindexnumber = reaper.EnumProjectMarkers2(0, i)
        if retval then
            if not isrgn then
                if tonumber(answer) == markrgnindexnumber then
                    reaper.SetEditCurPos2(0, pos, true, seekForPlayback)
                    return
                elseif string.find(name, answer) then
                    reaper.SetEditCurPos2(0, pos, true, seekForPlayback)
                    return
                end
            end
        end
    end
end