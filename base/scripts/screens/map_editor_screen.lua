require('game/map_handler')
-- require('game/entity_handler')
require("containers/map_editor_battlefield")
require("containers/map_editor_items_panel")
require("containers/map_editor_filters_panel")
require("containers/map_editor_system_panel")
require("containers/map_editor_edit_panel")
-- require("containers/map_editor_info_panel")
require("containers/save_load_dialog")
-- require("containers/edit_entity_dialog")
require("containers/notification_dialog")
-- require("containers/inventory_dialog")

class "MapEditorScreen" (Screen)

function MapEditorScreen:init()
    self._filter = nil
--     self.selected_item_id = nil
--     self.selected_item_index = nil
--     self.current_map_file = nil

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

    self:addCallback("KeyUp_" .. HotKeys.Grid, self.onGridSwitched, self)
    self:addCallback("KeyUp_" .. HotKeys.Panel1, self.onChangeFilter, "items")
    self:addCallback("KeyUp_" .. HotKeys.Panel2, self.onChangeFilter, "units")
    self:addCallback("KeyUp_" .. HotKeys.Panel3, self.onChangeFilter, "objects")
    self:addCallback("KeyUp_" .. HotKeys.Panel4, self.onChangeFilter, "terrain")
    self:addCallback("KeyUp_" .. HotKeys.Save, self.__onQuickSaveEditorMap, self)
    self:addCallback("KeyUp_" .. HotKeys.Load, self.__onLoadEditorMap, self)

    Observer:addListener("ExitScreen", self, self.onExitScreen)
    Observer:addListener("SelectEntity", self, self.onSelectedItemChanged)
    Observer:addListener("CancelEntity", self, self.onCancelItem)
    Observer:addListener("EditEntity", self, self.onEditItem)
    Observer:addListener("ShowInventory", self, self.showInventory)
    Observer:addListener("RotateEntity", self, self.onRotateItem)
    Observer:addListener("FlipEntity", self, self.onFlipItem)
    Observer:addListener("NextEntity", self, self.goToNextEntity)
    Observer:addListener("PrevEntity", self, self.goToPrevEntity)
    Observer:addListener("StartNewMap", self, self.onStartNewMap)
    Observer:addListener("SaveEditorMap", self, self.__onSaveEditorMap)
    Observer:addListener("LoadEditorMap", self, self.__onLoadEditorMap)

--     Observer:addListener("DeleteEntity", self, self.onEntityDelete)
--     Observer:addListener("AddEntity", self, self.onEntityAdd)

    local cell_width, cell_height = MapHandler.getCellSize()
    local cells_in_row, cells_in_col = MapHandler.getMapSize()

    local battlefield = MapEditorBattlefield("battlefield")
    battlefield:setMapSize(cells_in_row, cells_in_col)
    battlefield:setCellSize(cell_width, cell_height)
    battlefield:update()
    self:attach(battlefield)
    self:setUI("battlefield", battlefield)

--     self.battlefield:addCallback("MouseDown_Left", self.onBattleFieldLeftClicked, self)
--     self.battlefield:addCallback("MouseDown_Right", self.onBattleFieldRightClicked, self)
--     self.battlefield:addCallback("MouseDown_Middle", self.onBattleFieldMiddleClicked, self)


    local system_panel = MapEditorSystemPanel("systemPanel")
    system_panel:instantView(false)
    self:attach(system_panel)
    self:setUI("system_panel", system_panel)

    local entities_panel = MapEditorItemsPanel("itemsPanel")
    entities_panel:addPage("items", Items)
    entities_panel:addPage("units", Units)
    entities_panel:addPage("objects", Objects)
    entities_panel:addPage("terrain", Terrain)
    self:attach(entities_panel)

    local filters_panel = MapEditorFiltersPanel("filtersPanel")
    self:attach(filters_panel)

    local edit_panel = MapEditorEditPanel("editPanel")
    edit_panel:setAngles({0, 90, 180, 270})
    edit_panel:setFlips({{false, false, "   "}, {true, false, " | "}, {false, true, "- -"}, {true, true, "-|-"}})
    self:attach(edit_panel)

--     self.info_panel = MapEditorInfoPanel()
--     self:attach(self.info_panel)

    local save_load_dlg = SaveLoadDialog("save_load_dlg")
    self:attach(save_load_dlg)
    self:setUI("save_load_dlg", save_load_dlg)

