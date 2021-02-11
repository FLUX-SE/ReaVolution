--Script Name : jlp_Select previous track or previous item.lua
--Author : Jean Loup Pecquais
--Description : Select previous track or previous item
--v1.0.0

local libPath = reaper.GetExtState("Reaper Evolution", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Reaper Evolution library is not found. Please refer to user guide", "Library not found", 0)
    return
end

loadfile(libPath .. "reaVolutionLib.lua")()

-------------------------------------------------------------------------------------------------------------


  local context = reaper.GetCursorContext2( true )

  if context == 0 then
  	reaper.Main_OnCommandEx(40286, 0, 0) -- select previous track
  elseif context == 1 then
  	reaper.Main_OnCommandEx(40416, 0, 0) -- select previous item
  end
