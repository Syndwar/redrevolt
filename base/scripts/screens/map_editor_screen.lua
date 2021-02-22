require('game/map_handler')
require('game/entity_handler')
require("containers/map_editor_battlefield")
require("containers/map_editor_items_panel")
require("containers/map_editor_filters_panel")
require("containers/map_editor_system_panel")
require("containers/map_editor_edit_panel")
require("containers/map_editor_info_panel")
require("containers/save_load_dialog")
-- require("containers/edit_entity_dialog")
require("containers/notification_dialog")
-- require("containers/inventory_dialog")

class "MapEditorScreen" (Screen)

function MapEditorScreen:init()
    self:addCallback("KeyUp_" .. HotKeys.Grid, self.onGridSwitched, self)
    self:addCallback("KeyUp_" .. HotKeys.Panel1, self.__onChangeFilter, 1)
    self:addCallback("KeyUp_" .. HotKeys.Panel2, self.__onChangeFilter, 2)
    self:addCallback("KeyUp_" .. HotKeys.Panel3, self.__onChangeFilter, 3)
    self:addCallback("KeyUp_" .. HotKeys.Panel4, self.__onChangeFilter, 4)
    self:addCallback("KeyUp_" .. HotKeys.Save, self.__onQuickSaveEditorMap, self)
    self:addCallback("KeyUp_" .. HotKeys.Load, self.__onLoadEditorMap, self)

    Observer:addListener("ExitScreen", self, self.__onExitScreen)

    Observer:addListener("ShowInventory", self, self.__showInventory)
    
    Observer:addListener("EditEntity", self, self.__onEditItem)
    Observer:addListener("NextEntity", self, self.__goToNextEntity)
    Observer:addListener("PrevEntity", self, self.__goToPrevEntity)

    Observer:addListener("StartNewMap", self, self.__onStartNewMap)
    Observer:addListener("SaveMapFile", self, self.__onSaveEditorMap)
    Observer:addListener("LoadMapFile", self, self.__onLoadEditorMap)

--     Observer:addListener("DeleteEntity", self, self.onEntityDelete)
--     Observer:addListener("AddEntity", self, self.onEntityAdd)

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

    local battlefield = MapEditorBattlefield("battlefield")
    self:attach(battlefield)
    self:setUI("battlefield", battlefield)

    local system_panel = MapEditorSystemPanel("systemPanel")
    system_panel:instantView(false)
    self:attach(system_panel)
    self:setUI("system_panel", system_panel)

    local entities_panel = MapEditorItemsPanel("itemsPanel")
    entities_panel:addPage(1, Items)
    entities_panel:addPage(2, Units)
    entities_panel:addPage(3, Objects)
    entities_panel:addPage(4, Terrain)
    self:attach(entities_panel)

    local filters_panel = MapEditorFiltersPanel("filtersPanel")
    self:attach(filters_panel)

    local edit_panel = MapEditorEditPanel("editPanel")
    edit_panel:setAngles({0, 90, 180, 270})
    edit_panel:setFlips({{false, false, "   "}, {true, false, " | "}, {false, true, "- -"}, {true, true, "-|-"}})
    self:attach(edit_panel)

    local info_panel = MapEditorInfoPanel("info_panel")
    self:attach(info_panel)
    self:setUI("info_panel", info_panel)

    local save_load_dlg = SaveLoadDialog("save_load_dlg")
    self:attach(save_load_dlg)
    self:setUI("save_load_dlg", save_load_dlg)

    local notification_dlg = NotificationDialog("notificationDialog")
    self:attach(notification_dlg)
    self:setUI("notification_dlg", notification_dlg)

--     self.edit_entity_dlg = EditEntityDialog()
--     self:attach(self.edit_entity_dlg)

--     self.inventory_dlg = InventoryDialog()
--     self:attach(self.inventory_dlg)
end

function MapEditorScreen:__onExitScreen()
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

