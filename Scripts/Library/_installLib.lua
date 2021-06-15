--Script Name : Set library path
--Author : Jean Loup Pecquais
--Description : Set the path to Reaper Evolution library. Method comes from Scythe GUI lib.
--v1.0.0

local info = debug.getinfo(1,'S')
local scriptPath = info.source:match[[^@?(.*[\\/])[^\\/]-$]]

----------------- CHECK DEPENDANCY AND API AT STARTUP ------------------------------------

reaper.SetExtState("Reaper Evolution", "libPath", scriptPath, true)
  -- reaper.MB("Reaper Evolution's library path is now set to:\n" .. scriptPath, "Reaper Evolution", 0)

local os = reaper.GetOS()
local SWS = reaper.CF_GetSWSVersion("")
local reaperVersion = reaper.GetAppVersion()

reaperVersion = tonumber(string.sub(reaperVersion,1,4))

if reaperVersion < 6.29 then
  local foo = reaper.ShowMessageBox("This ReaVolution version need at least REAPER v6.19. Please update.", "Error : Wrong REAPER version", 0)
  if foo == 1 then reaper.Main_OnCommandEx(40004, 0, 0) end--File: Quit REAPER
end

if not SWS then
    local foo = reaper.ShowMessageBox("SWS extension are not found on this Reaper install. Please install them and relaunch Reaper", "Error : missing SWS extension", 0)
    if foo == 1 then reaper.Main_OnCommandEx(40004, 0, 0) end--File: Quit REAPER
end

--------------- INIT REAVOLUTION --------------------------

function main()
    local sampleRateDisplay = reaper.NamedCommandLookup("_RS9fce025a1c1a90bb341b923ace295f2a64bd908e") --Script: jlp_Samplerate display.lua
    local soloToggle = reaper.NamedCommandLookup("_RSeb3c845bb9f9045b7e99b5e75e34abfb12a03a5b") --Script: jlp_Solo toggle.lua
    local muteToggle = reaper.NamedCommandLookup("_RS62d1c0469012d74bfdbdafee8e8f62c3ab2f2f38") --Script: jlp_Mute toggle.lua
    --local specialSelect = reaper.NamedCommandLookup("_RSf9ec6040cf75749a0658c5c0e02c116de4378145") --Script: jlp_Special Select Item.lua

    reaper.Main_OnCommandEx(sampleRateDisplay, 0, 0)
    reaper.Main_OnCommandEx(soloToggle, 0, 0)
    reaper.Main_OnCommandEx(muteToggle, 0, 0)
    --reaper.Main_OnCommandEx(specialSelect, 0,0)
    reaper.Main_OnCommandEx(40776, 0, 0)-- Set grid to 1/16
end

reaper.defer(main)
