--Script Name : Define hardware output range
--Author : Jean Loup Pecquais
--Description : Define the hardware output range accessible by auto routing scripts
--v1.0.0

local libPath = reaper.GetExtState("Reaper Evolution", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Reaper Evolution library is not found. Please refer to user guide", "Library not found", 0)
    return
end

loadfile(libPath .. "reaVolutionLib.lua")()

-------------------------------------------------------------------------------------------------------------

::restart::

local firstOutput =reaper.GetExtState("ReaVolution","firstOutput") or getNextAvailableHardwareOut() or 0
local lastOutput = reaper.GetExtState("ReaVolution","lastOutput") or reaper.GetNumAudioOutputs()
local answerTable = {}

local retval, retvals_csv = reaper.GetUserInputs("Set hardware output range", 2, "First output (empty for default),Last Output (empty for default)", firstOutput..","..lastOutput)


if retval then

    local tableIndex = 0
    for word in string.gmatch(retvals_csv, '([^,]+)') do
        answerTable[tableIndex] =tonumber(word)
        tableIndex = tableIndex+1
    end
    
    if answerTable[0] == nil then answerTable[0] = getNextAvailableHardwareOut() or 0 end
    if answerTable[1] == nil then answerTable[1] = reaper.GetNumAudioOutputs() end

    if answerTable[0] > answerTable[1] then
        reaper.ShowMessageBox("First hardware output is higher than the last one.", "Error : Wrong hardware output range", 0)
        goto restart
    end

    reaper.SetExtState("ReaVolution", "firstOutput", answerTable[0]-1, true)
    reaper.SetExtState("ReaVolution", "lastOutput", answerTable[1]-1, true)
end