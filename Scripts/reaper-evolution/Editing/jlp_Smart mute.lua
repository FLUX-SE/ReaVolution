--Script Name : jlp_Smart mute.lua
--Author : Jean Loup Pecquais
--Description : Mute track, item or automation item
--v1.0.0

local libPath = reaper.GetExtState("Reaper Evolution", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Reaper Evolution library is not found. Please refer to user guide", "Library not found", 0)
    return
end

loadfile(libPath .. "reaVolutionLib.lua")()

function main()

	local lastContext = reaper.GetCursorContext2(true)

	if lastContext == 0 then
		--track panel
		local numberTracksSelected = reaper.CountSelectedTracks2( 0, true )
		if numberTracksSelected > 0 then
			for i = 0, numberTracksSelected-1 do
				tr = reaper.GetSelectedTrack2( 0, i, true)
				trMuteState = reaper.GetMediaTrackInfo_Value( tr, "B_MUTE" )
				if trMuteState == 1 then
					reaper.SetMediaTrackInfo_Value( tr, "B_MUTE", 0 )
				else
					reaper.SetMediaTrackInfo_Value( tr, "B_MUTE", 1 )
				end
			end
		end

	elseif lastContext == 1 then
		--item
		local numberItemsSelected = reaper.CountSelectedMediaItems( 0 )
		if numberItemsSelected > 0 then
			for i = 0, numberItemsSelected-1 do
				local item = reaper.GetSelectedMediaItem( 0, i )

		        local itemGroup = reaper.GetMediaItemInfo_Value( item, "I_GROUPID" )

				if itemGroup == 0 then
					local itemMuteState = reaper.GetMediaItemInfo_Value( item, "B_MUTE" )
					reaper.SetMediaItemInfo_Value(item, "B_MUTE", 1-itemMuteState )
				elseif itemGroup > 0 then
					local itemArr = getItemsFromGroup( itemGroup )
					for k, v in pairs(itemArr) do
						local itemMuteState = reaper.GetMediaItemInfo_Value(v, "B_MUTE" )
						reaper.SetMediaItemInfo_Value(v, "B_MUTE", 1-itemMuteState )
					end
				end
			end
			reaper.UpdateArrange()
		end

	elseif lastContext == 2 then
		reaper.Main_OnCommand(42211, 0) --toggle mute automation item
	end

end

main()