--Script Name : jlp_Add track separator
--Author : Jean Loup Pecquais
--Description : Add track separator
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
    reaper.PreventUIRefresh(-1*frames)  
    
    local pathTheme = reaper.GetLastColorThemeFile()
    local _, pathTheme, _ = parseFilePath(pathTheme)  
    
    local track = reaper.GetSelectedTrack2(0, reaper.CountSelectedTracks(0)-1, false)
    local idx = nil
    if track then
        idx = reaper.GetMediaTrackInfo_Value( track, "IP_TRACKNUMBER" ) --or reaper.GetMediaTrackInfo_Value( reaper.GetLastTouchedTrack(), "IP_TRACKNUMBER" ) 
    end
    
    if idx == nil then idx = reaper.CountTracks() end
    
    reaper.InsertTrackAtIndex( idx, false)
    local newTrack = reaper.GetTrack(0, idx)
    local retval, stringNeedBig = reaper.GetSetMediaTrackInfo_String( newTrack, "P_NAME" , "Separator", true )

    if pathTheme == "ReaVolutionTheme.ReaperTheme" then
        local retval = reaper.BR_SetMediaTrackLayouts( newTrack, "Separator Thin", "Separator" )
    end
    
    reaper.PreventUIRefresh(frames)  
end

main()