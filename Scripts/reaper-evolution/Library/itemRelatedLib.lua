--Script Name : itemRelatedLib.lua
--Author : Jean Loup Pecquais
--Description : functions for manipulating items
--v1.0.0

function getItemsFromGroup( refGroup )
    local itemArr = {}
    allItems = reaper.CountMediaItems( 0 )
    for i = 0, allItems-1 do
		local item = reaper.GetMediaItem( 0, i )
		local itemGroup = reaper.GetMediaItemInfo_Value( item, "I_GROUPID" )
		if itemGroup == refGroup then
			table.insert( itemArr, item)
		end
    end
    return itemArr
end

function unselectAllItems()
	for i = 0, reaper.CountMediaItems( 0 )-1 do
		local item = reaper.GetMediaItem( 0, i )
		reaper.SetMediaItemSelected( item, false )
	end
end

function splitItems( item, position )
	if position > reaper.GetMediaItemInfo_Value( item, "D_POSITION" ) and position < reaper.GetMediaItemInfo_Value( item, "D_POSITION" ) + reaper.GetMediaItemInfo_Value( item, "D_LENGTH" ) then
    	local newItem = reaper.SplitMediaItem( item, position )
    	return newItem 
	end
end

function splitItemsInArray( itemArray, position )
	local newItems = {}
	for k, v in pairs( itemArray ) do
		local newItem = splitItems( v, position )
		table.insert (newItems, newItem)
	end
	return newItems
end

function getEmptyItemGroup()
	local lastGroupID = 0
	for i = 0, reaper.CountMediaItems( 0 )-1 do
		local item = reaper.GetMediaItem( 0, i )
		local groupID = reaper.GetMediaItemInfo_Value( item, "I_GROUPID" )
		if groupID > lastGroupID then
			lastGroupID = groupID
		end
	end
	return lastGroupID+1
end

function setItemsToNewGroup( itemArr, newGroup )
	for k, v in pairs(itemArr) do
		reaper.SetMediaItemInfo_Value( v, "I_GROUPID", newGroup)
	end
end

function setFadeInFromPosition( item, position )
	local itemPos = reaper.GetMediaItemInfo_Value( item, "D_POSITION" )
	reaper.SetMediaItemInfo_Value( item, "D_FADEINLEN", position-itemPos)
end

function setFadeInFromPositionArr( arr, position )
	for k, v in pairs(arr) do
		setFadeInFromPosition( v, position )
	end
end

function setFadeOutFromPosition( item, position )
	local itemEnd = reaper.GetMediaItemInfo_Value( item, "D_POSITION" ) + reaper.GetMediaItemInfo_Value( item, "D_LENGTH" )
	reaper.SetMediaItemInfo_Value( item, "D_FADEOUTLEN", itemEnd-position)
end

function setFadeOutFromPositionArr( arr, position )
	for k, v in pairs(arr) do
		setFadeOutFromPosition( v, position )
	end
end

function setTrimLeftFromPosition( item, position )
	if position > reaper.GetMediaItemInfo_Value( item, "D_POSITION" ) and position < reaper.GetMediaItemInfo_Value( item, "D_POSITION" ) + reaper.GetMediaItemInfo_Value( item, "D_LENGTH" ) then
		local fadeLen = reaper.GetMediaItemInfo_Value( item, "D_FADEINLEN" )
		local fadeCurve = reaper.GetMediaItemInfo_Value( item, "C_FADEINSHAPE" )
		local fadeDir = reaper.GetMediaItemInfo_Value( item, "D_FADEINDIR" )

		local newItem = reaper.SplitMediaItem( item, position )
		
		if newItem then
			local excedFade = reaper.GetMediaItemInfo_Value( item, "D_LENGTH" )

			-- print(fadeLen)
			local newFadeLen = fadeLen-excedFade
			
			reaper.SetMediaItemInfo_Value( newItem, "C_FADEINSHAPE", fadeCurve )
			reaper.SetMediaItemInfo_Value( newItem, "D_FADEINLEN", newFadeLen )
			reaper.SetMediaItemInfo_Value( newItem, "D_FADEINLEN_AUTO", newFadeLen )
			reaper.SetMediaItemInfo_Value( newItem, "D_FADEINDIR", fadeDir )
			
			-- reaper.SetMediaItemSelected( item, false )
			-- reaper.SetMediaItemSelected( newItem, true )
			reaper.DeleteTrackMediaItem( reaper.GetMediaItemTrack(item), item )
		end
	end
