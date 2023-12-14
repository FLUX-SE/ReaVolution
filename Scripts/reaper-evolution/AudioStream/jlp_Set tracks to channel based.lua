--@noindex
--@author FLUX::
--@version 23.12.0

local libPath = reaper.GetExtState("Reaper Evolution", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Reaper Evolution library is not found. Please refer to user guide", "Library not found", 0)
    return
end

loadfile(libPath .. "reaVolutionLib.lua")()

-------------------------------------------------------------------------------------------------------------

function main()

local selTr = reaper.CountSelectedTracks()
local retval, chString = reaper.GetUserInputs( "Set to channel based", 1, "Enter a speaker arrangement: ", "")
local chNum = getChannelsFromString( chString )
	if retval then
		for i = 1, selTr do
		  local tr = reaper.GetSelectedTrack(0,i-1)
		  setAudioStream( tr, 0, chNum )
		end
	end
end

reaper.Undo_BeginBlock()
main()
reaper.Undo_EndBlock('Set tracks to channel based', -1)