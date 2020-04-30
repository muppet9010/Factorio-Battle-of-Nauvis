local Testing = {}
local Utils = require("utility/utils")
local Events = require("utility/events")
local SetupEvents = require("utility/setup-events")
local Shared = require("shared/shared")
local Interfaces = require("utility/interfaces")

SetupEvents.RegisterOnLoadHandler(
    "Testing",
    function()
        Utils.DisableSiloScript()
        Events.RegisterEvent(defines.events.on_chunk_generated)
        Events.RegisterHandler(defines.events.on_chunk_generated, "Testing.MakeTestMapOnChunkGenerated", Testing.MakeTestMapOnChunkGenerated)
        Events.RegisterEvent(defines.events.on_player_joined_game)
        Events.RegisterHandler(defines.events.on_player_joined_game, "Testing.SetPlayerInSeat1", Testing.SetPlayerInSeat1)
    end
)

SetupEvents.RegisterOnStartupHandler(
    "Testing",
    function()
        local surface = Interfaces.Call("Map.GetSurface")
        Testing.PlaceDummyUnits(surface)
    end
)

Testing.MakeTestMapOnChunkGenerated = function(event)
    local surface = Interfaces.Call("Map.GetSurface")
    if event.surface ~= surface or not (event.position.x == 0 or event.position.x == -1) or not (event.position.y == 0 or event.position.y == -1) then
        return
    end
    local tiles = {}
    for x = event.area.left_top.x, event.area.right_bottom.x do
        for y = event.area.left_top.y, event.area.right_bottom.y do
            table.insert(tiles, {name = "grass-1", position = {x, y}})
        end
    end
    surface.set_tiles(tiles)
end

Testing.PlaceDummyUnits = function(surface)
    local force = Interfaces.Call("Teams.GetSeatFromSeatId", 1).force
    Testing.PlaceUnit(surface, Shared.units.dummy_tank.name, {0, 0}, force)
end

Testing.PlaceUnit = function(surface, unitName, position, force)
    local unit = surface.create_entity {name = unitName, position = position, force = force}
    unit.operable = false
    unit.rotatable = false
    unit.destructible = false
end

Testing.SetPlayerInSeat1 = function(event)
    local player = game.get_player(event.player_index)
    Interfaces.Call("Player.PutPlayerInSeatId", player, 1)
end
