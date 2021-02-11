class "MapEditorBattlefield" (Battlefield)

function MapEditorBattlefield:init()
    self._pos = {32, 32}
    self._offset = {-64, -96}
    self._cell_size = {0, 0}
    self._map_size = {0, 0}
    
    Observer:addListener("SwitchGrid", self, self.onGridSwitched)
    
    self:addCallback("MouseMove", self.onMouseMove, self)
    self:addCallback("KeyDown_" .. HotKeys.ScrollUp,    self.scrollToDirection, {self, "Up", true})
    self:addCallback("KeyDown_" .. HotKeys.ScrollLeft,  self.scrollToDirection, {self, "Left", true})
    self:addCallback("KeyDown_" .. HotKeys.ScrollRight, self.scrollToDirection, {self, "Right", true})
    self:addCallback("KeyDown_" .. HotKeys.ScrollDown,  self.scrollToDirection, {self, "Down", true})
    self:addCallback("KeyUp_" .. HotKeys.ScrollUp,      self.scrollToDirection, {self, "Up", false})
    self:addCallback("KeyUp_" .. HotKeys.ScrollLeft,    self.scrollToDirection, {self, "Left", false})
    self:addCallback("KeyUp_" .. HotKeys.ScrollRight,   self.scrollToDirection, {self, "Right", false})
    self:addCallback("KeyUp_" .. HotKeys.ScrollDown,    self.scrollToDirection, {self, "Down", false})


    self:setScrollSpeed(500)
end

function MapEditorBattlefield:setMapSize(i, j)
    self._map_size[1] = i
    self._map_size[2] = j
end

function MapEditorBattlefield:setCellSize(width, height)
    self._cell_size[1] = width
    self._cell_size[2] = height
end

function MapEditorBattlefield:createGridLines()
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

function MapEditorBattlefield:update()
    local screen_width = Engine.getScreenWidth()
    local screen_height = Engine.getScreenHeight()
    local cell_width, cell_height = unpack(self._cell_size)

    local map_width = self._map_size[1] * cell_width
    local map_height = self._map_size[2] * cell_height

    self:setRect(0, 0, screen_width + self._offset[1], screen_height + self._offset[2])
    self:setContentRect(0, 0, map_width, map_height)

    local grid = Primitive("fieldGrid")
    grid:setColour("green")
    grid:createLines(self:createGridLines())
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

function MapEditorBattlefield:calculateCell(x, y)
    local cell_width, cell_height = unpack(self._cell_size)
    local i = math.floor(x / cell_width) + 1
    local j = math.floor(y / cell_height) + 1
    return i, j
end

function MapEditorBattlefield:onGridSwitched()
    local grid = self:getUI("fieldGrid")
    if (grid) then
        grid:view(not grid:isOpened())
    end
end

function MapEditorBattlefield:calculateFieldPos(i, j)
    local left, top, _, _ = self:getRect()
    local cell_width, cell_height = unpack(self._cell_size)
    local x = left + (i - 1) * cell_width
    local y = top + (j - 1) * cell_height
    return x, y
end

function MapEditorBattlefield:getCellPosForCursor()
    local x, y = Engine.getMousePos()
    local sx, sy = self:screenToScrollPos(x, y)
    local bx, by, _, _ = self:getRect()
    local i, j = self:calculateCell(sx - bx, sy - by)
    return self:calculateFieldPos(i, j)
end

function MapEditorBattlefield:onMouseMove()
    if (self.selected_item_id) then
        local cursor = self:getUI("cursor")
        local field_x, field_y = self:getCellPosForCursor()
        cursor:moveTo(field_x, field_y)
    end
end

function MapEditorBattlefield.scrollToDirection(params)
    local self = params[1]
    if (self) then
        local direction = params[2]
        local value = params[3]
        self:enableScroll(direction, value)
    end
end