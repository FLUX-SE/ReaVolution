--Script Name : insert HOA 3D track
--Author : Jean Loup Pecquais
--Description : insert HOA 3D track
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
	
	local retval, order = reaper.GetUserInputs( "Set to HOA 3D", 1, "Enter an order: ", "")

	if retval == true then

		while tonumber(order) == nil do
			local answer = reaper.ShowMessageBox("Please, enter a valid value", "Wrong value detected", 5)
			if answer == 2 then
				return
			end
			retval, order = reaper.GetUserInputs( "Set to HOA 3D", 1, "Enter an order: ", "")
			if retval == false then
				return
			end
		end

		local chNum = getHOA3DCh( order )

	
		local numTr = reaper.CountTracks(0)
		reaper.Main_OnCommandEx(41067, 0, 0)
		local newNumTr = reaper.CountTracks(0)
	
		if numTr == newNumTr then return end
		
		local selTr = reaper.CountSelectedTracks(0)
		for i = 0, selTr-1 do
			local tr = reaper.GetSelectedTrack(0, i)
			setAudioStream( tr, 6, chNum )
		end
		reaper.PreventUIRefresh(frames)
	end


end

reaper.Undo_BeginBlock()
main()
reaper.Undo_EndBlock('Insert to HOA 3D', -1)