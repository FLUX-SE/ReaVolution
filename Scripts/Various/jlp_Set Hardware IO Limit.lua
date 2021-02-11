--Script Name : scriptTemplate
--Author : Jean Loup Pecquais
--Description : Simple template
--v1.0.0

local libPath = reaper.GetExtState("Reaper Evolution", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Reaper Evolution library is not found. Please refer to user guide", "Library not found", 0)
    return
end

loadfile(libPath .. "reaVolutionLib.lua")()

-------------------------------------------------------------------------------------------------------------

function main()
	local outputLowerLimit = reaper.GetExtState("reaperEvolution", "outputStart")
	local outputUpperLimit = reaper.GetExtState("reaperEvolution", "outputEnd")
	local fill = tostring(outputLowerLimit)..","..tostring(outputUpperLimit)

	local retval, retvals_csv = reaper.GetUserInputs( "Hardware IO setup", 2, "Outputs start point,Outputs end point", fill )

	outputLowerLimit = string.match(retvals_csv, "%d+".."%,")
	outputUpperLimit = string.match(retvals_csv, "%,".."%d+")

	if outputLowerLimit == nil or outputUpperLimit == nil then
    	reaper.MB("The limits are invalide inputs, please try again", "Invalide inputs", 0)
    	return		
	end

	outputLowerLimit = tonumber(string.match(outputLowerLimit, "%d+"))
	outputUpperLimit = tonumber(string.match(outputUpperLimit, "%d+"))

	reaper.SetExtState("reaperEvolution", "outputStart", outputLowerLimit, true)
	reaper.SetExtState("reaperEvolution", "outputEnd", outputUpperLimit, true)
end

main()