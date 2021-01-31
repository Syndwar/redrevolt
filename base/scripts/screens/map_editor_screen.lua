require('game/map_handler')
require("containers/map_editor_items_panel")
require("containers/map_editor_filters_panel")
require("containers/map_editor_system_panel")
require("containers/map_editor_edit_panel")
require("containers/map_editor_info_panel")
require("containers/save_load_dialog")
require("containers/edit_entity_dialog")
require("containers/notification_dialog")
require("containers/inventory_dialog")

class "MapEditorScreen" (Screen)

function MapEditorScreen:init()
    self.selected_item_id = nil
    self.selected_item_index = nil
    self.current_map_file = nil

    local btn = Button("menuBtn")
    btn:setText("Menu")
    btn:setFont("system_15_fnt")
    btn:setRect(0, 0, 64, 64)
    btn:setAlignment("LEFT|BOTTOM", 0, 0)
    btn:setTextAlignment("CENTER|MIDDLE")
    btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    btn:addCallback("MouseUp_Left", self.onMenuBtnClick, self)
    btn:setColour("red")
    self:attach(btn)

    Observer:addListener("SelectItem", self, self.onSelectedItemChanged)
    Observer:addListener("SwitchGrid", self, self.onGridSwitched)
    Observer:addListener("SaveEditorMap", self, self.onSaveEditorMap)
    Observer:addListener("LoadEditorMap", self, self.onLoadEditorMap)
    Observer:addListener("RotateItem", self, self.onRotateItem)
    Observer:addListener("FlipItem", self, self.onFlipItem)
    Observer:addListener("CancelItem", self, self.onCancelItem)
    Observer:addListener("StartNewMap", self, self.onStartNewMap)
    Observer:addListener("EditItem", self, self.onEditItem)
    Observer:addListener("NextItem", self, self.goToNextEntity)
    Observer:addListener("PrevItem", self, self.goToPrevEntity)
    Observer:addListener("ShowInventory", self, self.showInventory)
    Observer:addListener("DeleteEntity", self, self.onEntityDelete)

    local screen_width = Engine.getScreenWidth()
    local screen_height = Engine.getScreenHeight()

    local cell_width, cell_height = MapHandler.getCellSize()
    local cells_in_row, cells_in_col = MapHandler.getMapSize()
    local map_width = cells_in_row * cell_width
    local map_height = cells_in_col * cell_height

    self.battlefield = Battlefield("battlefield")
    self.battlefield:setRect(0, 0, screen_width - 64, screen_height - 96)
    self.battlefield:setScrollSpeed(500)
    self.battlefield:setContentRect(0, 0, map_width, map_height)
    self.battlefield:addCallback("MouseMove", self.onBattleFieldMoveMouse, self)
    self.battlefield:addCallback("MouseDown_Left", self.onBattleFieldLeftClicked, self)
    self.battlefield:addCallback("MouseDown_Right", self.onBattleFieldRightClicked, self)
    self.battlefield:addCallback("MouseDown_Middle", self.onBattleFieldMiddleClicked, self)
    self.battlefield:addCallback("KeyDown_" .. HotKeys.ScrollUp, self.scrollUp, {self, true})
    self.battlefield:addCallback("KeyDown_" .. HotKeys.ScrollLeft, self.scrollLeft, {self, true})
    self.battlefield:addCallback("KeyDown_" .. HotKeys.ScrollRight, self.scrollRight, {self, true})
    self.battlefield:addCallback("KeyDown_" .. HotKeys.ScrollDown, self.scrollDown, {self, true})
    self.battlefield:addCallback("KeyUp_" .. HotKeys.ScrollUp, self.scrollUp, {self, false})
    self.battlefield:addCallback("KeyUp_" .. HotKeys.ScrollLeft, self.scrollLeft, {self, false})
    self.battlefield:addCallback("KeyUp_" .. HotKeys.ScrollRight, self.scrollRight, {self, false})
    self.battlefield:addCallback("KeyUp_" .. HotKeys.ScrollDown, self.scrollDown, {self, false})
    self.battlefield:addCallback("KeyUp_" .. HotKeys.Panel1, self.changeFilter, {self, "items"})
    self.battlefield:addCallback("KeyUp_" .. HotKeys.Panel2, self.changeFilter, {self, "units"})
    self.battlefield:addCallback("KeyUp_" .. HotKeys.Panel3, self.changeFilter, {self, "objects"})
    self.battlefield:addCallback("KeyUp_" .. HotKeys.Panel4, self.changeFilter, {self, "terrain"})
    self.battlefield:addCallback("KeyUp_" .. HotKeys.Next, self.goToNextEntity, self)
    self.battlefield:addCallback("KeyUp_" .. HotKeys.Previous, self.goToPrevEntity, self)
    self.battlefield:addCallback("KeyUp_" .. HotKeys.Save, self.onQuickSaveEditorMap, self)
    self.battlefield:addCallback("KeyUp_" .. HotKeys.Load, self.onLoadEditorMap, self)
    self.battlefield:addCallback("KeyUp_" .. HotKeys.Grid, self.onGridSwitched, self)
    self.battlefield:addCallback("KeyUp_" .. HotKeys.Cancel, self.onCancelItem, self)
    self.battlefield:addCallback("KeyUp_" .. HotKeys.Edit, self.onEditItem, self)
    self.battlefield:addCallback("KeyUp_" .. HotKeys.Inventory, self.showInventory, self)
    self:attach(self.battlefield)

    self.grid = Primitive("fieldGrid")
    self.grid:setColour("green")
    self.grid:createLines(self.createGrid())
    self.battlefield:attach(self.grid)

    local cell_width, cell_height = MapHandler.getCellSize()
    self.cursor = Primitive("cursorRect")
    self.cursor:setColour("yellow")
    self.cursor:createRects({0, 0, cell_width, cell_height}, false)
    self.cursor:instantView(false)
    self.battlefield:attach(self.cursor)

    self.battlefield:moveBy(32, 32)

    self.system_panel = MapEditorSystemPanel()
    self.system_panel:instantView(false)
    self:attach(self.system_panel)
    
    self.items_panel = MapEditorItemsPanel()
    self:attach(self.items_panel)

    self.filters_panel = MapEditorFiltersPanel()
    self:attach(self.filters_panel)

    self.edit_panel = MapEditorEditPanel()
    self:attach(self.edit_panel)

    self.info_panel = MapEditorInfoPanel()
    self:attach(self.info_panel)

    self.save_load_dlg = SaveLoadDialog()
    self:attach(self.save_load_dlg)

    self.edit_entity_dlg = EditEntityDialog()
    self:attach(self.edit_entity_dlg)

    self.notification_dlg = NotificationDialog()
    self:attach(self.notification_dlg)

    self.inventory_dlg = InventoryDialog()
    self:attach(self.inventory_dlg)
