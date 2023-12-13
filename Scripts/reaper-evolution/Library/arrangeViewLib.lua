--@author FLUX::
--@description Library for arrange view
--@version 23.12.0

function timeSelectionExist()
	starttime, endtime = reaper.GetSet_LoopTimeRange2(0, false, false, 0, 0, false)
	if starttime == endtime then
		return true
	else
		return false
	end
end

function timeSelectionVisible()
	local startTime, endTime = reaper.GetSet_ArrangeView2( 0, false, -1, -1 )
	local timeSelectionStart, timeSelectionEnd = reaper.GetSet_LoopTimeRange2( 0, false, false, -1, -1, false)

	if (timeSelectionStart < startTime and timeSelectionEnd < startTime) then
		return false
	else
		return true
	end

end