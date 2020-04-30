local Map = {}
local Utils = require("utility/utils")
--local Events = require("utility/events")
local SetupEvents = require("utility/setup-events")
local Interfaces = require("utility/interfaces")

SetupEvents.RegisterCreateGlobalsHandler(
    "Map",
    function()
        global.map = global.map or {}
        global.map.surface = global.map.surface or game.surfaces[1]
    end
)

SetupEvents.RegisterOnLoadHandler(
    "Map",
    function()
        Utils.DisableSiloScript()
        Interfaces.RegisterInterface("Map.GetSurface", Map.GetSurface)
    end
)

SetupEvents.RegisterOnStartupHandler(
    "Map",
    function()
        Utils.DisableIntroMessage()
        Map.GetSurface().freeze_daytime = true
    end
)

Map.GetSurface = function()
    return global.map.surface
end