end

function setTrimLeftFromPositionArr( arr, position )
	for k, v in pairs(arr) do
		setTrimLeftFromPosition( v, position )
	end
end

function setTrimRightFromPosition( item, position )
	local fadeLen = reaper.GetMediaItemInfo_Value( item, "D_FADEOUTLEN" )
	local fadeCurve = reaper.GetMediaItemInfo_Value( item, "C_FADEOUTSHAPE" )
	local fadeDir = reaper.GetMediaItemInfo_Value( item, "D_FADEOUTDIR" )

	-- local itemStart = reaper.GetMediaItemInfo_Value( item, "D_POSITION" )
	local newItem = reaper.SplitMediaItem( item, position )
	if newItem then local excedFade = reaper.GetMediaItemInfo_Value( newItem, "D_LENGTH" )	
		local newFadeLen = fadeLen-excedFade
		
		reaper.SetMediaItemInfo_Value( item, "C_FADEOUTSHAPE", fadeCurve )
		reaper.SetMediaItemInfo_Value( item, "D_FADEOUTLEN_AUTO", newFadeLen )
		reaper.SetMediaItemInfo_Value( item, "D_FADEOUTLEN", newFadeLen )
		reaper.SetMediaItemInfo_Value( item, "D_FADEOUTDIR", fadeDir )
		
		-- reaper.SetMediaItemSelected( item, false )
		-- reaper.SetMediaItemSelected( newItem, true )
		
		reaper.DeleteTrackMediaItem( reaper.GetMediaItemTrack(newItem), newItem )
	end
end

function setTrimRightFromPositionArr( arr, position )
	for k, v in pairs(arr) do
		setTrimRightFromPosition( v, position )
	end
end

function itemIsInTimeInterval( item, timeIn, timeOut )
	-- local timeIn, timeOut = reaper.GetSet_LoopTimeRange( false, false, -1, -1, false )

	local itemStart = reaper.GetMediaItemInfo_Value( item, "D_POSITION" )
	local itemEnd 	= itemStart + reaper.GetMediaItemInfo_Value( item, "D_LENGTH" )

	if timeIn == timeOut then
		return false
	end

	if timeIn-0.01 <= itemStart and timeOut+0.01 >= itemEnd then
		return true
	else
		return false
	end

end

function itemCrossTimeInterval( item, timeIn, timeOut )

	local itemStart = reaper.GetMediaItemInfo_Value( item, "D_POSITION" )
	local itemEnd 	= itemStart + reaper.GetMediaItemInfo_Value( item, "D_LENGTH" )

	if timeIn == timeOut then
		return false
	end
	if timeIn <= itemStart or timeOut >= itemEnd then
		return true
	else
		return false
	end

end

function itemCrossTimeInterval2( item, timeIn, timeOut )

	local itemStart = reaper.GetMediaItemInfo_Value( item, "D_POSITION" )
	local itemEnd 	= itemStart + reaper.GetMediaItemInfo_Value( item, "D_LENGTH" )

	if timeIn == timeOut then
		return false
	end
	if timeIn >= itemEnd or timeOut <= itemStart then
		return false
	else
		return true
	end

end

function itemIsAfterPosition( item, timeIn )
	-- local timeIn, timeOut = reaper.GetSet_LoopTimeRange( false, false, -1, -1, false )

	local itemStart = reaper.GetMediaItemInfo_Value( item, "D_POSITION" )
	local itemEnd 	= itemStart + reaper.GetMediaItemInfo_Value( item, "D_LENGTH" )

	if timeIn == timeOut then
		return false
	end

	if timeIn-0.01 <= itemStart then
		return true
	else
		return false
	end

end

function itemIsInTimeSelection( item )
	local timeIn, timeOut = reaper.GetSet_LoopTimeRange( false, false, -1, -1, false )

	local itemStart = reaper.GetMediaItemInfo_Value( item, "D_POSITION" )
	local itemEnd 	= itemStart + reaper.GetMediaItemInfo_Value( item, "D_LENGTH" )

	if timeIn == timeOut then
		return false
	end

	if timeIn <= itemStart and timeOut >= itemEnd then
		return true
	else
		return false
	end

