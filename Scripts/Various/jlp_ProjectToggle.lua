function Msg(val)
  reaper.ShowConsoleMsg(tostring(val).."\n")
end

 -- Set ToolBar Button ON
function SetButtonON()
  is_new_value, filename, sec, cmd, mode, resolution, val = reaper.get_action_context()
  state = reaper.GetToggleCommandStateEx( sec, cmd )
  reaper.SetToggleCommandState( sec, cmd, 1 ) -- Set ON
  reaper.RefreshToolbar2( sec, cmd )
end

-- Set ToolBar Button OFF
function SetButtonOFF()
  is_new_value, filename, sec, cmd, mode, resolution, val = reaper.get_action_context()
  state = reaper.GetToggleCommandStateEx( sec, cmd )
  reaper.SetToggleCommandState( sec, cmd, 0 ) -- Set OFF
  reaper.RefreshToolbar2( sec, cmd )
end

--get project tab by name
function ProjectTabIndex(FindByName)
  local proj,cnt,ret = "",0,1  
  while ret~=nil do
    ret, proj = reaper.EnumProjects(cnt) 
    if proj == FindByName then return cnt end
    cnt=cnt+1 
  end  
end


--Current Tab Value--

indexCurrentTabValue = nil

function setCurrentTab()
  ret, proj2 = reaper.EnumProjects(-1)
  -- get index of the active tab
  local value = ProjectTabIndex(proj2)
  setCurrentTabValue(value)
end

function setCurrentTabValue(value)
  indexCurrentTabValue = value
end


function getCurrentTabValue()
  return indexCurrentTabValue
end



--Fix Index--
fixIndex = 0
function setFixIndex(value)
  fixIndex = value
end
function getFixIndex()
  return fixIndex
end



--Main fonction : check the tab and toggle the button accordingly--
function main()
  local fixIndex = getFixIndex()
  setCurrentTab()
  indexCurrentTab = getCurrentTabValue()
  if indexCurrentTab == fixIndex then
  SetButtonON()
  else
  SetButtonOFF()
  end
  reaper.defer(main)
end

--When not on selected tab--


------------SCRIPT BODY----------
ret, proj = reaper.EnumProjects(-1)
index = ProjectTabIndex(proj)
setFixIndex(index)

---Focus On current tab windows when re-run---
--indexToMatch = getCurrentTabValue()

--if indexToMatch ~= nil then
  --if index ~= indexToMatch then
   -- index = indexToMatch 
  --end
--end

setFixIndex(index)

main()

reaper.atexit( SetButtonOFF )
