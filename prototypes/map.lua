for _, tile in pairs(data.raw["tile"]) do
    tile.autoplace = nil
end
data.raw.tile["out-of-map"].autoplace = {} --needs to have an autoplace to stop the game defaults being applied to vanilla tiles.