function MapEditorScreen.__onChangeFilter(id)
    Observer:call("ChangeFilter", id)
end

-- function MapEditorScreen:scrollToCell(i, j)
--     local x, y = self:calculateFieldPos(i, j)

--     local screen_width = Engine.getScreenWidth()
--     local screen_height = Engine.getScreenHeight()
--     x = x - screen_width / 2
--     y = y - screen_height / 2
--     self.battlefield:jumpTo(x, y)
-- end

function MapEditorScreen:__goToPrevEntity()
--     local id = self._filter
--     if (id) then
--         local entities = GameData.getEntities(id)
--         if (entities) then
--             local selected_item_index = self.selected_item_index or (MapHandler.getContentSize() + 1)
--             for i = selected_item_index - 1, 1, -1 do
--                 local entity = MapHandler.getEntity(i)
--                 if (entity) then
--                     for _, data in ipairs(entities) do
--                         if (data.id == entity.id) then
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

function MapEditorScreen:__goToNextEntity()
--     local id = self._filter
--     if (id) then
--         local entities = GameData.getEntities(id)
--         if (entities) then
--             local selected_item_index = self.selected_item_index or 0
--             local map_content_size = MapHandler.getContentSize()
--             for i = selected_item_index + 1, map_content_size do
--                 local entity = MapHandler.getEntity(i)
--                 if (entity) then
--                     for _, data in ipairs(entities) do
--                         if (data.id == entity.id) then
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

function MapEditorScreen:__saveMap(file_name)
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
end

function MapEditorScreen:__clearMap()
--     self.current_map_file = nil
--     self.edit_panel:reset(0, {false, false})
--     self:__onCancelItem()
--     -- detach all items from the battlefield
--     self.battlefield:detachAll()
--     -- attach grid
--     self.battlefield:attach(self.grid)
--     self.battlefield:attach(self.cursor)
--     -- collect garbage
--     Engine.collectGarbage()
end

function MapEditorScreen:__loadMap(file_name)
    local battlefield = self:getUI("battlefield")
    if (battlefield) then
        battlefield:loadMap(file_name)
    end
end

function MapEditorScreen:__openSaveDialog()
    local save_load_dlg = self:getUI("save_load_dlg")
    if (save_load_dlg) then
        if (not save_load_dlg:isOpened()) then
            save_load_dlg:setFiles(FileSystem.getFilesInFolder(Config.map_folder))
            save_load_dlg:switchToSave()
            save_load_dlg:view(true)
        end
    end
end

function MapEditorScreen:__openLoadDialog()
    local save_load_dlg = self:getUI("save_load_dlg")
    if (save_load_dlg) then
        if (not save_load_dlg:isOpened()) then
            save_load_dlg:setFiles(FileSystem.getFilesInFolder(Config.map_folder))
            save_load_dlg:switchToLoad()
            save_load_dlg:view(true)
        end
    end
end

function MapEditorScreen:__onQuickSaveEditorMap()
    if (self.current_map_file) then
        self:__saveMap(self.current_map_file)
    else
        self:__openSaveDialog()
    end
end

function MapEditorScreen:__onSaveEditorMap(file_name)
    if (file_name) then
        self.current_map_file = file_name
        self:__saveMap(file_name)
    else
        self:__openSaveDialog()
    end
end

function MapEditorScreen:__onLoadEditorMap(sender, file_name)
    if (file_name) then
        self:__loadMap(file_name)
    else
        self:__openLoadDialog()
    end
end

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

function MapEditorScreen:__onStartNewMap()
    self:__clearMap()
end

function MapEditorScreen:__onEditItem()
--     if (self.selected_item_index) then
--         local entity = MapHandler.getEntity(self.selected_item_index)
--         self.edit_entity_dlg:tune(entity)
--         self.edit_entity_dlg:view(true)
--     end
end

function MapEditorScreen:__showInventory()
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