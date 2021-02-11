--Script Name : trackChunkLib
--Author : Jean Loup Pecquais
--Description : Handle track chunk
--v1.0.0

local chunkParamTable = 
{
	"MAINSEND",
	"MIDIOUT",
	"PERF",
	"TRACKID",
	"FX",
	"NCHAN",
	"INQ",
	"TRACKHEIGHT",
	"VU",
	"REC",
	"FREEMODE",
	"SHOWINMIX",
	"BUSCOMP",
	"ISBUS",
	"PLAYOFFS",
	"IPHASE",
	"MUTESOLO",
	"VOLPAN",
	"AUTOMODE",
	"BEAT",
	"PEAKCOL",
	"NAME",
	"TRACK",
	"SPEAKER"
}

function chunkToTable( trChunk )
	local t = {} for line in trChunk:gmatch("[^\r\n]+") do t[#t+1] = line end

	for i = 1, #t-1 do
	-- t[i] = t[i]:gsub('-','')
	t[i] = t[i]:gsub('<','')
	t[i] = t[i]:gsub('>','')

		for k, v in pairs(chunkParamTable) do
	    	if string.find(t[i], v) ~= nil then
	    		value = tostring(t[i]:gsub(v, ""))
	    		local arrValue = {v, value}
	    		t[i] = arrValue
	    		break
	    	end
		end
	end
	return t
end

function tableToChunk( arr )
local chunk = "<"
	for k, v in pairs(arr) do
		if v[1] ~= nil then
			chunk = chunk..v[1]	
			if v[2] ~= nil then
				chunk = chunk..v[2].."\n"
			else
				chunk = chunk.."\n"
			end
		end
	end
return chunk..">"
end