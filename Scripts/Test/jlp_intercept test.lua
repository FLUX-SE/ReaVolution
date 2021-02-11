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

local tr = reaper.GetSelectedTrack( 0, 0 )
local value = reaper.GetMediaTrackInfo_Value( tr, "I_AUTOMODE" )
print(value)

-- -- tIntercepts = { WM_LBUTTONDOWN   = false,
-- --                 WM_LBUTTONUP     = false,
-- --                 WM_LBUTTONDBLCLK = false,
-- --                 WM_MBUTTONDOWN   = true,
-- --                 WM_MBUTTONUP     = true,
-- --                 WM_MBUTTONDBLCLK = true,
-- --                 WM_RBUTTONDOWN   = true,
-- --                 WM_RBUTTONUP     = true,
-- --                 WM_RBUTTONDBLCLK = true,
-- --                 WM_MOUSEWHEEL    = true,
-- --                 WM_MOUSEHWHEEL   = true,
-- --                 WM_MOUSEMOVE     = true,
-- --                 WM_KEYDOWN       = false,
-- --                 WM_HOTKEY        = false
-- --                 }

-- local tIntercepts = {}
-- function main()
--         tIntercepts = { WM_LBUTTONDOWN   = false,
--         WM_LBUTTONUP     = false,
--         WM_LBUTTONDBLCLK = false,
--         WM_MBUTTONDOWN   = false,
--         WM_MBUTTONUP     = false,
--         WM_MBUTTONDBLCLK = false,
--         WM_RBUTTONDOWN   = false,
--         WM_RBUTTONUP     = false,
--         WM_RBUTTONDBLCLK = false,
--         WM_MOUSEWHEEL    = false,
--         WM_MOUSEHWHEEL   = false,
--         WM_MOUSEMOVE     = false,
--         WM_SETCURSOR     = false,
--         WM_KEYDOWN       = false,
--         WM_KEYUP         = false,
--         WM_SYSKEYDOWN    = false,
--         WM_SYSKEYUP      = false,
--         WM_HOTKEY        = false
--     }

--     reaper.JS_VKeys_Intercept(91, 1)
--     local av = reaper.JS_Window_FindChildByID(reaper.GetMainHwnd(), 1000) -- arangeview
--     for key, value in pairs(tIntercepts) do
--     OK = reaper.JS_WindowMessage_Intercept(av, key, value)
--     -- print(OK)
--     end
--     peekOK, _, time, keys, rotate, x, y = reaper.JS_WindowMessage_Peek(av, "WM_SYSKEYDOWN")
--     if peekOK and time ~= prevTime then
--         print(keys)
--         -- mousewheel has moved since last defer cycle
--     end
--     reaper.defer(main)
-- end

-- function atExit()
--     reaper.JS_WindowMessage_ReleaseAll()
-- end

-- reaper.defer(main)

-- reaper.atexit(atExit)