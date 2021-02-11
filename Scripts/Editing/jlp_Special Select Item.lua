--Script Name : jlp_Special Select Item
--Author : Jean Loup Pecquais
--Description : Special Select Item
--v1.0.0

local libPath = reaper.GetExtState("Reaper Evolution", "libPath")
if not libPath or libPath == "" then
    reaper.MB("Reaper Evolution library is not found. Please refer to user guide", "Library not found", 0)
    return
end

loadfile(libPath .. "reaVolutionLib.lua")()

-------------------------------------------------------------------------------------------------------------

-- To do : 
-- - Intercept WIN key
-- map ripple edit on win key plus bottom move item
-- map split item on win key plus top left click item

local item = 0
local prevTime = 0
local prevTime2 = 0
local prevTime3 = 0
local prevTime4 = 0
local prevMove = 0
local mouseMove = 0
local noMouse = 1
local window, segment, details = nil, nil, nil
local w = nil
local startTime, endTime = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
local split = reaper.NamedCommandLookup( "_RS88637ff7e9db41b592cf920731b58753d75808ef" )
-- local split = reaper.NamedCommandLookup( "_RS88637ff7e9db41b592cf920731b58753d75808ef" )
local lastPosX = 0
local prepareSnap = false
local clickTopItem = -1
local mouseNormal = reaper.JS_Mouse_LoadCursor(32512)
local mouseHand = reaper.JS_Mouse_LoadCursorFromFile(reaper.GetResourcePath().."/Cursors/overItem.cur")
local mouseRazor = reaper.JS_Mouse_LoadCursorFromFile(reaper.GetResourcePath().."/Cursors/razorCur.cur")
local tIntercepts = { WM_LBUTTONDOWN   = true,
                      WM_LBUTTONUP     = true,
                      WM_LBUTTONDBLCLK = true,
                      WM_MBUTTONDOWN   = true,
                      WM_MBUTTONUP     = true,
                      WM_MBUTTONDBLCLK = true,
                      WM_RBUTTONDOWN   = true,
                      WM_RBUTTONUP     = true,
                      WM_RBUTTONDBLCLK = true,
                      WM_MOUSEWHEEL    = true,
                      WM_MOUSEHWHEEL   = true,
                      WM_MOUSEMOVE     = true,
                      WM_KEYDOWN       = true,
                      WM_HOTKEY        = false
                      }

function OnMouseMove()
    local peekOK, _, time, keys, _, x, y = reaper.JS_WindowMessage_Peek(w, "WM_MOUSEMOVE")
    if peekOK and x ~= prevMove then
        mouseMove = 1
    else
        mouseMove = 0
    end
    prevMove = x
end

function GetTopItem( item ) --thanks Edgemeal /// 
    if item then

        
        local totalTake = reaper.CountTakes(item)
        local take = reaper.BR_TakeAtMouseCursor()
        local scaleTake = 0
        if take then
            scaleTake = reaper.GetMediaItemTakeInfo_Value( take, "IP_TAKENUMBER" )
        end
        
        local mouseX,mouseY = reaper.GetMousePosition() -- get x,y of the mouuse
        local track = reaper.GetTrackFromPoint(mouseX,mouseY) -- get track under mouse
        if not track then return end
        local trackY = reaper.GetMediaTrackInfo_Value(track, "I_TCPY") -- get y of track
        local trackH = reaper.GetMediaTrackInfo_Value(track, "I_TCPH") -- get height of the track
        
        local av = reaper.JS_Window_FindChildByID(reaper.GetMainHwnd(), 1000) -- arangeview
        local cx, cy = reaper.JS_Window_ScreenToClient(av,mouseX,mouseY) -- REQUIRES JS_API
        
        
        local trackFreeMode = reaper.GetMediaTrackInfo_Value(track, "B_FREEMODE" ) -- get state of track free positionning trackFreeMode
        if trackFreeMode == 1 then
            local itemH = trackH*reaper.GetMediaItemInfo_Value(item, "F_FREEMODE_H") -- get height of the track
            local itemY = trackY + trackH*reaper.GetMediaItemInfo_Value(item, "F_FREEMODE_Y") -- get height of the track
            trackY = itemY
            trackH = itemH
        end
        
        local takeVis = reaper.GetToggleCommandState(40435) --check if take lane are displayed
        if takeVis == 1 then
            trackH = trackH / totalTake
        else
            scaleTake = 0
        end
        
        local top =  cy < (trackY + trackH*scaleTake + trackH*0.5)--+5 --and cy > trackY + trackH
        return top
    else
        return false
    end
end

