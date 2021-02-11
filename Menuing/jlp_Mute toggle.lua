--Script Name : Solo toggle.lua
--Author : Jean Loup Pecquais
--Description : This is a toggle. It display ON when any track is soloed. It return OFF when not. Clicking on it unsolo all.
--v1.0.0

local libPath = reaper.GetExtState("Reaper Evolution", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Reaper Evolution library is not found. Please refer to user guide", "Library not found", 0)
    return
end

loadfile(libPath .. "reaVolutionLib.lua")()

-- toggleState = 0

-- Set ToolBar Button ON
function SetButtonON()
	local is_new_value, filename, sec, cmd, mode, resolution, val = reaper.get_action_context()
	local state = reaper.GetToggleCommandStateEx( sec, cmd )
	reaper.SetToggleCommandState( sec, cmd, 1 ) -- Set ON
	reaper.RefreshToolbar2( sec, cmd )
	reaper.SetExtState("reaperEvolution", "globalMute", tostring(AnyTrackMute()), true)
end

-- Set ToolBar Button OFF
function SetButtonOFF()
	local is_new_value, filename, sec, cmd, mode, resolution, val = reaper.get_action_context()
	local state = reaper.GetToggleCommandStateEx( sec, cmd )
	reaper.SetToggleCommandState( sec, cmd, 0 ) -- Set OFF
	reaper.RefreshToolbar2( sec, cmd )
	reaper.SetExtState("reaperEvolution", "globalMute", tostring(AnyTrackMute()), true)
end

function main()
  if reaper.GetExtState("reaperEvolution", "globalMute") == "true" then
  SetButtonON()
  else
  SetButtonOFF()
  end
  reaper.defer(main)
end

function onButtonClick()

	if reaper.GetExtState("reaperEvolution", "globalMute") == "true" and reaper.GetExtState("reaperEvolution", "globalMuteOnOff") == "On" then
		reaper.Main_OnCommand(40339, 0) -- unmute all tracks
	end
end

---------------------------
onButtonClick()

reaper.defer(main)

reaper.SetExtState("reaperEvolution", "globalMuteOnOff", "On", false)