--     self.edit_entity_dlg = EditEntityDialog()
--     self:attach(self.edit_entity_dlg)

    local notification_dlg = NotificationDialog("notificationDialog")
    self:attach(notification_dlg)
    self:setUI("notification_dlg", notification_dlg)

--     self.inventory_dlg = InventoryDialog()
--     self:attach(self.inventory_dlg)
end

function MapEditorScreen:onExitScreen()
    Screens.load("LoadingScreen", "MainScreen")
end

function MapEditorScreen:onGridSwitched()
    Observer:call("SwitchGrid")
end

function MapEditorScreen:onMenuBtnClick()
    local panel = self:getUI("system_panel")
    if (panel) then
        panel:instantView(not panel:isOpened())
    end
end

function MapEditorScreen.onChangeFilter(id)
    Observer:call("ChangeFilter", id)
end

-- function MapEditorScreen:getItemFlip()
--     return self.edit_panel:getFlip()
-- end

-- function MapEditorScreen:getItemAngle()
--     return self.edit_panel:getAngle()
-- end

-- function MapEditorScreen:scrollToCell(i, j)
--     local x, y = self:calculateFieldPos(i, j)

--     local screen_width = Engine.getScreenWidth()
--     local screen_height = Engine.getScreenHeight()
--     x = x - screen_width / 2
--     y = y - screen_height / 2
--     self.battlefield:jumpTo(x, y)
-- end

function MapEditorScreen:goToPrevEntity()
--     local id = self._filter
--     if (id) then
--         local entities = GameData.getEntities(id)
--         if (entities) then
--             local selected_item_index = self.selected_item_index or (MapHandler.getContentSize() + 1)
--             self:onCancelItem()
--             for i = selected_item_index - 1, 1, -1 do
--                 local entity = MapHandler.getEntity(i)
--                 if (entity) then
--                     for _, data in ipairs(entities) do
--                         if (data.id == entity.id) then
--                             log(data.id)
--                             self:selectItem(i)
--                             self:scrollToCell(entity.pos[1], entity.pos[2])
--                             return
--                         end
--                     end
--                 end
--             end
--         end
--     end
end

function MapEditorScreen:goToNextEntity()
--     local id = self._filter
--     if (id) then
--         local entities = GameData.getEntities(id)
--         if (entities) then
--             local selected_item_index = self.selected_item_index or 0
--             self:onCancelItem()
--             local map_content_size = MapHandler.getContentSize()
--             for i = selected_item_index + 1, map_content_size do
--                 local entity = MapHandler.getEntity(i)
--                 if (entity) then
--                     for _, data in ipairs(entities) do
--                         if (data.id == entity.id) then
--                             log(data.id)
--                             self:selectItem(i)
--                             self:scrollToCell(entity.pos[1], entity.pos[2])
--                             return
--                         end
--                     end
--                 end
--             end
--         end
--     end
end

-- function MapEditorScreen:getMapFilePath(file_name)
--     return string.format("%s/%s.map", Config.map_folder, file_name)
-- end

-- function MapEditorScreen:saveMap(file_name)
--     if (file_name) then
--         -- clean up map from cpp entities
--         local current_map = MapHandler.getSaveMap()
--         -- save map to the file
--         table.totxt(current_map, self:getMapFilePath(file_name))
--         -- collect garbage
--         Engine.collectGarbage()
--         log("Map is saved.")
--         self.notification_dlg:setMessage("Map is saved.")
--         self.notification_dlg:view(true)
--     end
-- end

-- function MapEditorScreen:clearMap()
--     self.current_map_file = nil
--     self.edit_panel:reset(0, {false, false})
--     self:onCancelItem()
--     -- detach all items from the battlefield
--     self.battlefield:detachAll()
--     -- attach grid
--     self.battlefield:attach(self.grid)
--     self.battlefield:attach(self.cursor)
--     -- collect garbage
--     Engine.collectGarbage()
-- end

-- function MapEditorScreen:loadMap(file_name)
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
-- end

function MapEditorScreen:__openSaveDialog()
    local save_load_dlg = self:getUI("save_load_dlg")
    if (save_load_dlg) then
        if (not save_load_dlg:isOpened()) then
            save_load_dlg:switchToSave()
            save_load_dlg:view(true)
        end
    end
end

function MapEditorScreen:__openLoadDialog()
    local save_load_dlg = self:getUI("save_load_dlg")
    if (save_load_dlg) then
        if (not save_load_dlg:isOpened()) then
            save_load_dlg:switchToLoad()
            save_load_dlg:view(true)
        end
    end
