class "MapEditorBattlefield" (Battlefield)

function MapEditorBattlefield:init(id)
    local default_map_size = {80, 50}
    local default_cell_size = {32, 32}

    self._pos = {32, 32}
    self._offset = {-64, -96}

    self._layers = {}

    local function entity_creator(entity)
        return self:__createEntityOnField(entity)
    end

    self._map = MapHandler.new(entity_creator)
    self._map:setSize(unpack(default_map_size))
    self._map:setCellSize(unpack(default_cell_size))
    
    Observer:addListener("SwitchGrid", self, self.__switchGrid)
    Observer:addListener("EntityChanged", self, self.__changeEntity)
    Observer:addListener("EntityRotated", self, self.__rotateEntity)
    Observer:addListener("EntityFlipped", self, self.__flipEntity)
    Observer:addListener("EntityOrderChanged", self, self.__changeEntityOrder)
    Observer:addListener("NextEntity", self, self.__goToNextEntity)
    Observer:addListener("PrevEntity", self, self.__goToPrevEntity)
    Observer:addListener("UpdateEntity", self, self.__updateEntity)
    Observer:addListener("EditEntity", self, self.__editEntity)
    Observer:addListener("EditInventory", self, self.__editInventory)
    Observer:addListener("UpdateInventory", self, self.__updateInventory)
    Observer:addListener("SwitchLayer", self, self.__switchLayer)
    
    self:addCallback("KeyUp_" .. HotKeys.Grid, self.__switchGrid, self)
    self:addCallback("MouseMove", self.__onMouseMove, self)
    self:addCallback("KeyDown_" .. HotKeys.ScrollUp,    self.__scrollToDirection, {self, "Up", true})
    self:addCallback("KeyDown_" .. HotKeys.ScrollLeft,  self.__scrollToDirection, {self, "Left", true})
    self:addCallback("KeyDown_" .. HotKeys.ScrollRight, self.__scrollToDirection, {self, "Right", true})
    self:addCallback("KeyDown_" .. HotKeys.ScrollDown,  self.__scrollToDirection, {self, "Down", true})
    self:addCallback("KeyUp_" .. HotKeys.ScrollUp,      self.__scrollToDirection, {self, "Up", false})
    self:addCallback("KeyUp_" .. HotKeys.ScrollLeft,    self.__scrollToDirection, {self, "Left", false})
    self:addCallback("KeyUp_" .. HotKeys.ScrollRight,   self.__scrollToDirection, {self, "Right", false})
    self:addCallback("KeyUp_" .. HotKeys.ScrollDown,    self.__scrollToDirection, {self, "Down", false})
    self:addCallback("MouseDown_Left", self.__onFieldLeftClicked, self)
    self:addCallback("MouseDown_Right", self.__onFieldRightClicked, self)
    self:addCallback("MouseDown_Middle", self.__onFieldMiddleClicked, self)

    local scroll_speed = 500
    self:setScrollSpeed(scroll_speed)
    self:__createMapContent()
end

--[[ Private ]]

function MapEditorBattlefield:__createLayer(index)
    local cnt = Container()
    self:setOrder(index)
    self:attach(cnt)

    self._layers[index] = cnt
end

function MapEditorBattlefield:__getLayer(index)
    local layer = self._layers[index]
    if (not layer) then
        self:__createLayer(index)
        layer = self._layers[index]
    end
    return layer
end

function MapEditorBattlefield:__createMapContent()
    local screen_width = Engine.getScreenWidth()
    local screen_height = Engine.getScreenHeight()
    local cells_in_row, cells_in_col = self._map:getSize()
    local cell_width, cell_height = self._map:getCellSize()

    local map_width = cells_in_row * cell_width
    local map_height = cells_in_col * cell_height

    self:setRect(0, 0, screen_width + self._offset[1], screen_height + self._offset[2])
    self:setContentRect(0, 0, map_width, map_height)

    self:moveBy(unpack(self._pos))
end

function MapEditorBattlefield:__calculateCell(x, y)
    local cell_width, cell_height = self._map:getCellSize()
    local i = math.floor(x / cell_width) + 1
    local j = math.floor(y / cell_height) + 1
    return i, j
end

