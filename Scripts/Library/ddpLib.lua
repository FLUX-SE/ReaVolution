--Script Name : ddpLib
--Author : Jean Loup Pecquais
--Description : DDP related library
--v1.0.0

function addTag(value, tag, isError, separator)
  if value == nil or value == "" then
    if isError ~= nil then
      printError = "Error, "..isError.." need to be defined"
      errorDetected = true
      reaper.ReaScriptError(printError)
    end
  else
    if separator == true then
      markerName = markerName.."|"
    end
    markerName = markerName..tag..value
  end
end

function getProjectEndPosition()
	c_pos = reaper.GetCursorPosition()
	reaper.CSurf_GoEnd()
	endProjPos = reaper.GetCursorPosition()
	reaper.SetEditCurPos(c_pos, 0, 0);
	return endProjPos
end

function getAlbumIndex()
	retval, num_markers, num_regions = reaper.CountProjectMarkers(0)
	for idx=1,num_markers,1 do
		retval, isrgn, pos, rgnend, name, markrgnindexnumber = reaper.EnumProjectMarkers2(0, idx)
		isAlbumIndex = string.find(name, "@")
		if isAlbumIndex == 1 then
			return idx, name, pos
		end
			return nil
	end
end

function markerNameToTag(markerName)
	markerName = string.gsub(markerName, "@", "")
	markerName = string.gsub(markerName, "%|", ",")
	markerName = string.gsub(markerName, "ALBUM=", "")
	markerName = string.gsub(markerName, "CATALOG=", "")
	markerName = string.gsub(markerName, "PERFORMER=", "")
	markerName = string.gsub(markerName, "SONGWRITER=", "")
	markerName = string.gsub(markerName, "COMPOSER=", "")
	markerName = string.gsub(markerName, "ARRANGER=", "")
	markerName = string.gsub(markerName, "MESSAGE=", "")
	markerName = string.gsub(markerName, "GENRE=", "")
	markerName = string.gsub(markerName, "LANGUAGE=", "")
	return markerName
end