end

function itemIsBiggerThanTimeSelection( item )
	local timeIn, timeOut = reaper.GetSet_LoopTimeRange( false, false, -1, -1, false )

	local itemStart = reaper.GetMediaItemInfo_Value( item, "D_POSITION" )
	local itemEnd 	= itemStart + reaper.GetMediaItemInfo_Value( item, "D_LENGTH" )

	if timeIn == timeOut then
		return false
	end

	if timeIn >= itemStart and timeOut <= itemEnd then
		return true
	else
		return false
	end

end

function timeStartCrossItem( item )
	local timeIn, timeOut = reaper.GetSet_LoopTimeRange( false, false, -1, -1, false )

	local itemStart = reaper.GetMediaItemInfo_Value( item, "D_POSITION" )
	local itemEnd 	= itemStart + reaper.GetMediaItemInfo_Value( item, "D_LENGTH" )

	if timeIn == timeOut then
		return false
	end

	if timeIn > itemStart and timeIn <= itemEnd then
		return true
	else
		return false
	end

end

function timeEndCrossItem( item )
	local timeIn, timeOut = reaper.GetSet_LoopTimeRange( false, false, -1, -1, false )

	local itemStart = reaper.GetMediaItemInfo_Value( item, "D_POSITION" )
	local itemEnd 	= itemStart + reaper.GetMediaItemInfo_Value( item, "D_LENGTH" )

	if timeIn == timeOut then
		return false
	end

	if timeOut >= itemStart and timeOut < itemEnd then
		return true
	else
		return false
	end

end

function splitAllItemsAtCursor( deleteArtefact )
	for i = reaper.CountMediaItems( 0 )-1, 0, -1  do
		local item = reaper.GetMediaItem( 0, i )
		if item then
			local newItem = reaper.SplitMediaItem( item, reaper.GetCursorPosition())
			if newItem then
				if deleteArtefact == 0 then
					return
				elseif deleteArtefact == 1 then
					reaper.DeleteTrackMediaItem( reaper.GetMediaItemTrack( newItem ), newItem )
				elseif deleteArtefact == 2 then
					reaper.DeleteTrackMediaItem( reaper.GetMediaItemTrack( item ), item )
				end
			end
		end
	end
end

function deleteItemInTimeInterval( timeIn, timeOut )
	for i = reaper.CountMediaItems( 0 )-1, 0, -1 do
		local item = reaper.GetMediaItem( 0, i )
		if item then
			splitItems( item, timeOut )
			local newItem = splitItems( item, timeIn )
		end
	end

	for i = reaper.CountMediaItems( 0 )-1, 0, -1 do
		local item = reaper.GetMediaItem( 0, i )
		if item then
			if itemIsInTimeInterval( item, timeIn, timeOut ) then
				-- reaper.SetMediaItemSelected( item, true )
				reaper.DeleteTrackMediaItem( reaper.GetMediaItemTrack( item ), item )
			end
		end
	end

end

function deplaceItem( timeIn, offset )


	for i = reaper.CountMediaItems( 0 )-1, 0, -1 do
		local item = reaper.GetMediaItem( 0, i )
		if item then
			if itemIsAfterPosition( item, timeIn ) then
				-- reaper.SetMediaItemSelected( item, true )
				local itemPos = reaper.GetMediaItemInfo_Value( item, "D_POSITION" )
				reaper.SetMediaItemPosition( item, itemPos+offset, false)
				-- reaper.DeleteTrackMediaItem( reaper.GetMediaItemTrack( item ), item )
			end
		end
	end

end