function MapEditorBattlefield:__calculateFieldPos(i, j)
    local left, top, _, _ = self:getRect()
    local cell_width, cell_height = self._map:getCellSize()
    local x = left + (i - 1) * cell_width
    local y = top + (j - 1) * cell_height
    return x, y
end

function MapEditorBattlefield:__getCellPosForCursor()
    local i, j = self:__getMouseTargetedCell()
    return self:__calculateFieldPos(i, j)
end

function MapEditorBattlefield:__onMouseMove()
    local cursor = self:getUI("cursor")
    local is_opened = cursor and cursor:isOpened()
    if (is_opened) then
        local field_x, field_y = self:__getCellPosForCursor()
        cursor:moveTo(field_x, field_y)
    end
end

function MapEditorBattlefield.__scrollToDirection(params)
    local self = params[1]
    if (self) then
        local direction = params[2]
        local value = params[3]
        self:enableScroll(direction, value)
    end
end

function MapEditorBattlefield:__changeEntityOrder(order)
    -- TODO
end

function MapEditorBattlefield:__flipEntity(flip)
    local entity = self:getSelectedEntity()
    if (entity and flip) then
        entity:setFlip(flip[1], flip[2])
        self:__resetCursor(entity:getGeometry())
    end
end

function MapEditorBattlefield:__rotateEntity(angle)
    local entity = self:getSelectedEntity()
    if (entity and angle) then
        entity:setAngle(angle)
        self:__resetCursor(entity:getGeometry())
    end
end

function MapEditorBattlefield:__changeEntity(entity)
    -- saves new entity
    self._map:selectEntity(entity)

    local geometry = nil
    if (entity and not entity:isValid()) then
        geometry = entity:getGeometry()
    end
    self:__resetCursor(geometry)
end

function MapEditorBattlefield:__resetCursor(geometry)
    local cursor = self:getUI("cursor")
    if (cursor) then
        local show = nil ~= geometry
        local is_opened = cursor:isOpened()
        if (geometry and not is_opened) then
            cursor:instantView(true)
        elseif (not show and is_opened) then
            cursor:instantView(false)
        end

        if (show) then
            local field_x, field_y = self:__getCellPosForCursor()
            local cell_width, cell_height = self._map:getCellSize()

            local rects = {}
            for row_index, row in ipairs(geometry) do
                for col_index, value in ipairs(row) do
                    if (0 ~= value) then
                        local cell_top = field_x + (col_index - 1) * cell_width
                        local cell_left = field_y + (row_index - 1) * cell_height
                        local rect = {cell_top, cell_left, cell_width, cell_height}
                        table.insert(rects, rect)
                    end
                end
            end
            cursor:reset(rects, false)
        end
    end
end

function MapEditorBattlefield:__getMouseTargetedCell()
    local x, y = Engine.getMousePos()
    local sx, sy = self:screenToScrollPos(x, y)
    local bx, by, _, _ = self:getRect()
    return self:__calculateCell(sx - bx, sy - by)
end

