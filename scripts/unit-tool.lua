local UnitTool = {}
--local Utils = require("utility/utils")
local Events = require("utility/events")
local SetupEvents = require("utility/setup-events")
local Interfaces = require("utility/interfaces")
local Shared = require("shared/shared")
local Colors = require("utility/colors")

SetupEvents.RegisterCreateGlobalsHandler(
    "UnitTool",
    function()
        global.unitTool = global.unitTool or {}
        global.unitTool.playersWithUnitTool = global.unitTool.playersWithUnitTool or {}
    end
)

SetupEvents.RegisterOnLoadHandler(
    "UnitTool",
    function()
        --[[
            NOTES ON PROTOTYPE
        Events.RegisterEvent(defines.events.on_script_trigger_effect)
        Events.RegisterHandler(defines.events.on_script_trigger_effect, "UnitTool", function(event)
            local x = event
        end)
        ]]
        Events.RegisterHandler(defines.events.on_player_selected_area, "UnitTool.OnPlayerSelectedAreaEvent", UnitTool.OnPlayerSelectedAreaEvent)
        Interfaces.RegisterInterface("UnitTool.SetAsPlayerCursor", UnitTool.SetAsPlayerCursor)
        Interfaces.RegisterInterface("UnitTool.RemoveAsPlayerCursor", UnitTool.RemoveAsPlayerCursor)
        Events.RegisterHandler(defines.events.on_player_cursor_stack_changed, "UnitTool.OnPlayerCursorStackChanged", UnitTool.OnPlayerCursorStackChanged)
    end
)

SetupEvents.RegisterOnStartupHandler(
    "UnitTool",
    function()
    end
)

UnitTool.OnPlayerSelectedAreaEvent = function(event)
    -- No way to stop the player from selecting multiple entries with the drag. The graphics on the user side give no indiciation that you are able to make a drag selection, apart from the entity selection box highlight that I can't turn off.
    -- Can't use the area selected instead as no way to know if left_top or right_bottom or the other 2 corners was where the mouse was pressed initially.
    if event.item ~= Shared.tools.unit_selector.prototypeName or #event.entities == 0 then
        return
    end
    local player = game.get_player(event.player_index)
    if #event.entities > 1 then
        return player.print("WARNING: don't drag to select units, only one unit can be selected at a time", Colors.Red)
    end
    local selectedEntity = event.entities[1]

    game.print(event.tick .. ": " .. selectedEntity.name)
end

UnitTool.SetAsPlayerCursor = function(player)
    UnitTool.RecordPlayerCursorMonitoring(player.index, true)
    player.cursor_stack.set_stack({name = Shared.tools.unit_selector.prototypeName})
end

UnitTool.RemoveAsPlayerCursor = function(player)
    UnitTool.RecordPlayerCursorMonitoring(player.index, false)
    player.clean_cursor()
end

UnitTool.RecordPlayerCursorMonitoring = function(player_index, active)
    global.unitTool.playersWithUnitTool[player_index] = active
end

UnitTool.IsPlayerCursorMonitored = function(player_index)
    return global.unitTool.playersWithUnitTool[player_index] == true
end

UnitTool.OnPlayerCursorStackChanged = function(event)
    --This function triggers itself when it sets the players cursor item, so have to handle this and not get stuck in infinite loop.
    if not UnitTool.IsPlayerCursorMonitored(event.player_index) then
        return
    end
    local player = game.get_player(event.player_index)
    if not player.cursor_stack.valid then
        return game.print("ERROR: player cursor stack not valid", Colors.Red)
    end
    local setCursor = false
    if not player.cursor_stack.valid_for_read then
        setCursor = true
    elseif player.cursor_stack.name ~= Shared.tools.unit_selector.prototypeName then
        setCursor = true
    end
    if setCursor then
        player.cursor_stack.set_stack({name = Shared.tools.unit_selector.prototypeName})
    end
end

return UnitTool
