local Teams = {}
--local Utils = require("utility/utils")
--local Events = require("utility/events")
local SetupEvents = require("utility/setup-events")
local Interfaces = require("utility/interfaces")

SetupEvents.RegisterCreateGlobalsHandler(
    "Teams",
    function()
        global.teams = global.teams or {}
        global.teams.sides = global.teams.sides or {}
        global.teams.seats = global.teams.seats or {}
    end
)

SetupEvents.RegisterOnLoadHandler(
    "Teams",
    function()
        Interfaces.RegisterInterface("Teams.SetPlayerInSeatId", Teams.SetPlayerInSeatId)
        Interfaces.RegisterInterface("Teams.GetSeatFromSeatId", Teams.GetSeatFromSeatId)
        Interfaces.RegisterInterface("Teams.GetSideFromSideId", Teams.GetSideFromSideId)
        Interfaces.RegisterInterface("Teams.SetPlayerInSideIdWatchers", Teams.SetPlayerInSideIdWatchers)
    end
)

SetupEvents.RegisterOnStartupHandler(
    "Teams",
    function()
        Teams.SetupTeams()
    end
)

Teams.SetupTeams = function()
    Teams.CreateSide(1, true)
    Teams.CreateSeat(1, 1)
    Teams.CreateSide(2, true)
    Teams.CreateSeat(2, 2)
    Teams.CreateSeat(3, 2)
    Teams.CreateSide("spectators", false)
end

Teams.CreateSide = function(sideId, playable)
    global.teams.sides[sideId] = {
        id = sideId,
        name = "Side " .. sideId,
        playable = playable,
        seats = {},
        watchers = {},
        force = nil
    }
    local side = global.teams.sides[sideId]
    if (not playable) then
        side.force = game.create_force(sideId)
    end
end

Teams.GetSideFromSideId = function(sideId)
    return global.teams.sides[sideId]
end

Teams.SetPlayerInSideIdWatchers = function(player, sideId)
    Teams.RemovePlayerFromAnySeatAndSide(player)
    local side = Teams.GetSideFromSideId(sideId)
    table.insert(side.watchers, player)
    return side
end

Teams.CreateSeat = function(seatId, sideId)
    global.teams.seats[seatId] = {
        id = seatId,
        name = "Seat " .. seatId,
        side = global.teams.sides[sideId],
        force = game.create_force(seatId),
        player = nil
    }
    table.insert(global.teams.sides[sideId].seats, global.teams.seats[seatId])
end

Teams.GetSeatFromSeatId = function(seatId)
    return global.teams.seats[seatId]
end

Teams.SetPlayerInSeatId = function(player, seatId)
    Teams.RemovePlayerFromAnySeatAndSide(player)
    local seat = Teams.GetSeatFromSeatId(seatId)
    seat.player = player
    return seat
end

Teams.RemovePlayerFromAnySeatAndSide = function(player)
    for _, side in pairs(global.teams.sides) do
        for k, watcher in pairs(side.watchers) do
            if watcher.index == player.index then
                table.remove(side.watchers, k)
            end
        end
        for k, seat in pairs(side.seats) do
            if seat.player ~= nil and seat.player.index == player.index then
                table.remove(side.seats, k)
            end
        end
    end
end
