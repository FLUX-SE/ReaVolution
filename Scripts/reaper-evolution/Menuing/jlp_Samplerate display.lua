--Script Name : jlp_Samplerate display.lua
--Author : Jean Loup Pecquais
--Description : Display current project samplerate
--v1.0.0

local libPath = reaper.GetExtState("Reaper Evolution", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Reaper Evolution library is not found. Please refer to user guide", "Library not found", 0)
    return
end

loadfile(libPath .. "reaVolutionLib.lua")()

---- generic mouse handling ----

mouse={}

function OnMouseDown()
  --reaper.ShowConsoleMsg("OnMouseDown\n")
  mouse.down=true ; mouse.capcnt=0
  mouse.ox,mouse.oy=gfx.mouse_x,gfx.mouse_y
  local lastWindowUnderMouse, lastSegmentUnderMouse, lastDetailUnderMouse = reaper.BR_GetMouseCursorContext()
  reaper.SetExtState('ReaVolution', 'lastWindowUnderMouse', lastWindowUnderMouse, true)
  reaper.SetExtState('ReaVolution', 'lastSegmentUnderMouse', lastSegmentUnderMouse, true)
  reaper.SetExtState('ReaVolution', 'lastDetailUnderMouse', lastDetailUnderMouse, true)
end

function OnMouseDoubleClick()
  reaper.Main_OnCommandEx(40021, 1, 0)
  --reaper.ShowConsoleMsg("OnMouseDoubleClick\n")
end

function OnMouseMove()
   
  mouse.lx,mouse.ly=gfx.mouse_x,gfx.mouse_y
  mouse.capcnt=mouse.capcnt+1
end

function OnMouseUp()
  --reaper.ShowConsoleMsg("OnMouseUp\n")
  mouse.down=false
  mouse.uptime=os.clock()
end

--------------------------------------------------
-- Function to convert rgb to number for get.clear
--------------------------------------------------

  local function rgb2num(red, green, blue)
    
    green = green * 256
    blue = blue * 256 * 256
    
    return red + green + blue
  
  end
  
--------------------------------------------------
-- Sample rate check -----------------------------
-------------------------------------------------- 

function samplerateCheck()
  local samplerate = reaper.GetSetProjectInfo(0, "PROJECT_SRATE", 0, false)
  local countItems = reaper.CountMediaItems(0)
  
  if countItems ~= 0 and countItems ~= lastCountItems then
    for i=0,countItems-1 do
      local MediaItem = reaper.GetMediaItem(0, i)
      local countTakes = reaper.CountTakes(MediaItem)
      for tk=0,countTakes-1 do
        local MediaItem_Take = reaper.GetMediaItemTake(MediaItem, tk)
        local sourceSampleRate = nil
        if MediaItem_Take ~= nil then
          local PCM_source = reaper.GetMediaItemTake_Source(MediaItem_Take)
          sourceSampleRate = reaper.GetMediaSourceSampleRate(PCM_source)
        end
        if sourceSampleRate ~= samplerate and sourceSampleRate ~= 0 then
          samplerateMatching = 0
          goto done
        else
          samplerateMatching = 1
        end
      end
    end
  elseif countItems == 0 then
    return true
  end
  ::done::
  lastCountItems = countItems
  if samplerateMatching == 0 then
    return false
  else
    return true
  end
end

--------------------------------------------------
-- Main fuction ----------------------------------
-------------------------------------------------- 
 
  local function main()
  
    local char = gfx.getchar()
    if char ~= 27 and char ~= -1 then
      reaper.defer(main)
    end
    
    local samplerate = reaper.GetSetProjectInfo(0, "PROJECT_SRATE", 0, false)
    local _samplerateCheck = samplerateCheck()
    local _samplerate = string.format("%i", samplerate)
    
    local x, y = 0, 0
    local w, h = 130, 35
    local r = 10
    
    if _samplerateCheck == true then
    gfx.set(0.4, 1, 0.4, 1)
    else
    gfx.set(1, 0.4, 0.4, 1)    
    end
    
    gfx.setfont(1, "Arial", 28)
    local str_w, str_h = gfx.measurestr(_samplerate)
    
    gfx.x = x + ((w - str_w) / 2)
    gfx.y = y + ((h - str_h) / 2)
    
    local r, g, b = 51, 51, 51
    local color_int = rgb2num(r, g, b)
    
    if gfx.mouse_cap&1 == 1 then
      if not mouse.down then
        OnMouseDown()      
        if mouse.uptime and os.clock()-mouse.uptime < 0.25 then 
          OnMouseDoubleClick()
        end
      elseif gfx.mouse_x ~= mouse.lx or gfx.mouse_y ~= mouse.ly then
        OnMouseMove() 
      end
    elseif mouse.down then 
      OnMouseUp() 
    end
    
    gfx.drawstr(_samplerate)
    gfx.clear = color_int
    gfx.update()
    
    --reaper.runloop(main)
  end
  
--------------------------------------------------
-- Script Running --------------------------------
--------------------------------------------------

  gfx.init("Sample Rate", w, h, 1, x, y)
  lastCountItems = reaper.CountMediaItems(0)
  samplerateMatching = nil
  reaper.defer(main)
