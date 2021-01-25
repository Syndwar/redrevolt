class "MapEditorSystemPanel" (Container)

function MapEditorSystemPanel:init()
    self.is_grid_on = true
    self:setRect(0, 0, 64, 320)
    self:setAlignment("LEFT|BOTTOM", 0, -64)

    local img = Image()
    img:setRect(0, 0, 64, 5 * 64)
    img:setSprite("dark_img_spr")
    self:attach(img)

    local btn = Button("backBtn")
    btn:setText("Exit")
    btn:setFont("system_15_fnt")
    btn:setRect(0, 0, 64, 64)
    btn:setTextAlignment("CENTER|MIDDLE")
    btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    btn:addCallback("MouseUp_Left", self.onBackBtnClick, self)
    btn:setColour("red")
    self:attach(btn)

    btn = Button("saveBtn")
    btn:setText("Save")
    btn:setFont("system_15_fnt")
    btn:setRect(0, 64, 64, 64)
    btn:setTextAlignment("CENTER|MIDDLE")
    btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    btn:addCallback("MouseUp_Left", self.onSaveBtnClick, self)
    btn:setColour("red")
    self:attach(btn)

    btn = Button("loadBtn")
    btn:setText("Load")
    btn:setFont("system_15_fnt")
    btn:setRect(0, 128, 64, 64)
    btn:setTextAlignment("CENTER|MIDDLE")
    btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    btn:addCallback("MouseUp_Left", self.onLoadBtnClick, self)
    btn:setColour("red")
    self:attach(btn)

    btn = Button("gridBtn")
    btn:setText(self.is_grid_on and "Grid On" or "Grid Off")
    btn:setFont("system_13_fnt")
    btn:setRect(0, 192, 64, 64)
    btn:setTextAlignment("CENTER|MIDDLE")
    btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    btn:addCallback("MouseUp_Left", self.onGridBtnClick, self)
    btn:setColour("green")
    self:attach(btn)

    btn = Button("newMapBtn")
    btn:setText("New Map")
    btn:setFont("system_13_fnt")
    btn:setRect(0, 256, 64, 64)
    btn:setTextAlignment("CENTER|MIDDLE")
    btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    btn:addCallback("MouseUp_Left", self.onNewMapBtnClick, self)
    btn:setColour("red")
    self:attach(btn)
end

function MapEditorSystemPanel:onBackBtnClick()
    Screens.load("LoadingScreen", "MainScreen")
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