end

function MapEditorScreen.createGrid()
    local grid_lines = {}

    local cells_in_row, cells_in_col = MapHandler.getMapSize()
    local cell_width, cell_height = MapHandler.getCellSize()
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

function MapEditorScreen:onGridSwitched()
    if (self.grid) then
        self.grid:view(not self.grid:isOpened())
    end
end

local function __scrollTo(params, direction)
    local screen = params[1]
    if (screen and screen.battlefield) then
        local value = params[2]
        screen.battlefield:enableScroll(direction, value)
    end
end

function MapEditorScreen:getItemFlip()
    return self.edit_panel:getFlip()
end

function MapEditorScreen:getItemAngle()
    return self.edit_panel:getAngle()
end

function MapEditorScreen.scrollUp(params)
    __scrollTo(params, "Up")
end

function MapEditorScreen.scrollLeft(params)
    __scrollTo(params, "Left")
end

function MapEditorScreen.scrollRight(params)
    __scrollTo(params, "Right")
end

function MapEditorScreen.scrollDown(params)
    __scrollTo(params, "Down")
end

function MapEditorScreen:scrollToCell(i, j)
    local x, y = self:calculateFieldPos(i, j)

    local screen_width = Engine.getScreenWidth()
    local screen_height = Engine.getScreenHeight()
    x = x - screen_width / 2
    y = y - screen_height / 2
    self.battlefield:jumpTo(x, y)
end

