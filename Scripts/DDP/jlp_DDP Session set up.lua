----------------------------------
-- Author : Jean Loup Pecquais
-- Name : DDP - Session Set Up
----------------------------------

local libPath = reaper.GetExtState("Reaper Evolution", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Reaper Evolution library is not found. Please refer to user guide", "Library not found", 0)
    return
end

loadfile(libPath .. "reaVolutionLib.lua")()

createAlbumIndex = reaper.NamedCommandLookup("_RSca063147f3a24b0ac2f14ece2f81ca6bca94be76")
createTracksIndex = reaper.NamedCommandLookup("_RS725a554c08451e597953a42d0d839917e6bc37f0")

numItems = reaper.CountMediaItems(0)--compter les items
itemTable = {}
itemPosTable = {}

function main()

    --reaper.Main_OnCommandEx(rippleEdit, 1, 0)
    firstItemIndex, firstItem = firstItemIdx()
    firstItemPos = reaper.GetMediaItemInfo_Value(firstItem, "D_POSITION")--get position first item
    reaper.SetMediaItemPosition(firstItem, 2, true)
    offset = 2-firstItemPos--calculer diff entre nouvelle position et ancienne position du 1er objet

    for itemIdx=0,numItems-1,1 do
    	if itemIdx ~= firstItemIndex then
	    	local item = reaper.GetMediaItem(0, itemIdx)
	    	itemPos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")--get position first item
	    	newItemPos = itemPos + offset
	    	reaper.SetMediaItemPosition(item, newItemPos, true)
    	end
    end

    answerAssistant = reaper.ShowMessageBox("Would you like to create your DDP marker now ?", "DDP Assistant", 4)

    if answerAssistant == 6 then
		local index0id = reaper.AddProjectMarker(0, false, 0, 0, "!", 0)
	    answerAlbum = reaper.ShowMessageBox("Would you like to create your album metadata?", "DDP Assistant", 4)
    	if answerAlbum == 6 then
		    reaper.Main_OnCommandEx(createAlbumIndex, 1, 0)
		end

	    answerTracks = reaper.ShowMessageBox("Would you like to create your tracks metadata?", "DDP Assistant", 4)

    	if answerTracks == 6 then
		    reaper.Main_OnCommandEx(40182, 1, 0) --select all items
		    reaper.Main_OnCommandEx(createTracksIndex, 1, 0)
		end

    end
end



main()