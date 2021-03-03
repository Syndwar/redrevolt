MapHandler = {
    _size = {80, 50},
    _cell_size = {32, 32},
    _content = {},
    _obj = nil,
    _entity_creator = nil
}

--[[ Private ]]

function MapHandler.__getMapFilePath(filename)
    return string.format("%s/%s.map", Config.map_folder, filename)
end

function MapHandler:__getContent()
    return self._content
end

-- returns map copy that can be serialized
function MapHandler:__getSaveMap()
    local save_map = {}
    save_map["size"] = {self:getSize()}
    save_map["cell_size"] = {self:getCellSize()}
    save_map["content"] = {}

    local content = self:__getContent()
    for _, entity in ipairs(content) do
        if (entity) then
            local save_data = entity:save()
            table.insert(save_map["content"], save_data)
        end
    end

    return save_map
end

--[[ Public ]]
function MapHandler.new(entity_creator)
    local new_map = table.deepcopy(MapHandler)
    new_map._entity_creator = entity_creator
    return new_map
end

function MapHandler:getSize()
    return self._size[1], self._size[2]
end

function MapHandler:setSize(width, height)
    self._size[1] = width
    self._size[2] = height
end

function MapHandler:getCellSize()
    return self._cell_size[1], self._cell_size[2]
end

function MapHandler:setCellSize(width, height)
    self._cell_size[1] = width
    self._cell_size[2] = height
end

function MapHandler:removeEntity(i, j)
    for index, entity in ipairs(self._content) do
        if (entity:isHit(i, j)) then
            entity:destroy()
            table.remove(self._content, index)
            break
        end
    end
end

function MapHandler:getEntity(i, j)
    for index, entity in ipairs(self._content) do
        if (entity:isHit(i, j)) then
            return entity
        end
    end
    return nil
end

function MapHandler:getPrevEntity(entity)
    local index = 1
    for i, v in ipairs(self._content) do
        if (entity == v) then
            index = i - 1
            if (index < 1) then
                index = #self._content
            end
            break
        end
    end
    return self._content[index]
end

function MapHandler:getNextEntity(entity)
    local index = 1
    for i, v in ipairs(self._content) do
        if (entity == v) then
            index = i + 1
            if (index > #self._content) then
                index = 1
            end
            break
        end
    end
    return self._content[index]
end

function MapHandler:clear()
    for _, entity in ipairs(self._content) do
        if (entity) then
            entity:destroy()
        end
    end
    self._content = {}
    -- collect garbage
    Engine.collectGarbage()
end

function MapHandler:addEntity(entity, i, j)
    local found_duplicate = false -- MapHandler.hasDuplicateInCell(id, i, j) -- check for duplicates
    if (not found_duplicate) then
        local new_entity = entity:copy()
        if (i and j) then
            new_entity:setPos(i, j)
        end
        if (self._entity_creator) then
            local obj = self._entity_creator(new_entity) -- create ui object
            new_entity:setObj(obj) -- link entity with ui object
        end

        table.insert(self._content, new_entity)
    end
end

function MapHandler:load(filename)
    self:clear()

    if (filename) then
        local full_file_path = self.__getMapFilePath(filename)
        local f = io.open(full_file_path, "r")
        -- check if file exists
        if (f) then
            io.close(f)
            -- load map from file
            local saved_map = dofile(full_file_path)

            for _, data in ipairs(saved_map.content) do
                local entity = EntityHandler.load(data)
                self:addEntity(entity)
            end

            log("Map is loaded.")
            Observer:call("ShowNotification", "Map is loaded.")
        end
    end
end

function MapHandler:save(filename)
    if (filename) then
        -- clean up map from cpp entities
        local save_map = self:__getSaveMap()
        -- save map to the file
        local full_file_path = self.__getMapFilePath(filename)
        table.totxt(save_map, full_file_path)
        -- collect garbage
        Engine.collectGarbage()
        log("Map is saved.")
        Observer:call("ShowNotification", "Map is saved.")
    end
end


-- function MapHandler.getEntitiesInPos(i, j)
--     local entities = {}
--     for _, v in ipairs(self._content) do
--         if (i == v.pos[1] and j == v.pos[2]) then
--             table.insert(entities, v)
--         end
--     end
--     return entities
-- end

-- function MapHandler.hasDuplicateInCell(id, i, j)
--     for _, v in ipairs(self._content) do
--         if (v.id == id and v.pos[1] == i and v.pos[2] == j) then
--             return true
--         end
--     end
--     return false
-- end

-- function MapHandler.getContentSize()
--     return #self._content
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