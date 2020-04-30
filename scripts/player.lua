local Player = {}
local Events = require("utility/events")
local SetupEvents = require("utility/setup-events")
local Interfaces = require("utility/interfaces")

SetupEvents.RegisterCreateGlobalsHandler(
    "Player",
    function()
    end
)

SetupEvents.RegisterOnLoadHandler(
    "Player",
    function()
        Events.RegisterEvent(defines.events.on_player_joined_game)
        Events.RegisterHandler(defines.events.on_player_joined_game, "Player.OnPlayerJoined", Player.OnPlayerJoined)
        Interfaces.RegisterInterface("Player.PutPlayerInSeatId", Player.PutPlayerInSeatId)
    end
)

Player.OnPlayerJoined = function(event)
    local player = game.get_player(event.player_index)
    player.minimap_enabled = false
    local playersCharacter = player.character
    if playersCharacter ~= nil then
        player.disassociate_character(playersCharacter)
        playersCharacter.destroy()
    end
    Player.PutPlayerOnSpectatorsSide(player)
end

Player.PutPlayerInSeatId = function(player, seatId)
    player.set_controller {type = defines.controllers.god}
    local seat = Interfaces.Call("Teams.SetPlayerInSeatId", player, seatId)
    player.force = seat.force
end

Player.PutPlayerOnSpectatorsSide = function(player)
    player.set_controller {type = defines.controllers.spectator}
    local side = Interfaces.Call("Teams.SetPlayerInSideIdWatchers", player, "spectators")
    player.force = side.force
end
