--Script Name : jlp_Smart duplicate.lua
--Author : Jean Loup Pecquais
--Description : Duplicate track, item or automation item
--v1.0.0

local libPath = reaper.GetExtState("Reaper Evolution", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Reaper Evolution library is not found. Please refer to user guide", "Library not found", 0)
    return
end

loadfile(libPath .. "reaVolutionLib.lua")()

function main()

	local lastContext = reaper.GetCursorContext2(true)

	if lastContext == 0 then
		--track panel
		reaper.Main_OnCommand(40062, 0) --duplicate track
	elseif lastContext == 1 then
		--item
		local starttime, endtime = reaper.GetSet_LoopTimeRange2(0, false, false, 0, 0, false)
		if starttime == endtime then
			reaper.Main_OnCommand(41295, 0) --duplicate item
		else
			reaper.Main_OnCommand(40718, 0) --select item in current time selection on selected track
			reaper.Main_OnCommand(41296, 0) --duplicate item
		end
	elseif lastContext == 2 then
		--Automation
		reaper.Main_OnCommand(42083, 0) --duplicate automation
	end

end

main()
