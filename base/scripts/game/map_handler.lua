MapHandler = {
    _size = {80, 50},
    _cell_size = {32, 32},
    _content = {},
}

function MapHandler.new(size, cell_size)
    local map_tbl = table.deepcopy(MapHandler)
    if (size) then
    if (cell_size) then
        map_tbl._size[1] = size[1]
        map_tbl._size[2] = size[2]
    end
    end
    if (cell_size) then
        map_tbl._cell_size[1] = cell_size[1]
        map_tbl._cell_size[2] = cell_size[2]
    end
    return map_tbl
end

function MapHandler:getSize()
    return self._size[1], self._size[2]
end

function MapHandler:getCellSize()
    return self._cell_size[1], self._cell_size[2]
end

-- function MapHandler.getContentSize()
--     return #self._content
-- end

-- function MapHandler.getEntity(index)
--     return self._content[index]
-- end

-- function MapHandler.deleteEntityByIndex(index)
--     if (index <= #self._content) then
--         table.remove(self._content, index)
--     end
-- end

-- function MapHandler.getEntityIndex(entity)
--     for index, value in ipairs(self._content) do
--         if (value == entity) then
--             return index
--         end
--     end
--     return 0
-- end

function MapHandler:addEntity(entity)
    table.insert(self._content, entity)
end

-- function MapHandler.resetMap(settings)
--     Map = {
--         size = settings.size,
--         cell_size = settings.cell_size,
--         content = {},
--     }
-- end

-- function MapHandler.hasDuplicateInCell(id, i, j)
--     for _, v in ipairs(self._content) do
--         if (v.id == id and v.pos[1] == i and v.pos[2] == j) then
--             return true
--         end
--     end
--     return false
-- end

-- -- returns map copy that can be serialized
-- function MapHandler.getSaveMap()
--     local map = table.deepcopy(Map)
--     for i, v in pairs(self._content) do
--         v.obj = nil
--     end
--     return map
-- end

-- function MapHandler.getEntitiesInPos(i, j)
--     local entities = {}
--     for _, v in ipairs(self._content) do
--         if (i == v.pos[1] and j == v.pos[2]) then
--             table.insert(entities, v)
--         end
--     end
--     return entities
-- end