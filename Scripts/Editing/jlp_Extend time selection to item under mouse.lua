--Script Name : jlp_Extend time selection to item under mouse.lua
--Author : Jean Loup Pecquais
--Description : Extend time selection to item under mouse
--v1.0.0

local libPath = reaper.GetExtState("Reaper Evolution", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Reaper Evolution library is not found. Please refer to user guide", "Library not found", 0)
    return
end

loadfile(libPath .. "reaVolutionLib.lua")()

function main()
  local starttime, endtime = reaper.GetSet_LoopTimeRange2(0, false, false, 0, 0, false)
  local item = reaper.BR_ItemAtMouseCursor()
  
  if (item ~= nil) then
  
    local startitem = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
    local enditem = startitem + reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
  
    if startitem <= starttime then
      reaper.GetSet_LoopTimeRange(true, true, startitem, endtime, false)
    end
  
    if startitem >= starttime then
      reaper.GetSet_LoopTimeRange(true, true, starttime, enditem, false) 
    end
  

  end
end

main()


