--Script Name : insert MS track
--Author : Jean Loup Pecquais
--Description : insert MS track
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
	
	local numTr = reaper.CountTracks(0)
	reaper.Main_OnCommandEx(41067, 0, 0)
	local newNumTr = reaper.CountTracks(0)

	if numTr == newNumTr then return end

	local selTr = reaper.CountSelectedTracks(0)
	for i = 0, selTr-1 do
		local tr = reaper.GetSelectedTrack(0, i)
		setAudioStream( tr, 1, 2 )
	end
	reaper.PreventUIRefresh(frames)


end

reaper.Undo_BeginBlock()
main()
reaper.Undo_EndBlock('Insert M/S track', -1)