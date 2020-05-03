local Constants = require("constants")

local function AddRace(sharedData, race)
    sharedData.races[race.name] = race
    for _, unit in pairs(race.units) do
        sharedData.units[unit.name] = {
            name = unit.name,
            prototypeName = Constants.ModName .. "-" .. unit.name,
            race = sharedData.races[race.name]
        }
    end
end

local sharedData = {races = {}, units = {}}
AddRace(sharedData, require("shared/dummy-race"))

sharedData.tools = {
    unit_selector = {name = "unit_selector", prototypeName = Constants.ModName .. "-" .. "unit_selector"}
}

return sharedData