function globalCopy( timeIn, timeOut )

	local selLength = timeOut-timeIn

	local output = {}
	local numberOfTracks = reaper.CountTracks( 0 )
	local currentProject = reaper.EnumProjects( -1 )
	local currentProjectIdx = getProjectIndex( currentProject ) 

	for i = 0, numberOfTracks-1 do
		local tr = reaper.GetTrack( currentProject, i )
		local trGUID = reaper.GetTrackGUID( tr )
		-- local _, trChunk = reaper.GetTrackStateChunk( tr, "", false )

		local numberOfItemsOnTracks = reaper.CountTrackMediaItems( tr )

		for j = 0, numberOfItemsOnTracks-1 do

			local item = reaper.GetTrackMediaItem( tr, j )
			local itemGUID = reaper.BR_GetMediaItemGUID( item )

			local numberOfTakes = reaper.CountTakes( item )
			local _, itemChunk = reaper.GetItemStateChunk( item, "", false )
			local itemStartPosition = reaper.GetMediaItemInfo_Value( item, "D_POSITION" )
			local itemEndPosition = itemStartPosition + reaper.GetMediaItemInfo_Value( item, "D_LENGTH" )

			if itemIsBiggerThanTimeSelection( item ) then

				local length = timeOut-timeIn
				local positionOffset = 0

				table.insert( output, { currentProjectIdx, trGUID, itemGUID, itemChunk, length, positionOffset })									

			elseif timeStartCrossItem( item ) then

				local length = itemEndPosition-timeIn
				local positionOffset = 0

				table.insert( output, { currentProjectIdx, trGUID, itemGUID, itemChunk, length, positionOffset })									

			elseif timeEndCrossItem( item ) then

				local length = timeOut-itemStartPosition
				local positionOffset = itemStartPosition-timeIn

				table.insert( output, { currentProjectIdx, trGUID, itemGUID, itemChunk, length, positionOffset })									
				
			elseif itemIsInTimeSelection( item ) then
				-- print()
				local length = itemEndPosition-itemStartPosition
				local positionOffset = itemStartPosition-timeIn

				table.insert( output, { currentProjectIdx, trGUID, itemGUID, itemChunk, length, positionOffset })									
				
			end
		end
		
	end
	
	reaper.SetExtState("reaperEvolution", "globalCopy_items", json.encode(output), false)
	reaper.SetExtState("reaperEvolution", "globalCopy_length", tostring(timeOut-timeIn), false)
	
end

function globalPaste( timeIn, timeOut )
	
	local copyBuff = reaper.GetExtState("reaperEvolution", "globalCopy_items")
	local cursorOffset = reaper.GetExtState("reaperEvolution", "globalCopy_length")
	
	if cursorOffset == "" then
		return 0
	end

	cursorOffset = tonumber(cursorOffset)
	
	timeIn = timeIn or reaper.GetCursorPosition()
	timeOut = timeOut or timeIn
	
	deleteItemInTimeInterval( timeIn, timeOut )
	if timeOut == timeIn then
		deplaceItem( timeIn, timeIn-timeOut )
		reaper.GetSet_LoopTimeRange( true, false, timeIn, timeIn+cursorOffset, true)
		reaper.Main_OnCommandEx(40200, 1, 0) --Time selection: Insert empty space at time selection (moving later items)
	else
		reaper.Main_OnCommandEx(40201, 1, 0) --Time selection: Remove contents of time selection (moving later items)
		-- deplaceItem( timeIn, timeIn-timeOut )
		reaper.GetSet_LoopTimeRange( true, false, timeIn, timeIn+cursorOffset, true)
		reaper.Main_OnCommandEx(40200, 1, 0) --Time selection: Insert empty space at time selection (moving later items)
	end
	

	local copyTable = json.decode((copyBuff))
	
	local oldSourceItem = nil
	local lastCreatedItem = nil
	
    reaper.Main_OnCommandEx(40289, 1, 0) --unselect all items
	
	for k, v in pairs(copyTable) do
		
		local sourcePrj 		= 0 --reaper.EnumProjects( -1 )--reaper.EnumProjects( v[1] )
		local sourceTr 			= reaper.GetTrack( 0, reaper.GetMediaTrackInfo_Value( reaper.BR_GetMediaTrackByGUID( sourcePrj, v[2] ), "IP_TRACKNUMBER" )-1)
		local sourceItem 		= reaper.BR_GetMediaItemByGUID( sourcePrj, v[3] )
		local itemChunk			= v[4]
		local length 		 	= v[5]
		local positionOffset 	= v[6]
		-- local trChunk			= v[7]
		
		local newItem = reaper.AddMediaItemToTrack( sourceTr )
		-- reaper.SetTrackStateChunk(sourceTr, trChunk, false)
		reaper.SetItemStateChunk( newItem, itemChunk, false )
		
		reaper.SetMediaItemInfo_Value( newItem, "D_POSITION", timeIn+positionOffset )
		reaper.SetMediaItemInfo_Value( newItem, "D_LENGTH", length ) --lenght+0.01
		
		reaper.SetMediaItemInfo_Value( newItem, "D_FADEINLEN", 0.01 )
		reaper.SetMediaItemInfo_Value( newItem, "D_FADEOUTLEN", 0.01 )
		
		reaper.SetMediaItemInfo_Value( newItem, "D_FADEINDIR", 0 )
		reaper.SetMediaItemInfo_Value( newItem, "D_FADEOUTDIR", 0 )
		
		reaper.SetMediaItemInfo_Value( newItem, "B_UISEL", 1 )
		
		oldSourceItem = sourceItem
	end