function GetItemPosWidthPx( item )
    if item then
        local mouseX,mouseY = reaper.GetMousePosition() -- get x,y of the mouuse
        local track = reaper.GetTrackFromPoint(mouseX,mouseY) -- get track under mouse
        if not track then return end
        local trackY = reaper.GetMediaTrackInfo_Value(track, "I_TCPY") -- get y of track
        local trackH = reaper.GetMediaTrackInfo_Value(track, "I_TCPH") -- get height of the track
        
        local av = reaper.JS_Window_FindChildByID(reaper.GetMainHwnd(), 1000) -- arangeview
        local cx, cy = reaper.JS_Window_ScreenToClient(av,mouseX,mouseY) -- REQUIRES JS_API
        
        
        local trackFreeMode = reaper.GetMediaTrackInfo_Value(track, "B_FREEMODE" ) -- get state of track free positionning trackFreeMode
        if trackFreeMode == 1 then
            local itemH = trackH*reaper.GetMediaItemInfo_Value(item, "F_FREEMODE_H") -- get height of the track
            local itemY = trackY + trackH*reaper.GetMediaItemInfo_Value(item, "F_FREEMODE_Y") -- get height of the track
            trackY = itemY
            trackH = itemH
        end

        return trackY, trackH
    end
end

function GetVolHandle( item )
    -- TO DO
    -- - Exclude Fade In/Out area ... Not sure about this
    -- - Calculate fade curve
    if item then
        local deadZone = 2
        local mouseX,mouseY = reaper.GetMousePosition() -- get x,y of the mouuse
        
        local itemVolMode = reaper.SNM_GetIntConfigVar("itemvolmode", -1)
        local itemVol = reaper.GetMediaItemInfo_Value( item, "D_VOL")
        local itemVolPx
        
        local track = reaper.GetTrackFromPoint(mouseX,mouseY) -- get track under mouse
        if not track then return end
        local trackY = reaper.GetMediaTrackInfo_Value(track, "I_TCPY") -- get y of track
        local trackH = reaper.GetMediaTrackInfo_Value(track, "I_TCPH") -- get height of the track
        
        local trackFreeMode = reaper.GetMediaTrackInfo_Value(track, "B_FREEMODE" ) -- get state of track free positionning trackFreeMode
        if trackFreeMode == 1 then
            local itemH = trackH*reaper.GetMediaItemInfo_Value(item, "F_FREEMODE_H") -- get height of the track
            local itemY = trackY + trackH*reaper.GetMediaItemInfo_Value(item, "F_FREEMODE_Y") -- get height of the track
            trackY = itemY
            trackH = itemH
        end
        
        if itemVolMode == 0 then
            itemVolPx = trackH - trackH*itemVol
            if itemVolPx < 0 then itemVolPx = 0 end
        elseif itemVolMode == 1 then
            itemVolPx = trackH - trackH*0.5*itemVol
            if itemVolPx < 0 then itemVolPx = 0 end
        end
        
        local av = reaper.JS_Window_FindChildByID(reaper.GetMainHwnd(), 1000) -- arangeview
        local cx, cy = reaper.JS_Window_ScreenToClient(av,mouseX,mouseY) -- REQUIRES JS_API
        
        local over = cy > (trackY + itemVolPx - deadZone) and cy < (trackY + itemVolPx + deadZone)
        
        return over   
    end
end

function GetItem( item )
    if item then
    local px = 7
    local zoomFactor = reaper.GetHZoomLevel()
    local mouseX = reaper.BR_PositionAtMouseCursor(false)*zoomFactor
    
    local itemPosPx = reaper.GetMediaItemInfo_Value( item, "D_POSITION" )*zoomFactor
    local itemEndPx = itemPosPx + reaper.GetMediaItemInfo_Value( item, "D_LENGTH" )*zoomFactor
    
    local itemFadeInPx = reaper.GetMediaItemInfo_Value( item, "D_FADEINLEN_AUTO" )*zoomFactor
    if itemFadeInPx == 0 then
        itemFadeInPx = reaper.GetMediaItemInfo_Value( item, "D_FADEINLEN" )*zoomFactor
    end
    local itemFadeOutPx = reaper.GetMediaItemInfo_Value( item, "D_FADEOUTLEN_AUTO" )*zoomFactor
    if itemFadeOutPx == 0 then
        itemFadeOutPx = reaper.GetMediaItemInfo_Value( item, "D_FADEOUTLEN" )*zoomFactor
    end

    local inItem = mouseX > itemPosPx+itemFadeInPx+px and mouseX < itemEndPx-itemFadeOutPx-px
    return inItem
    else return false
    end
end

