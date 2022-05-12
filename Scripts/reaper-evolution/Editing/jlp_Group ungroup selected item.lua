----------------------------------
-- Author : Jean Loup Pecquais
-- Name : Group/Ungroup selected item
----------------------------------

local function main()
  reaper.Undo_BeginBlock()


  local item_count = reaper.CountSelectedMediaItems(0)
  local GroupeState = 0
  for i = 0, item_count - 1 do
    local sel_item = reaper.GetSelectedMediaItem(0,i)
      isGrouped = reaper.GetMediaItemInfo_Value(sel_item, "I_GROUPID")
      if isGrouped ~= 0 then
        GroupeState = GroupeState + 1
      end
  end

  if GroupeState ~= 0 then
    reaper.Main_OnCommandEx(40033, 1, 0)
    reaper.Undo_EndBlock("Ungroup item(s)", 0)
     else
    reaper.Main_OnCommandEx(40032, 1, 0)
    reaper.Undo_EndBlock("Group item(s)", 0)
  end

-- new code

--[[  local itemCount = reaper.CountSelectedMediaItems(0)

  for i = 0, itemCount - 1 do
    local item = reaper.GetSelectedMediaItem(0,i)
    local itemGroup = reaper.GetMediaItemInfo_Value(item, "I_GROUPID")

    print(itemGroup)
  
    if itemGroup == 0 then
      local groupID = getEmptyItemGroup()
      reaper.SetMediaItemInfo_Value( item, "I_GROUPID", groupID)
      reaper.Undo_EndBlock("Group item(s)", 0)
    
    else
      local itemArr = getItemsFromGroup( itemGroup )
      setItemsToNewGroup( itemArr, 0 )
      reaper.Undo_EndBlock("Ungroup item(s)", 0)

    end
  end
--]]



end
----------------------------------------------------------------
main()
