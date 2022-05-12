--Script Name : automationLib
--Author : Jean Loup Pecquais
--Description : Automation related library
--v1.0.0

automMode = {"Trim/Read","Read", "Touch", "Write", "Latch", "Latch preview"}

function getAutomMode(automStr)
    return getIndexFromValue(automMode, automStr)
end

function toggleBetweenTwoAutomation( tr, autom1, autom2 )
    local getAutom = reaper.GetMediaTrackInfo_Value( tr, "I_AUTOMODE" )
    if getAutom == autom1 then
        reaper.SetMediaTrackInfo_Value( tr, "I_AUTOMODE", autom2 )
    elseif getAutom == autom2 then
        reaper.SetMediaTrackInfo_Value( tr, "I_AUTOMODE", autom1 )
    else
        reaper.SetMediaTrackInfo_Value( tr, "I_AUTOMODE", autom1 )
    end
end

function advToggleBetweenTwoAutomation( selTr, autom1, autom2)
    local lastMode = nil
    local diff = false
        for i = 0, selTr-1 do
            local tr = reaper.GetSelectedTrack(0, i)
            local trAutom = reaper.GetMediaTrackInfo_Value(tr, "I_AUTOMODE")
            if trAutom ~= lastMode and i > 0 then
                diff = true
                break
            end
            lastMode = trAutom
        end
    if diff then
        for i = 0, selTr-1 do
            local tr = reaper.GetSelectedTrack(0, i)
            local trAutom = reaper.GetMediaTrackInfo_Value(tr, "I_AUTOMODE")
            reaper.SetMediaTrackInfo_Value(tr, "I_AUTOMODE", autom2)
        end    
    else
        for i = 0, selTr-1 do
            local tr = reaper.GetSelectedTrack(0, i)
            toggleBetweenTwoAutomation( tr, autom2, autom1 )
        end    
    end
end

function advAllTrToggleBetweenTwoAutomation(autom1, autom2)
    local selTr = reaper.CountTracks(0)
    local lastMode = nil
    local diff = false
        for i = 0, selTr-1 do
            local tr = reaper.GetTrack(0, i)
            local trAutom = reaper.GetMediaTrackInfo_Value(tr, "I_AUTOMODE")
            if trAutom ~= lastMode and i > 0 then
                diff = true
                break
            end
            lastMode = trAutom
        end
    if diff then
        for i = 0, selTr-1 do
            local tr = reaper.GetTrack(0, i)
            local trAutom = reaper.GetMediaTrackInfo_Value(tr, "I_AUTOMODE")
            reaper.SetMediaTrackInfo_Value(tr, "I_AUTOMODE", autom2)
        end    
    else
        for i = 0, selTr-1 do
            local tr = reaper.GetTrack(0, i)
            toggleBetweenTwoAutomation( tr, autom2, autom1 )
        end    
    end
end

function selectTrackByAutomationState( autom1 ) -- local (i, j, item, take, track)
    
    local selTr = reaper.CountTracks(0)

    if type(autom1) == "number" then
        for i = 0, selTr - 1  do

            local tr = reaper.GetTrack(0, i)
            local trAutom = reaper.GetMediaTrackInfo_Value(tr, "I_AUTOMODE")
            
            if trAutom == autom1 then
                reaper.SetTrackSelected(tr, true)
            else
                reaper.SetTrackSelected(tr, false)
            end
        end
    end
end