function MapEditorScreen:goToPrevEntity()
    local id = self.filters_panel:getFilter()
    if (id) then
        local entities = GameData.getEntities(id)
        if (entities) then
            local selected_item_index = self.selected_item_index or (MapHandler.getContentSize() + 1)
            self:onCancelItem()
            for i = selected_item_index - 1, 1, -1 do
                local entity = MapHandler.getEntity(i)
                if (entity) then
                    for _, data in ipairs(entities) do
                        if (data.id == entity.id) then
                            log(data.id)
                            self:selectItem(i)
                            self:scrollToCell(entity.pos[1], entity.pos[2])
                            return
                        end
                    end
                end
            end
        end
    end
end

function MapEditorScreen:goToNextEntity()
    local id = self.filters_panel:getFilter()
    if (id) then
        local entities = GameData.getEntities(id)
        if (entities) then
            local selected_item_index = self.selected_item_index or 0
            self:onCancelItem()
            local map_content_size = MapHandler.getContentSize()
            for i = selected_item_index + 1, map_content_size do
                local entity = MapHandler.getEntity(i)
                if (entity) then
                    for _, data in ipairs(entities) do
                        if (data.id == entity.id) then
                            log(data.id)
                            self:selectItem(i)
                            self:scrollToCell(entity.pos[1], entity.pos[2])
                            return
                        end
                    end
                end
            end
        end
    end
end

function MapEditorScreen.changeFilter(params)
    local screen = params[1]
    screen.items_panel:changeFilter(params[2])
end

function MapEditorScreen:onMenuBtnClick()
    self.system_panel:instantView(not self.system_panel:isOpened())
end

function MapEditorScreen:getMapFilePath(file_name)
    return string.format("%s/%s.map", Config.map_folder, file_name)
end

function MapEditorScreen:onQuickSaveEditorMap()
    if (self.current_map_file) then
        self:saveMap(self.current_map_file)
    else
        if (not self.save_load_dlg:isOpened()) then
            self.save_load_dlg:switchToSave()
            self.save_load_dlg:view(true)
        end
    end
end

function MapEditorScreen:saveMap(file_name)
    if (file_name) then
        -- clean up map from cpp entities
        local current_map = MapHandler.getSaveMap()
        -- save map to the file
        table.totxt(current_map, self:getMapFilePath(file_name))
        -- collect garbage
        Engine.collectGarbage()
        log("Map is saved.")
        self.notification_dlg:setMessage("Map is saved.")
        self.notification_dlg:view(true)
    end
end

function MapEditorScreen:onSaveEditorMap(file_name)
    if (file_name) then
        self.current_map_file = file_name
        self:saveMap(file_name)
    else
        if (not self.save_load_dlg:isOpened()) then
            self.save_load_dlg:switchToSave()
            self.save_load_dlg:view(true)
        end
    end
end

function MapEditorScreen:clearMap()
    self.current_map_file = nil
    self.edit_panel:reset(0, {false, false})
    self:onCancelItem()
    -- detach all items from the battlefield
    self.battlefield:detachAll()
    -- attach grid
    self.battlefield:attach(self.grid)
    self.battlefield:attach(self.cursor)
    -- collect garbage
    Engine.collectGarbage()
end

function MapEditorScreen:loadMap(file_name)
    if (file_name) then
        local full_file_path = self:getMapFilePath(file_name)
        local f = io.open(full_file_path, "r")
        -- check if file exists
        if (f) then
            io.close(f)
            -- clear current map
            self:clearMap()
            -- load map from file
            local settings = dofile(full_file_path)
            -- remember new map
            MapHandler.resetMap(settings)

            for _, data in ipairs(settings.content) do
                local entity =  MapEntityHandler.new(data.id, data.pos[1], data.pos[2], data.angle, data.flip, data.settings)
                entity.obj = self:createEntity(entity)
                MapHandler.addEntity(entity)
            end

            self.current_map_file = file_name
            log("Map is loaded.")
            self.notification_dlg:setMessage("Map is loaded.")
            self.notification_dlg:view(true)
        end
    end
end

function MapEditorScreen:onLoadEditorMap(sender, file_name)
    if (file_name) then
        self.current_map_file = file_name
        self:loadMap(file_name)
    else
        if (not self.save_load_dlg:isOpened()) then
            self.save_load_dlg:switchToLoad()
            self.save_load_dlg:view(true)
        end
    end
end

