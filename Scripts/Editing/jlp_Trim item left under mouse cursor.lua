--Script Name : jlp_Trim item left under mouse cursor.lua
--Author : Jean Loup Pecquais
--Description : Trim start of item under mouse at mouse cursor
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

    local position =  reaper.SnapToGrid(0, reaper.BR_PositionAtMouseCursor( false ))
    local selItem = reaper.CountSelectedMediaItems( 0 )

    if selItem == 0 or (selItem > 0 and reaper.IsMediaItemSelected(item) == false) then

      local itemGroup = reaper.GetMediaItemInfo_Value( item, "I_GROUPID" )

      if itemGroup == 0 or itemGroup == nil then
        setTrimLeftFromPosition( item, position )
      else
        local itemArr = getItemsFromGroup( itemGroup )
        setTrimLeftFromPositionArr( itemArr, position )
      end

    elseif selItem > 0 and reaper.IsMediaItemSelected(item) then

      for i = selItem-1, 0, -1  do
        item = reaper.GetSelectedMediaItem( 0, i )
        local itemGroup = reaper.GetMediaItemInfo_Value( item, "I_GROUPID" )

        if itemGroup == 0 then
          setTrimLeftFromPosition( item, position )
        else
          local itemArr = getItemsFromGroup( itemGroup )
          setTrimLeftFromPositionArr( itemArr, position )
        end
      end
           
    end
  reaper.Undo_EndBlock("Trim start", -1)
  end
  reaper.UpdateArrange()
end

main()


--reaper.UpdateArrange()