end

function setSnapOffset( item )
	if item then
		local position =  reaper.SnapToGrid( 0, reaper.BR_PositionAtMouseCursor( false ) )
		local itemPos = reaper.GetMediaItemInfo_Value( item, "D_POSITION" )
		reaper.SetMediaItemInfo_Value( item, "D_SNAPOFFSET" , position-itemPos )
	end
end

function moveItemSnapOffsetToEditCursor( item )
	if item then
		local itemSnapOffset = reaper.GetMediaItemInfo_Value( item, "D_SNAPOFFSET" )
		reaper.SetMediaItemInfo_Value( item, "D_POSITION" , reaper.GetCursorPosition()-itemSnapOffset )
	end
end

function getNextItemOnSelTr() --WORK IN PROGRESS
	
	local frames = 10
	reaper.PreventUIRefresh(-1*frames)
	
	local tr = reaper.GetSelectedTrack(0, 0)
	local itemSel = reaper.GetSelectedMediaItem( 0, 0 )
	local itemIsInTr = nil
	if tr then
		if itemSel then
			itemIsInTr = reaper.MediaItemDescendsFromTrack( itemSel , tr )
		else
			itemIsInTr = false
		end
		reaper.Main_OnCommandEx(40289, 0, 0) --Item: Unselect all items
		local itemOnTr = reaper.CountTrackMediaItems( tr )
		
		if itemIsInTr == 1 then
			for i = 0, itemOnTr-1 do
				local item = reaper.GetTrackMediaItem( tr, i )
				if item == itemSel then
					item = reaper.GetTrackMediaItem( tr, i+1 ) or item
					reaper.SetMediaItemInfo_Value( item, "B_UISEL", 1 )
					reaper.UpdateArrange()
					reaper.PreventUIRefresh(frames)
					return item
				else
					reaper.PreventUIRefresh(frames)
					return nil
				end
			end
		else
			for i = 0, itemOnTr-1 do
				local item = reaper.GetTrackMediaItem( tr, i )
				if item then
					if isItemVisible( item ) then
						reaper.SetMediaItemInfo_Value( item, "B_UISEL", 1 )
						reaper.UpdateArrange()
						reaper.PreventUIRefresh(frames)
						return item
					else
						reaper.PreventUIRefresh(frames)
						return nil
					end
				end
			end
		end
	end
end

function getPrevItemOnSelTr() --WORK IN PROGRESS
	
	local frames = 10
	reaper.PreventUIRefresh(-1*frames)
	
	local tr = reaper.GetSelectedTrack(0, 0)
	local itemSel = reaper.GetSelectedMediaItem( 0, 0 )
	local itemIsInTr = nil
	if tr then
		if itemSel then
			itemIsInTr = reaper.MediaItemDescendsFromTrack( itemSel , tr )
		else
			itemIsInTr = 0
		end
		reaper.Main_OnCommandEx(40289, 0, 0) --Item: Unselect all items
		local itemOnTr = reaper.CountTrackMediaItems( tr )
		
		if itemIsInTr == 1 then
			for i = itemOnTr-1, 0, -1 do
				local item = reaper.GetTrackMediaItem( tr, i )
				if item == itemSel then
					item = reaper.GetTrackMediaItem( tr, i-1 ) or item
					reaper.SetMediaItemInfo_Value( item, "B_UISEL", 1 )
					if isItemVisible( item ) then
						local start_time, end_time = reaper.GetSet_ArrangeView2( 0, false, 0, 0)
						local itemStart = reaper.GetMediaItemInfo_Value( item, "D_POSITION" )
						local itemEnd 	= itemStart + reaper.GetMediaItemInfo_Value( item, "D_LENGTH" )					
						-- reaper.GetSet_ArrangeView2( 0, false, start_time-(end_time-itemEnd), itemEnd)
					end
					reaper.UpdateArrange()
					reaper.PreventUIRefresh(frames)
					return item
				else
					print()
					reaper.PreventUIRefresh(frames)
					return nil
				end
			end
		else
			for i = itemOnTr-1, 0, -1 do
				local item = reaper.GetTrackMediaItem( tr, i )
				if item then
					if isItemVisible( item ) then
						reaper.SetMediaItemInfo_Value( item, "B_UISEL", 1 )
						reaper.UpdateArrange()
						reaper.PreventUIRefresh(frames)
						return item
					else
						reaper.PreventUIRefresh(frames)
						return nil	
					end
				end
			end
		end
	end