function MapEditorScreen:onSelectedItemChanged(id, angle, flip)
    self.selected_item_id = id
    self.edit_panel:reset(angle, flip)

    local data = GameData.find(id)
    self.info_panel:instantView(true)
    self.info_panel:update(data.sprite, self:getItemAngle(), self:getItemFlip(), id)
    self:resetCursor()
end

function MapEditorScreen:onRotateItem()
    if (self.info_panel:isOpened()) then
        self.info_panel:update(nil, self:getItemAngle(), nil, nil)
        self:resetCursor()
    end
    if (self.selected_item_index) then
        local entity = MapHandler.getEntity(self.selected_item_index)
        entity.angle = self:getItemAngle()
        if (entity.obj) then
            entity.obj:setAngle(entity.angle)
        end
    end
end

function MapEditorScreen:onFlipItem()
    if (self.info_panel:isOpened()) then
        self.info_panel:update(nil, nil, self:getItemFlip(), nil)
        self:resetCursor()
    end
    if (self.selected_item_index) then
        local entity = MapHandler.getEntity(self.selected_item_index)
        entity.flip = self:getItemFlip()
        if (entity.obj) then
            entity.obj:setFlip(unpack(entity.flip))
        end
    end
end

local function __calculateCell(x, y)
    local cell_width, cell_height = MapHandler.getCellSize()
    local i = math.floor(x / cell_width) + 1
    local j = math.floor(y / cell_height) + 1
    return i, j
end

function MapEditorScreen:getCellPosForCursor()
    local x, y = Engine.getMousePos()
    local sx, sy = self.battlefield:screenToScrollPos(x, y)
    local bx, by, _, _ = self.battlefield:getRect()
    local i, j = __calculateCell(sx - bx, sy - by)
    return self:calculateFieldPos(i, j)
end

function MapEditorScreen:resetCursor(x, y)
    local is_opened = self.cursor:isOpened()
    if (self.selected_item_id) then
        if (not is_opened) then
            self.cursor:instantView(true)
        end

        -- take given coordinates
        local field_x, field_y = x, y
        if (not field_x or not field_x) then
            -- if give coordinates are missing - calculate them
            field_x, field_y = self:getCellPosForCursor()
        end

        local data = GameData.find(self.selected_item_id)
        local geometry = GameData.getGeometry(data, self:getItemAngle(), self:getItemFlip())

        local cell_width, cell_height = MapHandler.getCellSize()
        
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
        self.cursor:reset(rects, false)
    elseif (is_opened) then
        self.cursor:view(false)
    end
end

function MapEditorScreen:findEntityOnClick()
    local x, y = Engine.getMousePos()
    local sx, sy = self.battlefield:screenToScrollPos(x, y)
    local bx, by, _, _ = self.battlefield:getRect()
    local i, j = __calculateCell(sx - bx, sy - by)

    for index = MapHandler.getContentSize(), 1, -1 do
        local entity = MapHandler.getEntity(index)
        local obj_data = GameData.find(entity.id)
        local geometry = GameData.getGeometry(obj_data, entity.angle, entity.flip)
        for k, row in ipairs(geometry) do
            for l, value in ipairs(row) do
                if (1 == value) then
                    local obj_part_x = entity.pos[1] + (l - 1)
                    local obj_part_y = entity.pos[2] + (k - 1)
                    if (obj_part_x == i and obj_part_y == j) then
                        return index, entity
                    end
                end
            end
        end
    end
    return 0
end

function MapEditorScreen:selectItem(index)
    if (index > 0) then
        self.selected_item_index = index
        local entity = MapHandler.getEntity(index)
        local data = GameData.find(entity.id)
        
        self.edit_panel:reset(entity.angle, entity.flip)
        self.info_panel:instantView(true)
        self.info_panel:update(data.sprite, self:getItemAngle(), self:getItemFlip(), entity.id, entity)
    end
end

function MapEditorScreen:onBattleFieldLeftClicked()
    if (self.selected_item_id) then
        local x, y = Engine.getMousePos()
        local sx, sy = self.battlefield:screenToScrollPos(x, y)
        local bx, by, _, _ = self.battlefield:getRect()
        local i, j = __calculateCell(sx - bx, sy - by)
        local id = self.selected_item_id

        if (id) then
            -- check for duplicates
            local found_duplicate = MapHandler.hasDuplicateInCell(id, i, j)
            if (not found_duplicate) then
                -- create entity
                local entity =  MapEntityHandler.new(id, i, j, self:getItemAngle(), self:getItemFlip())
                entity.obj = self:createEntity(entity)
                -- add it to the map
                MapHandler.addEntity(entity)
            end
        end
    else
        local index = self:findEntityOnClick()
        if (index > 0) then
            self:selectItem(index)
        end
    end