function DrawSplitLine( item, key )
    local bitmap = nil
    local id = nil
    if item and reaper.JS_Mouse_GetState(key) == key then
        local mouseX,mouseY = reaper.GetMousePosition() -- get x,y of the mouse        
        local itemY, itemW = GetItemPosWidthPx( item )

        if reaper.ValidatePtr(id, "HWND") then
            bitmap = reaper.JS_LICE_CreateBitmap(false, 2, itemW)
            reaper.JS_LICE_Clear(bitmap, 0xFFFF0000)
        end
    else
        if bitmap then reaper.JS_LICE_DestroyBitmap(bitmap) end
        if id then reaper.JS_Window_Destroy(id) end
    end
end

function main()
    local shiftKey = reaper.JS_Mouse_GetState(8)
    local ctrlKey = reaper.JS_Mouse_GetState(4)
    local winKey = reaper.JS_Mouse_GetState(32)
    local altKey = reaper.JS_Mouse_GetState(16)
    
    local posX, posY = reaper.GetMousePosition()
    
    
    
    if reaper.CountTracks(0) ~= 0 then
            
        OnMouseMove()
        startTime, endTime = reaper.GetSet_LoopTimeRange(false, false, startTime, endTime, true)
        
        
        if noMouse then
            item = reaper.BR_ItemAtMouseCursor()
            if item then take = reaper.GetActiveTake(item) if take then
            midiInline = reaper.BR_IsMidiOpenInInlineEditor( take ) end end
        end
        local itemSelLastState = 0
        
        window, segment, details = reaper.BR_GetMouseCursorContext()
        for key, value in pairs(tIntercepts) do
            if window == "arrange" then
                w = reaper.JS_Window_FromPoint(reaper.GetMousePosition())
                OK = reaper.JS_WindowMessage_Intercept(w, key, value)
            end
        end
        
        --Compute mouse speed to get somether time selection
        local mouseSpeedX = lastPosX - posX
        if mouseSpeedX < 0 then mouseSpeedX = mouseSpeedX*(-1) end  
        local deadZone = (mouseSpeedX*4+3)/reaper.GetHZoomLevel()        
        
        --Mouse Left Down
        local peekOK, _, time, keys, _, x, y = reaper.JS_WindowMessage_Peek(w, "WM_LBUTTONDOWN")
        if peekOK and time ~= prevTime then
                        
            if shiftKey == 8 and ctrlKey == 4 and GetTopItem( item ) then
                setSnapOffset( item )
                -- reaper.Main_OnCommandEx(split, 0, 0) --Split
            end
            
            noMouse = false
            if GetTopItem( item ) then
                clickTopItem = 1
            else
                clickTopItem = 0
            end
            
            local mouseContext = reaper.GetCursorContext()
            -- print(mouseContext)
            local position =  reaper.BR_PositionAtMouseCursor( false )
            startTime, endTime = reaper.GetSet_LoopTimeRange(false, false, startTime, endTime, true)
            if mouseContext ~= 2 then
                if position < startTime-deadZone or position > endTime+deadZone then
                    if reaper.GetToggleCommandState(40573) ~= 1 then
                        reaper.Main_OnCommandEx(40635, 0, 0) --Time selection: Remove time selection
                    end
                elseif (position > startTime+deadZone and position < endTime-deadZone) and ((item and GetTopItem( item )) or not item) then
                    if reaper.GetToggleCommandState(40573) ~= 1 then
                        reaper.Main_OnCommandEx(40635, 0, 0) --Time selection: Remove time selection
                    end   
                end
            end
        end
        
        --Mouse Right Down
        local peekOK, _, time3, keys, _, x, y = reaper.JS_WindowMessage_Peek(w, "WM_RBUTTONDOWN")
        if peekOK and time3 ~= prevTime3 then

            -- if altKey == 16 and GetTopItem( item ) then
            --     reaper.Main_OnCommandEx(41848, 0, 0) --Stretch
            -- elseif altKey+winKey == 48 and GetTopItem( item ) then
            --     setSnapOffset( item )
            --     -- reaper.Main_OnCommandEx(41848, 0, 0) --Stretch
            -- end
            
        end    

        -- On Mouse Move
        if mouseMove == 1 and item and clickTopItem == 0 then
            local selItem = reaper.CountSelectedMediaItems(0)
            local tStart = {}
            local tEnd = {}
            local item2Pos = 0
            local item2End = 0
            for i = 0, selItem-1 do
                local item2 = reaper.GetSelectedMediaItem( 0, i )
                item2Pos = reaper.GetMediaItemInfo_Value( item2, "D_POSITION" )
                item2End = item2Pos + reaper.GetMediaItemInfo_Value( item2, "D_LENGTH" )
                if itemIsInTimeSelection(item2) then
                    table.insert(tStart, item2Pos)
                    table.insert(tEnd, item2End)                        
                elseif itemIsBiggerThanTimeSelection(item2) then
                    table.insert(tStart,startTime)
                    table.insert(tEnd, endTime)
                elseif timeStartCrossItem(item2) then
                    table.insert(tStart,startTime)
                    table.insert(tEnd, item2End)                        
                elseif timeEndCrossItem(item2) then
                    table.insert(tStart, item2Pos)
                    table.insert(tEnd, endTime)
                end
            end
            table.sort(tStart)
            table.sort(tEnd)
            if tStart[1] ~= nil and tEnd[#tEnd] ~= nil then
                reaper.GetSet_LoopTimeRange(true, false, tStart[1], tEnd[#tEnd], true)
            end
            
            
            if shiftKey == 8 then
                if ctrlKey == 4 then reaper.Main_OnCommandEx(40310, 0, 0) else reaper.Main_OnCommandEx(40311, 0, 0) end--ripple edit on
            else
                reaper.Main_OnCommandEx(40309, 0, 0) --ripple edit off
            end
    
                
        elseif mouseMove == 1 and not noMouse and item and GetTopItem( item ) then
            prepareSnap = true
        end

        if shiftKey == 8 and GetItem( item ) then
            if ctrlKey == 4 then reaper.Main_OnCommandEx(40310, 0, 0) else reaper.Main_OnCommandEx(40311, 0, 0) end--ripple edit on
        else
            reaper.Main_OnCommandEx(40309, 0, 0) --ripple edit off
        end

        --MouseUp
        local peekOK2, _, time2, keys, _, x, y = reaper.JS_WindowMessage_Peek(w, "WM_LBUTTONUP")
        if peekOK2 and time2 ~= prevTime2 then
            noMouse = true
            if prepareSnap and shiftKey ~= 8 then
                if startTime ~= endTime then reaper.GetSet_LoopTimeRange(true, false, reaper.SnapToGrid(0, startTime), reaper.SnapToGrid(0, endTime), true) end
            end
            prepareSnap = false
            clickTopItem = -1
            local mouseContext = reaper.GetCursorContext()
            local position =  reaper.BR_PositionAtMouseCursor( false )
            if mouseContext == 2 then
                if position < startTime-deadZone or position > endTime+deadZone then
                    if reaper.GetToggleCommandState(40573) ~= 1 then
                        reaper.Main_OnCommandEx(40635, 0, 0) --Time selection: Remove time selection
                    end
                elseif (position > startTime+deadZone and position < endTime-deadZone) and ((item and GetTopItem( item )) or not item) then
                    if reaper.GetToggleCommandState(40573) ~= 1 then
                        reaper.Main_OnCommandEx(40635, 0, 0) --Time selection: Remove time selection
                    end   
                end
            end
        end
        
        -- Handle ripple edit with mouse modifer
        
        -- check if item is selected
        if GetItem( item ) and noMouse and not midiInline then 
            if not GetTopItem( item ) and not GetVolHandle( item ) then
                if details ~= "item_stretch_marker" then
                    -- print(details)
                    tIntercepts["WM_SETCURSOR"] = false
                    reaper.JS_Mouse_SetCursor(mouseHand)
                else
                    reaper.JS_WindowMessage_Release(w, "WM_SETCURSOR")                      
                end
                if shiftKey == 8 then
                    reaper.SetMouseModifier("MM_CTX_ITEM", 0, "23")-- -> We move the item following time selection ignoring snap
                else
                    reaper.SetMouseModifier("MM_CTX_ITEM", 0, "22")-- -> We move the item following time selection
                end
            elseif not GetTopItem( item ) and not GetVolHandle( item ) and not GetItem( item ) then
                reaper.SetMouseModifier("MM_CTX_ITEM", 0, "0")-- -> We do nothing
            else
                reaper.JS_WindowMessage_Release(w, "WM_SETCURSOR")
                reaper.SetMouseModifier("MM_CTX_ITEM", 0, "29")-- -> We create a time selection 29
            end
        elseif not GetItem( item ) then
            reaper.JS_WindowMessage_Release(w, "WM_SETCURSOR")  
        end

        
        prevTime  = time
        prevTime2 = time2
        prevTime3 = time3
        prevTime4 = time4
    end
    lastPosX = posX
    reaper.defer(main)
end

function atExit()
    reaper.JS_WindowMessage_ReleaseAll()
end

reaper.defer(main)

reaper.atexit(atExit)
