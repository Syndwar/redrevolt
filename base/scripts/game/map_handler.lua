--[[
local MapEntity = {
    id = "",
    pos = {0, 0},
    angle = 0,
    flip = {false, false},
    settings = {},
    inventory = {},
}
]]

local Map = {
    size = {80, 50},
    cell_size = {32, 32},
    content = {},
}

MapHandler = {}

function MapHandler.getContentSize()
    return #Map.content
end

function MapHandler.getEntity(index)
    return Map.content[index]
end

function MapHandler.deleteEntityByIndex(index)
    if (index <= #Map.content) then
        table.remove(Map.content, index)
    end
end

function MapHandler.getEntityIndex(entity)
    for index, value in ipairs(Map.content) do
        if (value == entity) then
            return index
        end
    end
    return 0
end

function MapHandler.addEntity(entity)
    table.insert(Map.content, entity)
end

function MapHandler.resetMap(settings)
    Map = {
        size = settings.size,
        cell_size = settings.cell_size,
        content = {},
    }
end

function MapHandler.hasDuplicateInCell(id, i, j)
    for _, v in ipairs(Map.content) do
        if (v.id == id and v.pos[1] == i and v.pos[2] == j) then
            return true
        end
    end
    return false
end

function MapHandler.getCellSize()
    return unpack(Map.cell_size)
end

function MapHandler.getMapSize()
    return unpack(Map.size)
end

-- returns map copy that can be serialized
function MapHandler.getSaveMap()
    local map = table.deepcopy(Map)
    for i, v in pairs(map.content) do
        v.obj = nil
    end
    return map
end

function MapHandler.getEntitiesInPos(i, j)
    local entities = {}
    for _, v in ipairs(Map.content) do
        if (i == v.pos[1] and j == v.pos[2]) then
            table.insert(entities, v)
        end
    end
    return entities
end

MapEntityHandler = {}

function MapEntityHandler.new(id, left, top, angle, flip, settings)
    local map_content = {
        id = id,
        pos = {left, top},
        angle = angle,
        flip = flip,
        settings = settings or table.deepcopy(GameData.getDefaultSettings(id))
    }
    return map_content
end