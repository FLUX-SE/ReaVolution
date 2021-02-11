--Script Name : insert channel based track
--Author : Jean Loup Pecquais
--Description : insert channel based track
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
	
	local retval, chNum = reaper.GetUserInputs( "Set to channel based", 1, "Enter a speaker arrangement: ", "")

	if retval == true then

		while tonumber(chNum) == nil do
			local answer = reaper.ShowMessageBox("Please, enter a valid value", "Wrong value detected", 5)
			if answer == 2 then
				return
			end
			retval, chNum = reaper.GetUserInputs( "Set to channel based", 1, "Enter a speaker arrangement: ", "")
			if retval == false then
				return
			end
		end
	
		local numTr = reaper.CountTracks(0)
		reaper.Main_OnCommandEx(41067, 0, 0)
		local newNumTr = reaper.CountTracks(0)
	
		if numTr == newNumTr then return end
		
		local selTr = reaper.CountSelectedTracks(0)
		for i = 0, selTr-1 do
			local tr = reaper.GetSelectedTrack(0, i)
			setAudioStream( tr, 0, chNum )
		end
		reaper.PreventUIRefresh(frames)
	end


end

reaper.Undo_BeginBlock()
main()
reaper.Undo_EndBlock('Insert channel-based tracks', -1)