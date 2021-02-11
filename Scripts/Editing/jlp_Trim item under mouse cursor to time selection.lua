starttime, endtime = reaper.GetSet_LoopTimeRange2(0, false, false, 0, 0, false)

if starttime ~= endtime then
  local item = reaper.BR_ItemAtMouseCursor()
  --reaper.ShowConsoleMsg(tostring(item))
  if (item ~= nil) then
    reaper.PreventUIRefresh(1)
    -- reaper.Main_OnCommand(40528, 0) --select item under mouse
    reaper.Main_OnCommand(40508, 0) --trim to time selection
    reaper.PreventUIRefresh(-1)
  end
end
