class "TestScreen" (Screen)

function TestScreen:init()
    local btn = Button("backBtn")
    btn:setText("Main Screen")
    btn:setFont("system_15_fnt")
    btn:setRect(0, 0, 256, 64)
    btn:setAlignment("RIGHT|TOP", -64, 64)
    btn:setTextAlignment("CENTER|MIDDLE")
    btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    btn:addCallback("MouseUp_Left", self.onBackBtnClick, self)
    btn:setColour("red")
    self:attach(btn)

    btn = Button("testPrimitiveScreenBtn")
    btn:setText("Test Primitives Screen")
    btn:setFont("system_15_fnt")
    btn:setRect(0, 0, 256, 64)
    btn:setAlignment("RIGHT|TOP", -64, 138)
    btn:setTextAlignment("CENTER|MIDDLE")
    btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    btn:addCallback("MouseUp_Left", self.toTestPrimitiveScreen, self)
    self:attach(btn)

    btn = Button("testFaderScreenBtn")
    btn:setText("Test Fader Screen")
    btn:setFont("system_15_fnt")
    btn:setRect(0, 0, 256, 64)
    btn:setAlignment("RIGHT|TOP", -64, 212)
    btn:setTextAlignment("CENTER|MIDDLE")
    btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    btn:addCallback("MouseUp_Left", self.toTestFaderScreen, self)
    self:attach(btn)

    btn = Button("testSoundScreenBtn")
    btn:setText("Test Sound Screen")
    btn:setFont("system_15_fnt")
    btn:setRect(0, 0, 256, 64)
    btn:setAlignment("RIGHT|TOP", -64, 286)
    btn:setTextAlignment("CENTER|MIDDLE")
    btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    btn:addCallback("MouseUp_Left", self.toTestSoundScreen, self)
    self:attach(btn)

    btn = Button("testWidgetsScreenBtn")
    btn:setText("Test Widgets Screen")
    btn:setFont("system_15_fnt")
    btn:setRect(0, 0, 256, 64)
    btn:setAlignment("RIGHT|TOP", -64, 360)
    btn:setTextAlignment("CENTER|MIDDLE")
    btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    btn:addCallback("MouseUp_Left", self.toTestWidgetsScreen, self)
    self:attach(btn)

    btn = Button("testScrollScreenBtn")
    btn:setText("Test Scroll Screen")
    btn:setFont("system_15_fnt")
    btn:setRect(0, 0, 256, 64)
    btn:setAlignment("RIGHT|TOP", -64, 434)
    btn:setTextAlignment("CENTER|MIDDLE")
    btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    btn:addCallback("MouseUp_Left", self.toTestScrollScreen, self)
    self:attach(btn)

    btn = Button("testFontScreenBtn")
    btn:setText("Test Font Screen")
    btn:setFont("system_15_fnt")
    btn:setRect(0, 0, 256, 64)
    btn:setAlignment("RIGHT|TOP", -64, 508)
    btn:setTextAlignment("CENTER|MIDDLE")
    btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    btn:addCallback("MouseUp_Left", self.toTestFontScreen, self)
    self:attach(btn)

    btn = Button("testAtlasScreenBtn")
    btn:setText("Test Atlas Screen")
    btn:setFont("system_15_fnt")
    btn:setRect(0, 0, 256, 64)
    btn:setAlignment("RIGHT|TOP", -64, 582)
    btn:setTextAlignment("CENTER|MIDDLE")
    btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    btn:addCallback("MouseUp_Left", self.toAtlasScreen, self)
    self:attach(btn)

    btn = Button("testBattlefieldScreenBtn")
    btn:setText("Test BattleField Screen")
    btn:setFont("system_15_fnt")
    btn:setRect(0, 0, 256, 64)
    btn:setAlignment("RIGHT|TOP", -64, 656)
    btn:setTextAlignment("CENTER|MIDDLE")
    btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    btn:addCallback("MouseUp_Left", self.toBattlefield, self)
    self:attach(btn)
end

function TestScreen:onBackBtnClick()
    Screens.load("LoadingScreen", "MainScreen")
end

function TestScreen:toTestPrimitiveScreen()
    Screens.load("LoadingScreen", "TestPrimitivesScreen")
end

function TestScreen:toTestFaderScreen()
    Screens.load("LoadingScreen", "TestFaderScreen")
end

function TestScreen:toTestWidgetsScreen()
    Screens.load("LoadingScreen", "TestWidgetsScreen")
end

function TestScreen:toTestSoundScreen()
    Screens.load("LoadingScreen", "TestSoundScreen")
end

function TestScreen:toTestScrollScreen()
    Screens.load("LoadingScreen", "TestScrollScreen")
end

function TestScreen:toTestFontScreen()
    Screens.load("LoadingScreen", "TestFontScreen")
end

function TestScreen:toAtlasScreen()
    Screens.load("LoadingScreen", "TestAtlasScreen")
end

function TestScreen:toBattlefield()
    Screens.load("LoadingScreen", "TestBattlefieldScreen")
end