--Script Name : set tracks to binaural
--Author : Jean Loup Pecquais
--Description : Use audio stream to set track to binaural
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

	for i = 1, selTr do
	  local tr = reaper.GetSelectedTrack(0,i-1)
	  setAudioStream( tr, 7, 2 )
	end
end

reaper.Undo_BeginBlock()
local frames = 10
reaper.PreventUIRefresh(-1*frames)
main()
reaper.PreventUIRefresh(frames)
reaper.Undo_EndBlock('Set tracks to binaural', -1)