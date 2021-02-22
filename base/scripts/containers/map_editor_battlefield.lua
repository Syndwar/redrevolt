class "MapEditorBattlefield" (Battlefield)

function MapEditorBattlefield:init(id)
    self._pos = {32, 32}
    self._offset = {-64, -96}
    self._map = nil
    self._selected_entity = nil
    
    Observer:addListener("SwitchGrid", self, self.__onGridSwitched)
    Observer:addListener("EntityChanged", self, self.__onEntityChanged)
    Observer:addListener("EntityRotated", self, self.__onEntityRotated)
    Observer:addListener("EntityFlipped", self, self.__onEntityFlipped)
    
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

function MapEditorBattlefield:__createMapContent()
    self._map = MapHandler.new()

    local screen_width = Engine.getScreenWidth()
    local screen_height = Engine.getScreenHeight()
    local cells_in_row, cells_in_col = self._map:getSize()
    local cell_width, cell_height = self._map:getCellSize()

    local map_width = cells_in_row * cell_width
    local map_height = cells_in_col * cell_height

    self:setRect(0, 0, screen_width + self._offset[1], screen_height + self._offset[2])
    self:setContentRect(0, 0, map_width, map_height)

    local grid = Primitive("fieldGrid")
    grid:setColour("green")
    grid:createLines(self:__createGridLines())
    self:attach(grid)
    self:setUI("fieldGrid", grid)

    local cursor = Primitive("cursorRect")
    cursor:setColour("yellow")
    cursor:createRects({{0, 0, cell_width, cell_height}}, false)
    cursor:instantView(false)
    self:attach(cursor)
    self:setUI("cursor", cursor)

    self:moveBy(unpack(self._pos))
end

function MapEditorBattlefield:__createGridLines()
    local grid_lines = {}

    local cells_in_row, cells_in_col = self._map:getSize()
    local cell_width, cell_height = self._map:getCellSize()
    local map_width = cells_in_row * cell_width
    local map_height = cells_in_col * cell_height

    local row = 0
    local w = 0
    local down = true
    while (w <= map_width) do
        if (down) then
            table.insert(grid_lines, {w, 0})
            table.insert(grid_lines, {w, map_height})
        else
            table.insert(grid_lines, {w, map_height})
            table.insert(grid_lines, {w, 0})
        end
        row = row + 1
        w = row * cell_width
        down = not down
    end

    local column = 0
    local h = 0
    local left = false
    while (h <= map_height) do
        if (left) then
            table.insert(grid_lines, {0, h})
            table.insert(grid_lines, {map_width, h})
        else
            table.insert(grid_lines, {map_width, h})
            table.insert(grid_lines, {0, h})
        end
        column = column + 1
        h = column * cell_height
        left = not left
    end
    return grid_lines
end

function MapEditorBattlefield:__calculateCell(x, y)
    local cell_width, cell_height = self._map:getCellSize()
    local i = math.floor(x / cell_width) + 1
    local j = math.floor(y / cell_height) + 1
    return i, j
end

function MapEditorBattlefield:__onGridSwitched()
    local grid = self:getUI("fieldGrid")
    if (grid) then
        grid:view(not grid:isOpened())
    end
end

function MapEditorBattlefield:__calculateFieldPos(i, j)
    local left, top, _, _ = self:getRect()
    local cell_width, cell_height = self._map:getCellSize()
    local x = left + (i - 1) * cell_width
    local y = top + (j - 1) * cell_height
    return x, y
end

function MapEditorBattlefield:__getCellPosForCursor()
    local x, y = Engine.getMousePos()
    local sx, sy = self:screenToScrollPos(x, y)
    local bx, by, _, _ = self:getRect()
    local i, j = self:__calculateCell(sx - bx, sy - by)
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

function MapEditorBattlefield:__onEntityFlipped(flip)
    if (self._selected_entity and flip) then
        self._selected_entity:setFlip(flip[1], flip[2])
        self:__resetCursor(self._selected_entity:getGeometry())
    end
