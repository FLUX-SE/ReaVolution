--Script Name : toolLib.lua
--Author : Jean Loup Pecquais
--Description : General toolset lib
--v1.0.0

function print(value)

  value = value or "hello!"

  local typeValue = type(value)
  reaper.ShowConsoleMsg(typeValue.." :\n")

  if typeValue == "table" then
    for k, v in ipairs(value) do
      reaper.ShowConsoleMsg("Index "..tostring(k).." : ")
      if type(v) == "table" then
        local tableSize = #v
        if tableSize > 1 then
          for i = 1, tableSize do
            reaper.ShowConsoleMsg(tostring(v[i]).." ")
          end
          reaper.ShowConsoleMsg("\n")
        end
      else
        reaper.ShowConsoleMsg(tostring(v).."\n")
      end
    end
  elseif typeValue == "string" then
    reaper.ShowConsoleMsg(value.."\n")
  else
    reaper.ShowConsoleMsg(tostring(value).."\n")
  end
  reaper.ShowConsoleMsg("\n")

end

function tablelength(arr)
  local count = 0
  for _ in pairs(arr) do count = count + 1 end
  return count
end

function tableCleanDouble(arr)
local hash = {}
local res = {}

  for _,v in ipairs(arr) do
     if (not hash[v]) then
         res[#res+1] = v
         hash[v] = true
     end
  end

  return res
end

function tableToString(inTable)
  local outString = inTable[1]
  if #inTable >= 2 then
    for i=2,#inTable,1 do
      outString = outString..","..inTable[i]
    end
  end
  return outString
end

function evenNumber(number)
  modulo = number % 2
  if not modulo == 0 then
    number = number + 1
  end
  return number
end

function string:split( inSplitPattern, outResults )
  if not outResults then
    outResults = { }
  end
  local theStart = 1
  local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
  while theSplitStart do
    table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
    theStart = theSplitEnd + 1
    theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
  end
  table.insert( outResults, string.sub( self, theStart ) )
  return outResults
end

function firstItemIdx()
  for itemIdx=0,numItems-1,1 do --appliquer diff de placement a tous les items
      local item = reaper.GetMediaItem(0, itemIdx)
      itemTable[itemIdx] = item
      itemPosTable[itemIdx] = reaper.GetMediaItemInfo_Value(item, "D_POSITION")--get position first item
  end

  local newLow = reaper.GetProjectLength(0) --set a ridiculously high "threshold" to compare against
  local numPosition = 0 --set a variable to hold your position value

  for i = 0,#itemPosTable do
    local asNum = itemPosTable[i]
    
    if ( asNum and asNum < newLow ) then
      newLow = asNum
      numPosition = i
    end

  end

  return numPosition, itemTable[numPosition]
end

function calculateBitMask( numberOfChannel )
local bitmask = 0
  for i = 0, numberOfChannel-1 do
    local ch = 1>>i
    bitmask = bitmask + ch
  end
  return bitmask
end

function table.val_to_str ( v )
  if "string" == type( v ) then
    v = string.gsub( v, "\n", "\\n" )
    if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
      return "'" .. v .. "'"
    end
    return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
  else
    return "table" == type( v ) and table.tostring( v ) or
      tostring( v )
  end
end

function table.key_to_str ( k )
  if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
    return k
  else
    return "[" .. table.val_to_str( k ) .. "]"
  end
end

function table.tostring( tbl )
  local result, done = {}, {}
  for k, v in ipairs( tbl ) do
    table.insert( result, table.val_to_str( v ) )
    done[ k ] = true
  end
  for k, v in pairs( tbl ) do
    if not done[ k ] then
      table.insert( result,
        table.key_to_str( k ) .. "=" .. table.val_to_str( v ) )
    end
  end
  return "{" .. table.concat( result, "," ) .. "}"
end

function getMinMaxFromTable( arr )
  local t_min = 10000000
  local t_max = 0
    for i, n in pairs(arr) do
    if n > t_max then
        t_max = n
    end
    if n < t_min then
        t_min = n
    end
  end
  return t_min, t_max
end

function table.concat2(t1,t2)
  for i=1,#t2 do
      t1[#t1+i] = t2[i]
  end
  return t1
end

function getIndexFromValue( table, value )
  local index = {}
  for k, v in pairs(table) do
    index[v] = k
  end
  return index[value]
end

function sleep(s)
  local ntime = os.clock() + s/10
  repeat until os.clock() > ntime
end

function parseFilePath(path)
  return string.match(path, "(.-)([^\\/]-%.?([^%.\\/]*))$")
end