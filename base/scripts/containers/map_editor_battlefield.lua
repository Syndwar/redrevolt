class "MapEditorBattlefield" (Battlefield)

function MapEditorBattlefield:init(id, cells_in_row, cells_in_col, cell_width, cell_height)
    self._pos = {32, 32}
    self._offset = {-64, -96}
    self._map_size = {cells_in_row, cells_in_col}
    self._cell_size = {cell_width, cell_height}
    self._default_cursor_geometry = nil
    
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

    local scroll_speed = 500
    self:setScrollSpeed(scroll_speed)

    local screen_width = Engine.getScreenWidth()
    local screen_height = Engine.getScreenHeight()

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

    local cells_in_row, cells_in_col = unpack(self._map_size)
    local cell_width, cell_height = unpack(self._cell_size)
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
    local cell_width, cell_height = unpack(self._cell_size)
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
    local cell_width, cell_height = unpack(self._cell_size)
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
    if (self._default_cursor_geometry and flip) then
        local new_geometry = EntityHandler.flipGeometry(self._default_cursor_geometry, flip[1], flip[2])
        self:__resetCursor(new_geometry)
    end
end

function MapEditorBattlefield:__onEntityRotated(angle)
    if (self._default_cursor_geometry and angle) then
        local new_geometry = EntityHandler.rotateGeometry(self._default_cursor_geometry, angle)
        self:__resetCursor(new_geometry)
    end
end

function MapEditorBattlefield:__onEntityChanged(entity)
    self._default_cursor_geometry = entity and entity:isValid() and entity:geDefaultGeometry()
    local new_geometry = entity and entity:isValid() and entity:getGeometry()
    self:__resetCursor(new_geometry)
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
            local cell_width, cell_height = unpack(self._cell_size)

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