end

function MapEditorBattlefield:__onEntityRotated(angle)
    if (self._selected_entity and angle) then
        self._selected_entity:setAngle(angle)
        self:__resetCursor(self._selected_entity:getGeometry())
    end
end

function MapEditorBattlefield:__onEntityChanged(entity)
    -- saves new entity
    self._selected_entity = entity
    self:__resetCursor(entity and self._selected_entity:getGeometry())
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

function MapEditorBattlefield:__onFieldLeftClicked()
    if (self._selected_entity) then
        local x, y = Engine.getMousePos()
        local sx, sy = self:screenToScrollPos(x, y)
        local bx, by, _, _ = self:getRect()
        local i, j = self:__calculateCell(sx - bx, sy - by)

        -- local found_duplicate = MapHandler.hasDuplicateInCell(id, i, j) -- check for duplicates
        -- if (not found_duplicate) then
            local entity = self._selected_entity:copy()
            entity:setPos(i, j)
            local obj = self:__createEntityOnField(entity)
            -- entity.obj = self:createEntity(entity) -- create entity
            self._map:addEntity(entity) -- add it to the map
        -- end

    else
--         local index = self:findEntityOnClick()
--         if (index > 0) then
--             self:selectItem(index)
--         end
    end
end

function MapEditorBattlefield:__createEntityOnField(entity)
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
    self:attach(img)
    return img
end

function MapEditorBattlefield:__onFieldRightClicked()
    if (self._selected_entity) then
        Observer:call("EntityChanged", nil)
    else
        -- local index, entity = self:findEntityOnClick()
        -- self:onEntityDelete(index, entity)
    end
end

function MapEditorBattlefield:__onFieldMiddleClicked()
--     local x, y = Engine.getMousePos()
--     local sx, sy = self.battlefield:screenToScrollPos(x, y)
--     local bx, by, _, _ = self.battlefield:getRect()
--     local i, j = __calculateCell(sx - bx, sy - by)

--     for index = MapHandler.getContentSize(), 1, -1 do
--         local entity = MapHandler.getEntity(index)
--         if (entity) then
--             local obj_data = GameData.find(entity.id)
--             local geometry = GameData.getGeometry(obj_data, entity.angle, entity.flip)
--             for k, row in ipairs(geometry) do
--                 for l, value in ipairs(row) do
--                     if (1 == value) then
--                         local obj_part_x = entity.pos[1] + (l - 1)
--                         local obj_part_y = entity.pos[2] + (k - 1)
--                         if (obj_part_x == i and obj_part_y == j) then
--                             self:__onEntityChanged(entity.id, entity.angle, entity.flip)
--                             break
--                         end
--                     end
--                 end
--             end
--         end
--     end
end

function MapEditorBattlefield:loadMap(filename)
--     if (file_name) then
--         local full_file_path = self:getMapFilePath(file_name)
--         local f = io.open(full_file_path, "r")
--         -- check if file exists
--         if (f) then
--             io.close(f)
--             -- clear current map
--             self:clearMap()
--             -- load map from file
--             local settings = dofile(full_file_path)
--             -- remember new map
--             MapHandler.resetMap(settings)

--             for _, data in ipairs(settings.content) do
--                 local entity = EntityHandler.new(data.id)
--                 entity:setPos(data.pos[1], data.pos[2])
--                 entity:setAngle(data.angle)
--                 entity:setFlip(data.flip[1], data.flip[2])
--                 entity:setSettings(data.settings)
--                 entity.obj = self:createEntity(entity)
--                 MapHandler.addEntity(entity)
--             end

--             self.current_map_file = file_name
--             log("Map is loaded.")
--             self.notification_dlg:setMessage("Map is loaded.")
--             self.notification_dlg:view(true)
--         end
--     end
end