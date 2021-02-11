--Script Name : jlp_SpatRevo_LAP On by default.lua
--Author : Jean Loup Pecquais
--Description : SpatRevo_LAP On by default
--v1.0.0

local libPath = reaper.GetExtState("Reaper Evolution", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Reaper Evolution library is not found. Please refer to user guide", "Library not found", 0)
    return
end

loadfile(libPath .. "reaVolutionLib.lua")()

-------------------------------------------------------------------------------------------------------------

 -- Set ToolBar Button ON
 function SetButtonON(sec, cmd)
    reaper.SetToggleCommandState( sec, cmd, 1 ) -- Set ON
    reaper.SetExtState("ReaVolution", "Default LAP", "1", true)
    reaper.RefreshToolbar2( sec, cmd )
end

-- Set ToolBar Button OFF
function SetButtonOFF(sec, cmd)
    reaper.SetToggleCommandState( sec, cmd, 0 ) -- Set OFF
    reaper.SetExtState("ReaVolution", "Default LAP", "0", true)
    reaper.RefreshToolbar2( sec, cmd )
  end

function main()
    local state =  tonumber(reaper.GetExtState( "ReaVolution", "Default LAP" ))
    local is_new_value, filename, sec, cmd, mode, resolution, val = reaper.get_action_context()
    local stateToggle = reaper.GetToggleCommandStateEx( sec, cmd )
    if state == 1 then
        if stateToggle == state then
            SetButtonOFF(sec, cmd)
        else
            SetButtonON(sec, cmd)
        end
    else
        if stateToggle == state then
            SetButtonON(sec, cmd)
        else
            SetButtonOFF(sec, cmd)
        end
    end
end

reaper.defer(main)
--reaper.atexit( SetButtonOFF )