function MapEditorBattlefield:__onFieldLeftClicked()
    local entity = self:getSelectedEntity()
    if (entity) then
        if (self._map and not entity:isValid()) then
            local i, j = self:__getMouseTargetedCell()
            self._map:addEntity(entity, i, j) -- add it to the map
        end
    else
        local i, j = self:__getMouseTargetedCell()
        local entities = self._map:getEntities(i, j) -- get entities from the map
        if (#entities > 1) then
            Observer:call("ShowSelectionPanel", entities)
        elseif (#entities == 1) then
            Observer:call("EntityChanged", entities[1])
        end
    end
end

function MapEditorBattlefield:__createEntityOnField(entity)
    if (not entity) then return nil end

    local pos = entity:getPos()
    local x, y = self:__calculateFieldPos(pos[1], pos[2])
    local size = entity:getSize()
    local angle = entity:getAngle()
    local img = Image()
    img:setSprite(entity:getSprite())
    img:ignoreMouse(true)
    img:setRect(x, y, size[1], size[2])
    img:setCenter(entity:getHotSpot())
    img:setAngle(angle)
    img:setFlip(unpack(entity:getFlip()))
    img:setOrder(entity:getLayer())

    local layer = self:__getLayer(entity:getLayer())
    layer:attach(img)
    return img
end

function MapEditorBattlefield:__onFieldRightClicked()
    if (self._map and self._map:isEntitySelected()) then
        Observer:call("EntityChanged", nil)
    else
        if (self._map) then
            local i, j = self:__getMouseTargetedCell()
            self._map:removeEntity(i, j) -- remote it from the map
        end
    end
end

function MapEditorBattlefield:__onFieldMiddleClicked()
    local i, j = self:__getMouseTargetedCell()
    local entity = self._map:getEntity(i, j) -- get an item from the map
    if (entity) then
        local new_entity = entity:copy()
        Observer:call("EntityChanged", new_entity)
    end
end

function MapEditorBattlefield:__goToPrevEntity()
    if (not self._map) then return end

    local entity = self._map:getPrevEntity()
    
    Observer:call("EntityChanged", entity)

    if (entity) then
        local pos = entity:getPos()
        self:jumpToCell(pos[1], pos[2])
    end
end

function MapEditorBattlefield:__goToNextEntity()
    if (not self._map) then return end

    local entity = self._map:getNextEntity()
    
    Observer:call("EntityChanged", entity)

    if (entity) then
        local pos = entity:getPos()
        self:jumpToCell(pos[1], pos[2])
    end
end

function MapEditorBattlefield:__updateEntity(params)
    local selected_entity = self:getSelectedEntity()
    if (selected_entity and selected_entity:isValid()) then
        if (params) then
            selected_entity:setEditParams(params)
            Observer:call("EntityChanged", selected_entity)
        end
    end
end

function MapEditorBattlefield:__editEntity()
    local selected_entity = self:getSelectedEntity()
    if (selected_entity and selected_entity:isValid()) then
        local params = selected_entity:getEditParams()
        Observer:call("ShowEditDialog", params)
    end
end

function MapEditorBattlefield:__getGroundContent()
    if (self._map) then
        return self._map:getSelectedEntities(true)
    end
    return {}
end

function MapEditorBattlefield:__editInventory()
    local selected_entity = self:getSelectedEntity()
    if (selected_entity and selected_entity:isValid() and selected_entity:hasInventory()) then
        local content = {
            ["inventory"] = selected_entity:getInventory(),
            ["ground"] = self:__getGroundContent(),
        }
        Observer:call("ShowInventoryDialog", content)
    end
end

function MapEditorBattlefield:__updateInventory(content)
end

function MapEditorBattlefield:__switchLayer()
    local all_opened = true
    local opened_index = 0
    for i, layer in ipairs(self._layers) do
        local is_opened = layer:isOpened()
        if (is_opened) then
            opened_index = i
        else
            all_opened = false
        end
    end

    if (all_opened) then
        all_opened = false
        opened_index = 1
    else
        opened_index = opened_index + 1
    end


    if (opened_index > #self._layers) then
        all_opened = true
    end

    log(opened_index, all_opened)

    for i, layer in ipairs(self._layers) do
        layer:instantView(all_opened or i == opened_index)
    end
end
--[[ Public ]]

function MapEditorBattlefield:loadMap(filename)
    if (self._map) then
        Observer:call("EntityChanged", nil)
        local result = self._map:load(filename)
        if (result) then
            log("Map is loaded.")
            Observer:call("ShowNotification", "Map is loaded.")
        end
    end
end

function MapEditorBattlefield:saveMap(filename)
    if (self._map) then
        Observer:call("EntityChanged", nil)
        local result = self._map:save(filename)
        if (result) then
            log("Map is saved.")
            Observer:call("ShowNotification", "Map is saved.")
        end
    end
end

function MapEditorBattlefield:clear()
    if (self._map) then
        Observer:call("EntityChanged", nil)
        self._map:clear()
    end
end

function MapEditorBattlefield:jumpToCell(i, j)
    local x, y = self:__calculateFieldPos(i, j)
    
    local screen_width = Engine.getScreenWidth()
    local screen_height = Engine.getScreenHeight()
    x = x - screen_width / 2
    y = y - screen_height / 2
    self:jumpTo(x, y)
end

function MapEditorBattlefield:getSelectedEntity()
    return self._map and self._map:getSelectedEntity()
end
