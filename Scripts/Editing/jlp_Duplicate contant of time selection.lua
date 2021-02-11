----------------------------------
-- Author : Jean Loup Pecquais
-- Name : Duplicate time or ripple duplicate item
----------------------------------

function main()

  reaper.Undo_BeginBlock()  

  local starttime, endtime = reaper.GetSet_LoopTimeRange2(0, false, false, 0, 0, false)
  reaper.SetEditCurPos(endtime, true, false)  
  local context = reaper.GetCursorContext2( true )

  local copy = reaper.NamedCommandLookup("_RSc065e534e7cca421c222aea99b0477a625f70971")
  reaper.Main_OnCommandEx(copy, 0, 0)
  local paste = reaper.NamedCommandLookup("_RSb3671bb58b6714a1a660d8b30b666fd66f3051cb")
  reaper.Main_OnCommandEx(paste, 0, 0)

  local starttime, endtime = reaper.GetSet_LoopTimeRange2(0, true, false, endtime, endtime+(endtime-starttime), true)
  reaper.SetEditCurPos(endtime, true, false)  

end
  
local frames = 10
reaper.PreventUIRefresh(-1*frames)
main()
reaper.PreventUIRefresh(frames)