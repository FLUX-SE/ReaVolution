--Script Name : jlp_Split item under mouse cursor (select right)(don't move edit cursor).lua
--Author : Jean Loup Pecquais
--Description : Split item under mouse cursor
--v1.0.0

local libPath = reaper.GetExtState("Reaper Evolution", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Reaper Evolution library is not found. Please refer to user guide", "Library not found", 0)
    return
end

loadfile(libPath .. "reaVolutionLib.lua")()
function main()
  local item = reaper.BR_ItemAtMouseCursor()
    if item ~= nil then
   
      reaper.Undo_BeginBlock()

      local position =  reaper.SnapToGrid( 0, reaper.BR_PositionAtMouseCursor( false ) )
      local selItem = reaper.CountSelectedMediaItems( 0 )
      local newGroup = getEmptyItemGroup()

      if selItem == 0 or (selItem > 0 and reaper.IsMediaItemSelected(item) == false) then

        local itemGroup = reaper.GetMediaItemInfo_Value( item, "I_GROUPID" )

        if itemGroup == 0 or itemGroup == nil or reaper.GetToggleCommandState(1156) == 0 then
          splitItems( item, position )    
        else
          local itemArr = getItemsFromGroup( itemGroup )
          itemArr = splitItemsInArray( itemArr, position )
          setItemsToNewGroup( itemArr, newGroup )
        end

      elseif selItem > 0 and reaper.IsMediaItemSelected(item) then
        local usedGrp = {}
        for i = selItem-1, 0, -1  do
          item = reaper.GetSelectedMediaItem( 0, i )
          local itemGroup = reaper.GetMediaItemInfo_Value( item, "I_GROUPID" )
          local continue = true
          
          for k, v in pairs(usedGrp) do
            if itemGroup == v then
              continue = false
              break
            end
          end

          if continue then
            if itemGroup == 0 or itemGroup == nil or reaper.GetToggleCommandState(1156) == 0 then
              splitItems( item, position ) 
            else 
              local itemArr = getItemsFromGroup( itemGroup )
              itemArr = splitItemsInArray( itemArr, position )
              setItemsToNewGroup( itemArr, newGroup )
              table.insert(usedGrp, itemGroup)
            end
          end
        end
      end
    end
  reaper.UpdateArrange()
  reaper.Undo_EndBlock("Split item", -1)
end


main()