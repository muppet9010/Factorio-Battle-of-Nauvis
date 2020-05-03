--local Constants = require("constants")
local Shared = require("shared/shared")

data:extend(
    {
        {
            type = "selection-tool",
            name = Shared.tools.unit_selector.prototypeName,
            icon = "__core__/graphics/empty.png",
            icon_size = 1,
            stack_size = 1,
            subgroup = "other",
            order = "a",
            flags = {"mod-openable", "not-stackable", "only-in-cursor"},
            mouse_cursor = "arrow",
            entity_type_filters = {"unit", "car"},
            entity_filter_mode = "whitelist",
            selection_color = {a = 0},
            selection_mode = {"any-entity", "same-force"},
            selection_cursor_box_type = "entity",
            alt_selection_color = {a = 0},
            alt_selection_mode = {"nothing"},
            alt_selection_cursor_box_type = "entity"
        }
    }
)
--[[
    DOESN'T RETURN THE PLAYER WHO DID THE ACTION
data:extend(
    {
        {
            type = "capsule",
            name = Shared.tools.unit_selector.prototypeName,
            icon = "__core__/graphics/empty.png",
            icon_size = 1,
            stack_size = 1,
            subgroup = "other",
            order = "a",
            flags = {"not-stackable", "only-in-cursor"},
            capsule_action = {
                type = "throw",
                uses_stack = false,
                attack_parameters = {
                    type = "projectile",
                    range = 1000000,
                    cooldown = 1,
                    ammo_type = {
                        category = "capsule",
                        target_type = "entity",
                        action = {
                            {
                                type = "direct",
                                force = "same",
                                action_delivery = {
                                    {
                                        type = "instant",
                                        target_effects = {
                                            {
                                                type = "script",
                                                effect_id = Shared.tools.unit_selector.name
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
)
]]
