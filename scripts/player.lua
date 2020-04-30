local Player = {}
local Events = require("utility/events")
local SetupEvents = require("utility/setup-events")

SetupEvents.RegisterOnLoadHandler(
    "Player",
    function()
        Events.RegisterEvent(defines.events.on_player_joined_game)
        Events.RegisterHandler(defines.events.on_player_joined_game, "Player.OnPlayerJoined", Player.OnPlayerJoined)
    end
)

Player.OnPlayerJoined = function(event)
    local player = game.get_player(event.player_index)
    Player.SetPlayerOnTeam(player)
end

Player.SetPlayerOnTeam = function(player, team)
    player.set_controller {type = defines.controllers.god}
end

Player.SetPlayerOnSpectate = function(player)
    player.set_controller {type = defines.controllers.spectator}
end

return Player
