local function AddRace(sharedData, race)
    sharedData.races[race.name] = race
    for _, unit in pairs(race.units) do
        sharedData.units[unit.name] = {
            name = unit.name,
            race = sharedData.races[race.name]
        }
    end
end

local sharedData = {races = {}, units = {}}
AddRace(sharedData, require("shared/dummy-race"))

return sharedData
