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


-- Set ToolBar Button ON
function SetButtonON()
	local is_new_value, filename, sec, cmd, mode, resolution, val = reaper.get_action_context()
	local state = reaper.GetToggleCommandStateEx( sec, cmd )
	reaper.SetToggleCommandState( sec, cmd, 1 ) -- Set ON
	reaper.RefreshToolbar2( sec, cmd )
	reaper.SetExtState("reaperEvolution", "masterMuteToggle", tostring(true), true)
end

-- Set ToolBar Button OFF
function SetButtonOFF()
	local is_new_value, filename, sec, cmd, mode, resolution, val = reaper.get_action_context()
	local state = reaper.GetToggleCommandStateEx( sec, cmd )
	reaper.SetToggleCommandState( sec, cmd, 0 ) -- Set OFF
	reaper.RefreshToolbar2( sec, cmd )
	reaper.SetExtState("reaperEvolution", "masterMuteToggle", tostring(false), true)
end

function main()
	reaper.defer(main)
	if reaper.GetExtState("reaperEvolution", "masterMuteToggle") == "true" then
		if reaper.AnyTrackSolo( 0 ) then
			reaper.SetMediaTrackInfo_Value( reaper.GetMasterTrack( 0 ), "B_MUTE" , 0)
		else
			reaper.SetMediaTrackInfo_Value( reaper.GetMasterTrack( 0 ), "B_MUTE" , 1)
		end
	end
end

function onButtonClick()

	if reaper.GetExtState("reaperEvolution", "masterMuteToggle") == "true" then
		SetButtonOFF()
		reaper.SetMediaTrackInfo_Value( reaper.GetMasterTrack( 0 ), "B_MUTE" , 0)		
		return 0
	else
		SetButtonON()
		return 1
	end
end

---------------------------

state = onButtonClick()

main()