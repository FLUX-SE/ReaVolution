--Script Name : testLib.lua
--Author : Jean Loup Pecquais
--Description : Master ReaVolution library file
--v1.0.0


local args = {...}

-- If the library is inadvertently loaded from multiple files, just add any
-- additional options and skip everything else
if reaEvolution then
  if args and args[1] then
    for k, v in pairs(args) do
      if v then reaEvolution.args[k] = true end
    end
  end

  return
end

reaEvolution = {}
reaEvolution.args = args and args[1] or {}

reaEvolution.libPath = reaper.GetExtState("Reaper Evolution", "libPath")
if not reaEvolution.libPath or reaEvolution.libPath == "" then
    reaper.MB("Couldn't find the Reaper Evolution library. Please run '...' in your Action List.", "Error", 0) -- luacheck: ignore 631
    return
end

reaEvolution.libRoot = reaEvolution.libPath:match("(.*[/\\])".."[^/\\]+[/\\]")

function addPaths()
  local paths = {
    reaEvolution.libPath:match("(.*[/\\])")
  }

  if reaEvolution.args.dev then
    paths[#paths + 1] = reaEvolution.libRoot .. "development/"
    paths[#paths + 1] = reaEvolution.libRoot .. "deployment/"
  end

  for i, path in pairs(paths) do
    paths[i] = ";" .. path .. "?.lua"
  end

  package.path = package.path .. table.concat(paths, "")
end
addPaths()


reaEvolution.hasSWS = reaper.APIExists("CF_GetClipboardBig")

--------------
--Dependence--
--------------

require("tagSystemLib")
require("toolLib")
require("spatRevolutionLib")
require("trackRelatedLib")
require("itemRelatedLib")
require("ddpLib")
require("trackChunkLib")
require("envelopLib")
require("arrangeViewLib")
require("projectLib")
require("markerLib")
require("automationLib")

-----------------------
--Third-Party Library--
-----------------------

json = require("json")

-- reaEvolution.libPath = reaEvolution.libPath.."socketlib\\"
-- reaEvolution.libRoot = reaEvolution.libPath:match("(.*[/\\])".."[^/\\]+[/\\]")
-- reaper.SetExtState("Reaper Evolution", "socketlib", reaEvolution.libPath, true)
-- -- reaper.MB(reaEvolution.libPath, "Info", 0)
-- addPaths()
-- socket = require("lua.socket")

---------------
--GUI Library--
---------------