end

function isItemVisible( item )
	local start_time, end_time = reaper.GetSet_ArrangeView2( 0, false, 0, 0)
	return itemCrossTimeInterval2( item, start_time, end_time)
end

function getNextTrackAcrossTrack()
	local thereIsItem = false
	while thereIsItem == false do
	  local lastTouchTrack = reaper.GetLastTouchedTrack()
	--   local folderDepth = reaper.GetMediaTrackInfo_Value(lastTouchTrack, "I_FOLDERDEPTH")
	  local totalTrack = reaper.CountTracks( 0 )
	--   if folderDepth == 1 and reaper.GetMediaTrackInfo_Value(lastTouchTrack, "I_FOLDERCOMPACT") > 0 then
	local trID = reaper.GetMediaTrackInfo_Value(lastTouchTrack, "IP_TRACKNUMBER")
	local tr = reaper.GetTrack(0, trID)
	-- folderDepth = folderDepth + reaper.GetMediaTrackInfo_Value(tr, "I_FOLDERDEPTH")
	-- while folderDepth > 0 do
	--   trID = trID + 1
	--   tr = reaper.GetTrack(0, trID)
	--   folderDepth = folderDepth + reaper.GetMediaTrackInfo_Value(tr, "I_FOLDERDEPTH")
	-- end
	tr = reaper.GetTrack(0, trID+1)
	tr = tr or lastTouchTrack
	local parentTrack = reaper.GetParentTrack(tr)
	if parentTrack then
		reaper.SetMediaTrackInfo_Value(parentTrack, "I_FOLDERCOMPACT" , 0)
	end
	reaper.Main_OnCommandEx(40297, 0, 0) -- Track: Unselect all tracks
	reaper.SetMediaTrackInfo_Value(tr, "I_SELECTED" , 1)  
	--   else
		-- reaper.Main_OnCommandEx(40285, 0, 0) -- select next track
	--   end
	  thereIsItem = getNextItemOnSelTr()
	  if trID == totalTrack-1 then
		break
	  end
	end
  end
  
  function getPrevTrackAcrossTrack()
	local thereIsItem = false
	while thereIsItem == false do
	  local lastTouchTrack = reaper.GetLastTouchedTrack()
	  -- print(folderDepth)
	  local trID = reaper.GetMediaTrackInfo_Value(lastTouchTrack, "IP_TRACKNUMBER") - 2
	  local tr = reaper.GetTrack(0, trID)
	  if tr then
		local folderDepth = reaper.GetMediaTrackInfo_Value(tr, "I_FOLDERDEPTH")
		if folderDepth <= 0 then
		  folderDepth = folderDepth + reaper.GetMediaTrackInfo_Value(tr, "I_FOLDERDEPTH")
		  local parentTrack = reaper.GetParentTrack(tr)
		  if parentTrack then
			if reaper.GetMediaTrackInfo_Value(parentTrack, "I_FOLDERCOMPACT" ) > 0 then
			  tr = parentTrack
			  parentTrack = reaper.GetParentTrack( tr )
			end
		  end
		end
		tr = tr or lastTouchTrack
		reaper.Main_OnCommandEx(40297, 0, 0) -- Track: Unselect all tracks
		reaper.SetMediaTrackInfo_Value(tr, "I_SELECTED" , 1)  
	  else
		reaper.Main_OnCommandEx(40286, 0, 0) -- select prev track
	  end
	  thereIsItem = getPrevItemOnSelTr()
	end
  end
  