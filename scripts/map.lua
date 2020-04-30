local Map = {}
local Utils = require("utility/utils")
--local Events = require("utility/events")
local SetupEvents = require("utility/setup-events")

SetupEvents.RegisterOnLoadHandler(
    "Map",
    function()
        Utils.DisableSiloScript()
    end
)

SetupEvents.RegisterOnStartupHandler(
    "Map",
    function()
        Utils.DisableIntroMessage()
    end
)

return Map
