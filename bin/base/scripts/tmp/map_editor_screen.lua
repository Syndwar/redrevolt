class "MapEditorScreen" (Screen)

function MapEditorScreen:init()
    self._current_map_file = nil

    self:addCallback("KeyUp_" .. HotKeys.Save, self.__quickSaveMap, self)
    self:addCallback("KeyUp_" .. HotKeys.Load, self.__quickLoad, self)

    Observer:addListener("ShowEntityPanel", self, self.__showEntityPanel)
    Observer:addListener("ShowSelectionPanel", self, self.__showSelectionPanel)
    Observer:addListener("ShowInventoryDialog", self, self.__showInventoryDialog)
    Observer:addListener("ShowEditDialog", self, self.__showEditDialog)
    Observer:addListener("ExitScreen", self, self.__exitScreen)
    Observer:addListener("ShowNotification", self, self.__showNotification)
    Observer:addListener("StartNewMap", self, self.__startNewMap)
    Observer:addListener("SaveMapFile", self, self.__save)
    Observer:addListener("LoadMapFile", self, self.__load)

    local entities_panel = self:getUI("entities_panel")
    if (entities_panel) then
        entities_panel:addPage(1, Items)
        entities_panel:addPage(2, Units)
        entities_panel:addPage(3, Objects)
        entities_panel:addPage(4, Terrain)
    end
    local edit_panel = self:getUI("edit_panel")
    if (edit_panel) then
        edit_panel:setAngles({0, 90, 180, 270})
        edit_panel:setFlips({{false, false, "   "}, {true, false, " | "}, {false, true, "- -"}, {true, true, "-|-"}})
        edit_panel:setOrders(0, 5)
    end
end

--[[ Private ]]

function MapEditorScreen:__exitScreen()
    Screens.load("LoadingScreen", "MainScreen")
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

function MapEditorScreen:__showEditDialog(params)
    if (not params) then return end

    local edit_entity_dlg = self:getUI("edit_entity_dlg")
    if (edit_entity_dlg and not edit_entity_dlg:isOpened()) then
        edit_entity_dlg:tune(params)
        edit_entity_dlg:view(true)
    end
end

function MapEditorScreen:__showInventoryDialog(content)
    if (not content) then return end
    
    local inventory_dlg = self:getUI("inventory_dlg")
    if (inventory_dlg) then
        inventory_dlg:tune(content)
        inventory_dlg:view(true)
    end
end

function MapEditorScreen:__showSelectionPanel(entities)
    local entities_panel = self:getUI("entities_panel")
    if (entities_panel) then
        entities_panel:instantView(false)
    end
    local selection_panel = self:getUI("selection_panel")
    if (selection_panel) then
        selection_panel:tune(entities)
        selection_panel:instantView(true)
    end 
end

function MapEditorScreen:__showEntityPanel()
    local entities_panel = self:getUI("entities_panel")
    if (entities_panel) then
        entities_panel:instantView(true)
    end
    local selection_panel = self:getUI("selection_panel")
    if (selection_panel) then
        selection_panel:instantView(false)
    end 
end
