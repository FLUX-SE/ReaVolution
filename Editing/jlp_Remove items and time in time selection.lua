----------------------------------
-- Author : Jean Loup Pecquais
-- Name : Remove items and time selection
----------------------------------

function main()

  local starttime, endtime = reaper.GetSet_LoopTimeRange2(0, false, false, 0, 0, false)

  reaper.Undo_BeginBlock()  

  local context = reaper.GetCursorContext2( true )

  if context == 1 or context == 2 then
    if starttime ~= endtime then
      reaper.SetEditCurPos(starttime, true, false)  
      reaper.Main_OnCommandEx(40311, 0, 0)--Ripple edit on
      reaper.Main_OnCommandEx(40201, 0, 0)--Remove content from time selection
      reaper.Main_OnCommandEx(40309, 0, 0)--Remove edit off
      reaper.Undo_EndBlock("Remove items", -1)

    else
      reaper.Main_OnCommandEx(40310, 0, 0)--Ripple per track edit on
      reaper.Main_OnCommandEx(40006, 0, 0)--Remove item
      reaper.Main_OnCommandEx(40309, 0, 0)--Remove edit off
      reaper.Undo_EndBlock("Remove item", -1)

    end
  end


end

main()
