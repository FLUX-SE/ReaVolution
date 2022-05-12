----------------------------------
-- Author : Jean Loup Pecquais
-- Name : DDP - Create track index
----------------------------------

markerName = "#"
errorDetected = false
retvals_csv = ""
oldValueTable = {}

local libPath = reaper.GetExtState("Reaper Evolution", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Reaper Evolution library is not found. Please refer to user guide", "Library not found", 0)
    return
end

loadfile(libPath .. "reaVolutionLib.lua")()

function main()

	isAlbumIndex = false
	idxAlbumIndex, nameAlbumIndex, posAlbumIndex = getAlbumIndex()

	if idxAlbumIndex ~= nil then
		nameAlbumIndex = markerNameToTag(nameAlbumIndex)
		oldValueTable = nameAlbumIndex:split(",")
		--Msg(nameAlbumIndex)	
	end	

	local itemcount = reaper.CountSelectedMediaItems(0) --Apply script for all selected items
	for selitem=0, itemcount-1 do
		local item = reaper.GetSelectedMediaItem(0, selitem)
		if item ~= nil then
			position = reaper.GetMediaItemInfo_Value(item, "D_POSITION") --Get item position for maker
			tk = reaper.GetMediaItemTake(item, 0)
			retval, oldValueTable[1] = reaper.GetSetMediaItemTakeInfo_String(tk, "P_NAME", "stringNeedBig", false)
		else
			oldValueTable[1] = ""
			position = reaper.GetPlayPosition()
		end
		inputValues_csv = tableToString(oldValueTable) --pre-fill answer with preview answer
		retval, retvals_csv = reaper.GetUserInputs("Create track index", 7, "Title :,ISRC :,Performer :,Songwriter :,Composer :,Arranger :,Message :", inputValues_csv)

		if retval == true then

			local valTable = retvals_csv:split(",")

		    addTag(valTable[1], "TITLE=", "Title", false)
		    addTag(valTable[2], "ISRC=", "ISRC", true)
		    addTag(valTable[3], "PERFORMER=", nil, true)
		    addTag(valTable[4], "SONGWRITER=", nil, true)
		    addTag(valTable[5], "COMPOSER=", nil, true)
		    addTag(valTable[6], "ARRANGER=", nil, true)
		    addTag(valTable[7], "MESSAGE=", nil, true)
		    
		    if not errorDetected then
		    	reaper.AddProjectMarker(0, false, position, 0, markerName, -1)
			end

			for i=0,#valTable,1 do
				oldValueTable[i]=valTable[i]
			end
			reaper.Main_OnCommand(40898, 0) --Renumber all marker in timeline order
			markerName = "#"
		end
	end
end


main()
