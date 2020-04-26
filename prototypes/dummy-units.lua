--local Constants = require("constants")
local Shared = require("shared/shared")
local Utils = require("utility/utils")

local tankEntity = data.raw["car"]["tank"]
local sharedUnitDummyTank = Shared.units.dummy_tank
local dummyTank = Utils.DeepCopy(tankEntity)
dummyTank.name = sharedUnitDummyTank.name
dummyTank.order = sharedUnitDummyTank.race.name .. "_" .. sharedUnitDummyTank.name

data:extend({dummyTank})
