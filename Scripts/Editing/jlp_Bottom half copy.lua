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

local av = reaper.JS_Window_FindChildByID(reaper.GetMainHwnd(), 1000)
local mouseHand = reaper.JS_Mouse_LoadCursorFromFile(reaper.GetResourcePath().."/Cursors/overItem.cur")

function loop()
    -- tIntercepts["WM_SETCURSOR"] = false
    reaper.JS_Mouse_SetCursor(mouseHand)
    reaper.JS_WindowMessage_Intercept(av, "WM_SETCURSOR:block", false)
    reaper.defer(loop)
end

loop()