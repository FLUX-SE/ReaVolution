--Script Name : set tracks to HOA 2D
--Author : Jean Loup Pecquais
--Description : Use audio stream to set track to HOA 2D
--v1.0.0

local libPath = reaper.GetExtState("Reaper Evolution", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Reaper Evolution library is not found. Please refer to user guide", "Library not found", 0)
    return
end

loadfile(libPath .. "reaVolutionLib.lua")()

-------------------------------------------------------------------------------------------------------------

function main()

local selTr = reaper.CountSelectedTracks()
local retval, order = reaper.GetUserInputs( "Set to HOA 2D", 1, "Enter an order: ", "")
local chNum = getHOA2DCh( order )
	if retval then
		for i = 1, selTr do
		  local tr = reaper.GetSelectedTrack(0,i-1)
		  setAudioStream( tr, 5, chNum )
		end
	end
end

reaper.Undo_BeginBlock()
main()
reaper.Undo_EndBlock('Set tracks to HOA 2D', -1)