end

function MapEditorScreen:onBattleFieldRightClicked()
    if (self.selected_item_index) then
        self:onCancelItem()
    else
        local index, entity = self:findEntityOnClick()
        self:onEntityDelete(index, entity)
    end
end

function MapEditorScreen:onEntityDelete(index, entity)
    local index = index or MapHandler.getEntityIndex(entity)
    if (index > 0) then
        self.battlefield:detach(entity.obj)
        MapHandler.deleteEntityByIndex(index)
    end
end

function MapEditorScreen:onBattleFieldMiddleClicked()
    local x, y = Engine.getMousePos()
    local sx, sy = self.battlefield:screenToScrollPos(x, y)
    local bx, by, _, _ = self.battlefield:getRect()
    local i, j = __calculateCell(sx - bx, sy - by)

    for index = MapHandler.getContentSize(), 1, -1 do
        local entity = MapHandler.getEntity(index)
        if (entity) then
            local obj_data = GameData.find(entity.id)
            local geometry = GameData.getGeometry(obj_data, entity.angle, entity.flip)
            for k, row in ipairs(geometry) do
                for l, value in ipairs(row) do
                    if (1 == value) then
                        local obj_part_x = entity.pos[1] + (l - 1)
                        local obj_part_y = entity.pos[2] + (k - 1)
                        if (obj_part_x == i and obj_part_y == j) then
                            self:onSelectedItemChanged(entity.id, entity.angle, entity.flip)
                            break
                        end
                    end
                end
            end
        end
    end
end

function MapEditorScreen:onBattleFieldMoveMouse()
    if (self.selected_item_id) then
        local field_x, field_y = self:getCellPosForCursor()
        self.cursor:moveTo(field_x, field_y)
    end
end

function MapEditorScreen:calculateFieldPos(i, j)
    local left, top, _, _ = self.battlefield:getRect()
    local cell_width, cell_height = MapHandler.getCellSize()
    local x = left + (i - 1) * cell_width
    local y = top + (j - 1) * cell_height
    return x, y
end

local function __getHotSpot(size, angle)
    local w, h = size[1], size[2]
    local midw = w / 2
    local midh = h / 2
    if (w == h) then
        return midw, midh
    elseif (90 == angle) then
        return midh, midh
    elseif (270 == angle) then
        return midw, midw
    end
    return midw, midh
end

function MapEditorScreen:createEntity(settings)
    local x, y = self:calculateFieldPos(settings.pos[1], settings.pos[2])
    local data = GameData.find(settings.id)
    local img = Image()
    img:setSprite(data.sprite)
    img:ignoreMouse(true)
    img:setRect(x, y, data.size[1], data.size[2])
    img:setCenter(__getHotSpot(data.size, settings.angle))
    img:setAngle(settings.angle or 0)
    if (settings.flip) then
        img:setFlip(unpack(settings.flip))
    end
    self.battlefield:attach(img)
    return img
end

function MapEditorScreen:onCancelItem()
    if (self.selected_item_id) then
        self.selected_item_id = nil
        self:resetCursor()
        self.info_panel:instantView(false)
    end
    if (self.selected_item_index) then
        self.selected_item_index = nil
        self.info_panel:instantView(false)
    end
end

function MapEditorScreen:onStartNewMap()
    self:clearMap()
end

function MapEditorScreen:onEditItem()
    if (self.selected_item_index) then
        local entity = MapHandler.getEntity(self.selected_item_index)
        self.edit_entity_dlg:tune(entity)
        self.edit_entity_dlg:view(true)
    end
end

function MapEditorScreen:showInventory()
    if (self.selected_item_index) then
        local entity = MapHandler.getEntity(self.selected_item_index)
        if (entity) then
            local entity_type = GameData.getEntityType(entity.id)
            if (EntityType.Unit == entity_type) then
                self.inventory_dlg:tune(entity)
                self.inventory_dlg:view(true)
            end
        end
    end
end