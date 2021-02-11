----------------------------------
-- Author : Jean Loup Pecquais
-- Name : DDP - Create album index
----------------------------------

markerName = "@"
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
	--Msg(nameAlbumIndex)

	if idxAlbumIndex ~= nil then isAlbumIndex = true end

	if isAlbumIndex == true then
		position = posAlbumIndex
		inputValues_csv = markerNameToTag(nameAlbumIndex)
	else
		inputValues_csv = ""
		position = getProjectEndPosition()
	end

	retval, retvals_csv = reaper.GetUserInputs("Create album index", 9, "Album :,Catalog :,Performer :,Songwriter :,Composer :,Arranger :,Message :, Genre:, Language:", inputValues_csv)

	if retval == true then

		local valTable = retvals_csv:split(",")

	    addTag(valTable[1], "ALBUM=", "Album", false)
	    addTag(valTable[2], "CATALOG=", "Catalog EAN", true)
	    addTag(valTable[3], "PERFORMER=", nil, true)
	    addTag(valTable[4], "SONGWRITER=", nil, true)
	    addTag(valTable[5], "COMPOSER=", nil, true)
	    addTag(valTable[6], "ARRANGER=", nil, true)
	    addTag(valTable[7], "MESSAGE=", nil, true)
	    addTag(valTable[8], "GENRE=", nil, true)
	    addTag(valTable[9], "LANGUAGE=", nil, true)
	    
	    if not errorDetected then
	    	if isAlbumIndex == true then
	    		retval, num_markers, num_regions = reaper.CountProjectMarkers(0)
	    		reaper.SetProjectMarkerByIndex(0, idxAlbumIndex, false, posAlbumIndex, 0, num_markers, markerName, 0)
	    	else
	    		reaper.AddProjectMarker(0, false, position, 0, markerName, -1)
	    	end
		end
	end
end


main()
