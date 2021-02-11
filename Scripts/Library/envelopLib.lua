--Script Name : envelopLib.lua
--Author : Jean Loup Pecquais
--Description : function for envelop handling
--v1.0.0

function CountSelectedAutomationItems()

	local outputValue = 0
	local selTr = reaper.CountSelectedTracks()
	for i = 0, selTr-1 do
		local tr = reaper.GetSelectedTrack( 0, i )
		local numberTrackEnvelop = reaper.CountTrackEnvelopes( tr )
		for j = 0, numberTrackEnvelop-1 do
			trEnvelop = reaper.GetTrackEnvelope( tr , j )
			numberAutomationItems = reaper.CountAutomationItems( trEnvelop )
			print(numberAutomationItems)
			for k = 0, numberAutomationItems-1 do
				isSelected = reaper.GetSetAutomationItemInfo(trEnvelop, k, "D_UISEL", 0, false)
				if isSelected then
					outputValue = outputValue + 1
				end
			end
		end
	end
end