end

function MapEditorScreen:__onQuickSaveEditorMap()
    if (self.current_map_file) then
        self:saveMap(self.current_map_file)
    else
        self:__openSaveDialog()
    end
end

function MapEditorScreen:__onSaveEditorMap(file_name)
    if (file_name) then
        self.current_map_file = file_name
        self:saveMap(file_name)
    else
        self:__openSaveDialog()
    end
end

function MapEditorScreen:__onLoadEditorMap(sender, file_name)
    if (file_name) then
        self.current_map_file = file_name
        self:loadMap(file_name)
    else
        self:__openLoadDialog()
    end
end

function MapEditorScreen:onSelectedItemChanged(id, angle, flip)
--     self.selected_item_id = id

--     local data = GameData.find(id)
--     self.info_panel:instantView(true)
--     self.info_panel:update(data.sprite, self:getItemAngle(), self:getItemFlip(), id)
--     self:resetCursor()
end

function MapEditorScreen:onRotateItem()
--     if (self.info_panel:isOpened()) then
--         self.info_panel:update(nil, self:getItemAngle(), nil, nil)
--         self:resetCursor()
--     end
--     if (self.selected_item_index) then
--         local entity = MapHandler.getEntity(self.selected_item_index)
--         entity.angle = self:getItemAngle()
--         if (entity.obj) then
--             entity.obj:setAngle(entity.angle)
--         end
--     end
end

function MapEditorScreen:onFlipItem()
--     if (self.info_panel:isOpened()) then
--         self.info_panel:update(nil, nil, self:getItemFlip(), nil)
--         self:resetCursor()
--     end
--     if (self.selected_item_index) then
--         local entity = MapHandler.getEntity(self.selected_item_index)
--         entity.flip = self:getItemFlip()
--         if (entity.obj) then
--             entity.obj:setFlip(unpack(entity.flip))
--         end
--     end
end

-- function MapEditorScreen:resetCursor(x, y)
--     local is_opened = self.cursor:isOpened()
--     if (self.selected_item_id) then
--         if (not is_opened) then
--             self.cursor:instantView(true)
--         end

--         -- take given coordinates
--         local field_x, field_y = x, y
--         if (not field_x or not field_x) then
--             -- if give coordinates are missing - calculate them
--             field_x, field_y = self:getCellPosForCursor()
--         end

--         local data = GameData.find(self.selected_item_id)
--         local geometry = GameData.getGeometry(data, self:getItemAngle(), self:getItemFlip())

--         local cell_width, cell_height = MapHandler.getCellSize()
        
--         local rects = {}
--         for row_index, row in ipairs(geometry) do
--             for col_index, value in ipairs(row) do
--                 if (0 ~= value) then
--                     local cell_top = field_x + (col_index - 1) * cell_width
--                     local cell_left = field_y + (row_index - 1) * cell_height
--                     local rect = {cell_top, cell_left, cell_width, cell_height}
--                     table.insert(rects, rect)
--                 end
--             end
--         end
--         self.cursor:reset(rects, false)
--     elseif (is_opened) then
--         self.cursor:view(false)
--     end
-- end

-- function MapEditorScreen:findEntityOnClick()
--     local x, y = Engine.getMousePos()
--     local sx, sy = self.battlefield:screenToScrollPos(x, y)
--     local bx, by, _, _ = self.battlefield:getRect()
--     local i, j = __calculateCell(sx - bx, sy - by)

--     for index = MapHandler.getContentSize(), 1, -1 do
--         local entity = MapHandler.getEntity(index)
--         local obj_data = GameData.find(entity.id)
--         local geometry = GameData.getGeometry(obj_data, entity.angle, entity.flip)
--         for k, row in ipairs(geometry) do
--             for l, value in ipairs(row) do
--                 if (1 == value) then
--                     local obj_part_x = entity.pos[1] + (l - 1)
--                     local obj_part_y = entity.pos[2] + (k - 1)
--                     if (obj_part_x == i and obj_part_y == j) then
--                         return index, entity
--                     end
--                 end
--             end
--         end
--     end
--     return 0
-- end

-- function MapEditorScreen:selectItem(index)
--     if (index > 0) then
--         self.selected_item_index = index
--         local entity = MapHandler.getEntity(index)
--         local data = GameData.find(entity.id)
        
