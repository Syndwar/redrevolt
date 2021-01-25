class "TestBattlefieldScreen" (Screen)

function TestBattlefieldScreen:init()
    local btn = Button("backBtn")
    btn:setText("Exit")
    btn:setFont("system_15_fnt")
    btn:setRect(0, 0, 64, 64)
    btn:setAlignment("LEFT|BOTTOM", 0, 0)
    btn:setTextAlignment("CENTER|MIDDLE")
    btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    btn:addCallback("MouseUp_Left", self.onBackBtnClick, self)
    btn:setColour("red")
    self:attach(btn)
end

function TestBattlefieldScreen:onBackBtnClick()
    Screens.load("LoadingScreen", "TestScreen")
end