require('game/map_handler')
require('game/entity_handler')
require("containers/map_editor_battlefield")
require("containers/map_editor_items_panel")
require("containers/map_editor_filters_panel")
require("containers/map_editor_system_panel")
require("containers/map_editor_edit_panel")
require("containers/map_editor_info_panel")
require("containers/save_load_dialog")
require("containers/edit_entity_dialog")
require("containers/notification_dialog")
-- require("containers/inventory_dialog")

class "MapEditorScreen" (Screen)

function MapEditorScreen:init()
    self._current_map_file = nil

    self:addCallback("KeyUp_" .. HotKeys.Save, self.__quickSaveMap, self)
    self:addCallback("KeyUp_" .. HotKeys.Load, self.__quickLoad, self)

    -- Observer:addListener("ShowInventory", self, self.__showInventory)
    -- Observer:addListener("DeleteEntity", self, self.onEntityDelete)
    -- Observer:addListener("AddEntity", self, self.onEntityAdd)

    Observer:addListener("EditEntity", self, self.__onEditItem)
    Observer:addListener("ExitScreen", self, self.__exitScreen)
    Observer:addListener("ShowNotification", self, self.__showNotification)
    Observer:addListener("StartNewMap", self, self.__startNewMap)
    Observer:addListener("SaveMapFile", self, self.__save)
    Observer:addListener("LoadMapFile", self, self.__load)

    local btn = Button("menuBtn")
    btn:setText("Menu")
    btn:setFont("system_15_fnt")
    btn:setRect(0, 0, 64, 64)
    btn:setAlignment("LEFT|BOTTOM", 0, 0)
    btn:setTextAlignment("CENTER|MIDDLE")
    btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    btn:addCallback("MouseUp_Left", self.__viewMainMenu, self)
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

    local edit_entity_dlg = EditEntityDialog("edit_entity_dlg")
    self:attach(edit_entity_dlg)
    self:setUI("edit_entity_dlg", edit_entity_dlg)

--     self.inventory_dlg = InventoryDialog()
--     self:attach(self.inventory_dlg)
end

--[[ Private ]]

function MapEditorScreen:__exitScreen()
    Screens.load("LoadingScreen", "MainScreen")
end

function MapEditorScreen:__viewMainMenu()
    local panel = self:getUI("system_panel")
    if (panel) then
        panel:instantView(not panel:isOpened())
    end
end

function MapEditorScreen:__startNewMap()
    local battlefield = self:getUI("battlefield")
    if (battlefield) then
        battlefield:clear()
    end
end

function MapEditorScreen:__showNotification(msg)
    local dlg = self:getUI("notification_dlg")
    if (dlg and msg) then
        dlg:setMessage(msg)
        dlg:view(true)
    end
end

function MapEditorScreen:__saveBattlefieldMap(filename)
    local battlefield = self:getUI("battlefield")
    if (battlefield) then
        battlefield:saveMap(filename)
    end
end

function MapEditorScreen:__loadBattlefiledMap(filename)
    local battlefield = self:getUI("battlefield")
    if (battlefield) then
        battlefield:loadMap(filename)
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

function MapEditorScreen:__quickSaveMap()
    if (self._current_map_file) then
        self:__saveBattlefieldMap(self._current_map_file)
    else
        self:__openSaveDialog()
    end
end

function MapEditorScreen:__save(filename)
    if (filename) then
        self._current_map_file = filename
        self:__saveBattlefieldMap(filename)
    else
        self:__openSaveDialog()
    end
end

function MapEditorScreen:__quickLoad(sender, filename)
    self:__load(sender, filename)
end

function MapEditorScreen:__load(sender, filename)
    if (filename) then
        self:__loadBattlefiledMap(filename)
    else
        self:__openLoadDialog()
    end
end

function MapEditorScreen:__onEditItem()
    local edit_entity_dlg = self:getUI("edit_entity_dlg")
    local battlefield = self:getUI("battlefield")
    if (battlefield and edit_entity_dlg and not edit_entity_dlg:isOpened()) then
        local selected_entity = battlefield:getSelectedEntity()
        if (selected_entity and selected_entity:hasObj()) then
            local edit_params = selected_entity:getEditParams()
            edit_entity_dlg:tune(edit_params)
            edit_entity_dlg:view(true)
        end
    end
end

--[[ Public ]]

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

-- function MapEditorScreen:__showInventory()
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
-- end