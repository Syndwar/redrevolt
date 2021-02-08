class "MapEditorSystemPanel" (Container)

local function __getUIDesc(self)
    return 
    {
        {
            widget = "Image",
            rect = {0, 0, 64, 5 * 64},
            sprite = "dark_img_spr",
        },
        {
            id = "backBtn", widget = "Button",
            rect = {0, 0, 64, 64},
            callback = {"MouseUp_Left", self.onBackBtnClick, self},
            text = "Exit", colour = "red", font = "system_15_fnt", text_align = "CENTER|MIDDLE",
            sprites = {"up_btn_spr", "down_btn_spr", "over_btn_spr"},
        },
        {
            id = "saveBtn", widget = "Button",
            rect = {0, 64, 64, 64},
            callback = {"MouseUp_Left", self.onSaveBtnClick, self},
            text = "Save", colour = "red", font = "system_15_fnt", text_align = "CENTER|MIDDLE",
            sprites = {"up_btn_spr", "down_btn_spr", "over_btn_spr"},
        },
        {
            id = "loadBtn", widget = "Button",
            rect = {0, 128, 64, 64},
            callback = {"MouseUp_Left", self.onLoadBtnClick, self},
            text = "Load", colour = "red", font = "system_15_fnt", text_align = "CENTER|MIDDLE",
            sprites = {"up_btn_spr", "down_btn_spr", "over_btn_spr"},
        },
        {
            id = "gridBtn", widget = "Button", ui = "gridBtn",
            rect = {0, 192, 64, 64},
            callback = {"MouseUp_Left", self.onGridBtnClick, self},
            text = "Load", colour = "red", font = "system_13_fnt", text_align = "CENTER|MIDDLE",
            sprites = {"up_btn_spr", "down_btn_spr", "over_btn_spr"},
        },
        {
            id = "newMapBtn", widget = "Button",
            rect = {0, 256, 64, 64},
            callback = {"MouseUp_Left", self.onNewMapBtnClick, self},
            text = "New Map", colour = "red", font = "system_13_fnt", text_align = "CENTER|MIDDLE",
            sprites = {"up_btn_spr", "down_btn_spr", "over_btn_spr"},
        },
    }
   
end

function MapEditorSystemPanel:init()
    self._ui = {}
    self._is_grid_on = true
    self:setRect(0, 0, 64, 320)
    self:setAlignment("LEFT|BOTTOM", 0, -64)

    Observer:addListener("SwitchGrid", self, self.onGridSwitched)

    UIBuilder.create(self, __getUIDesc(self))
    self:update()
end

function MapEditorSystemPanel:onGridSwitched()
    self._is_grid_on = not self._is_grid_on
    self:update()
end

function MapEditorSystemPanel:update()
    local btn = self._ui["gridBtn"]
    if (btn) then
        btn:setText(self._is_grid_on and "Grid On" or "Grid Off")
        btn:setColour(self._is_grid_on and "green" or "red")
    end
end

function MapEditorSystemPanel:onBackBtnClick()
    Observer:call("ExitScreen")
end

function MapEditorSystemPanel:onSaveBtnClick()
    Observer:call("SaveEditorMap")
end

function MapEditorSystemPanel:onLoadBtnClick()
    Observer:call("LoadEditorMap")
end

function MapEditorSystemPanel:onGridBtnClick()
    Observer:call("SwitchGrid")
end

function MapEditorSystemPanel:onNewMapBtnClick()
    Observer:call("StartNewMap")
end