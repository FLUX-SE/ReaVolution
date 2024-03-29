--@noindex
--@author FLUX::
--@version 23.12.0

local libPath = reaper.GetExtState("Reaper Evolution", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Reaper Evolution library is not found. Please refer to user guide", "Library not found", 0)
    return
end

loadfile(libPath .. "reaVolutionLib.lua")()

function main()
  local item = reaper.BR_ItemAtMouseCursor()

  if (item ~= nil) then
  reaper.Undo_BeginBlock()

    local x, y = reaper.GetMousePosition()
    local item, take = reaper.GetItemFromPoint( x, y, false )
    local position =  reaper.SnapToGrid(0, reaper.BR_PositionAtMouseCursor( false ))
    local selItem = reaper.CountSelectedMediaItems( 0 )

    if selItem == 0 or (selItem > 0 and reaper.IsMediaItemSelected(item) == false) then

      local itemGroup = reaper.GetMediaItemInfo_Value( item, "I_GROUPID" )

      if itemGroup == 0 or itemGroup == nil then
        setFadeOutFromPosition( item, position )
      else
        local itemArr = getItemsFromGroup( itemGroup )
        setFadeOutFromPositionArr( itemArr, position )
      end

    elseif selItem > 0 and reaper.IsMediaItemSelected(item) then

      for i = 0, selItem-1 do
        item = reaper.GetSelectedMediaItem( 0, i )
        local itemGroup = reaper.GetMediaItemInfo_Value( item, "I_GROUPID" )

        if itemGroup == 0 then
          setFadeOutFromPosition( item, position )
        else
          local itemArr = getItemsFromGroup( itemGroup )
          setFadeOutFromPositionArr( itemArr, position )
        end
      end
           
    end

  reaper.Undo_EndBlock("Fade out", -1)

  end
end

main()

reaper.UpdateArrange()
