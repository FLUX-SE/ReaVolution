--Script Name : Playback mode
--Author : Jean Loup Pecquais
--Description : Allow to switch between to play mode. In first state,
--              the edit cursor remains where the playback stop. In the other state the edit cursor
--              stay a the begin of the playback
--v1.0.0

local libPath = reaper.GetExtState("Reaper Evolution", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Reaper Evolution library is not found. Please refer to user guide", "Library not found", 0)
    return
end

local dummyToggle = reaper.NamedCommandLookup('_S&M_DUMMY_TGL2')
local dummyToogleState = reaper.GetToggleCommandState(dummyToggle)

local playState = reaper.GetToggleCommandState(1007)
--reaper.ShowConsoleMsg(tostring(playState)) 

local function stop()
  if dummyToogleState == 0 then
    reaper.Main_OnCommandEx(1016, 1, 0) --Stop
  else
    reaper.Main_OnCommandEx(1008, 1, 0) --Pause    
    reaper.Main_OnCommandEx(1016, 1, 0) --Stop    
  end

end

local function main()

  if playState == 0 then
    reaper.Main_OnCommandEx(1007, 1, 0) --Pause
  else
    stop()
  end

end

reaper.defer(main)