--         self.edit_panel:reset(entity.angle, entity.flip)
--         self.info_panel:instantView(true)
--         self.info_panel:update(data.sprite, self:getItemAngle(), self:getItemFlip(), entity.id, entity)
--     end
-- end

-- function MapEditorScreen:onBattleFieldLeftClicked()
--     if (self.selected_item_id) then
--         local x, y = Engine.getMousePos()
--         local sx, sy = self.battlefield:screenToScrollPos(x, y)
--         local bx, by, _, _ = self.battlefield:getRect()
--         local i, j = __calculateCell(sx - bx, sy - by)
--         local id = self.selected_item_id

--         if (id) then
--             -- check for duplicates
--             local found_duplicate = MapHandler.hasDuplicateInCell(id, i, j)
--             if (not found_duplicate) then
--                 -- create entity
--                 local entity = EntityHandler.new(id)
--                 entity:setPos(i, j)
--                 entity:setAngle(self:getItemAngle())
--                 local flip = self:getItemFlip()
--                 entity:setFlip(flip[1], flip[2])
--                 entity.obj = self:createEntity(entity)
--                 -- add it to the map
--                 MapHandler.addEntity(entity)
--             end
--         end
--     else
--         local index = self:findEntityOnClick()
--         if (index > 0) then
--             self:selectItem(index)
--         end
--     end
-- end

-- function MapEditorScreen:onBattleFieldRightClicked()
--     if (self.selected_item_index) then
--         self:onCancelItem()
--     else
--         local index, entity = self:findEntityOnClick()
--         self:onEntityDelete(index, entity)
--     end
-- end

-- function MapEditorScreen:onEntityAdd(entity, i, j)
--     if (entity) then
--         entity.pos = {i, j}
--         entity.obj = self:createEntity(entity)
--         MapHandler.addEntity(entity)
--     end
-- end

-- function MapEditorScreen:onEntityDelete(index, entity)
--     local index = index or MapHandler.getEntityIndex(entity)
--     if (index > 0) then
--         self.battlefield:detach(entity.obj)
--         MapHandler.deleteEntityByIndex(index)
--     end
-- end

-- function MapEditorScreen:onBattleFieldMiddleClicked()
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
--                             self:onSelectedItemChanged(entity.id, entity.angle, entity.flip)
--                             break
--                         end
--                     end
--                 end
--             end
--         end
--     end
-- end

-- local function __getHotSpot(size, angle)
--     local w, h = size[1], size[2]
--     local midw = w / 2
--     local midh = h / 2
--     if (w == h) then
--         return midw, midh
--     elseif (90 == angle) then
--         return midh, midh
--     elseif (270 == angle) then
--         return midw, midw
--     end
--     return midw, midh
-- end

-- function MapEditorScreen:createEntity(entity)
--     local pos = entity:getPos()
--     local angle = entity:getAngle()
--     local x, y = self:calculateFieldPos(pos[1], pos[2])
--     local data = GameData.find(entity:getId())
--     local img = Image()
--     img:setSprite(data.sprite)
--     img:ignoreMouse(true)
--     img:setRect(x, y, data.size[1], data.size[2])
--     img:setCenter(__getHotSpot(data.size, angle))
--     img:setAngle(angle)
--     img:setFlip(unpack(entity:getFlip()))
--     self.battlefield:attach(img)
--     return img
-- end

function MapEditorScreen:onCancelItem()
--     if (self.selected_item_id) then
--         self.selected_item_id = nil
--         self:resetCursor()
--         self.info_panel:instantView(false)
--     end
--     if (self.selected_item_index) then
--         self.selected_item_index = nil
--         self.info_panel:instantView(false)
--     end
end

function MapEditorScreen:onStartNewMap()
--     self:clearMap()
end

function MapEditorScreen:onEditItem()
--     if (self.selected_item_index) then
--         local entity = MapHandler.getEntity(self.selected_item_index)
--         self.edit_entity_dlg:tune(entity)
--         self.edit_entity_dlg:view(true)
--     end
end

function MapEditorScreen:showInventory()
--     if (self.selected_item_index) then
--         local entity = MapHandler.getEntity(self.selected_item_index)
--         if (entity) then
--             local entity_type = GameData.getEntityType(entity.id)
--             if (EntityType.Unit == entity_type) then
--                 self.inventory_dlg:tune(entity)
--                 self.inventory_dlg:view(true)
--             end
--         end
--     end
end