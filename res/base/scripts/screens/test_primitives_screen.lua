class "TestPrimitivesScreen" (Screen)

function TestPrimitivesScreen:init()
    local btn = Button("backBtn")
    btn:setText("Exit")
    btn:setFont("system_15_fnt")
    btn:setRect(0, 0, 256, 64)
    btn:setTextAlignment("CENTER|MIDDLE");
    btn:setAlignment("RIGHT|TOP", 0, 0);
    btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    btn:addCallback("MouseUp_Left", self.onBackBtnClick, self);
    btn:setColour("red")
    self:attach(btn)

    local primitive = Primitive()
    primitive:setColour("white")
    primitive:createCircle(630, 130, 100)
    self:attach(primitive)

    primitive = Primitive()
    primitive:setColour("green")
    primitive:createLines({{0, 0}, {1024, 768}})
    self:attach(primitive)

    primitive = Primitive()
    primitive:setColour("red")
    primitive:createLines({{0, 0}, {200, 500}, {1024, 768}})
    self:attach(primitive)

    primitive = Primitive()
    primitive:setColour("yellow")
    primitive:createPoint(630, 130)
    self:attach(primitive)

    primitive = Primitive()
    primitive:setColour("red")
    primitive:createRect(470, 70, 60, 80, false)
    self:attach(primitive)

    primitive = Primitive()
    primitive:setColour("green")
    primitive:createRect(400, 70, 60, 60, true)
    self:attach(primitive)

    primitive = Primitive()
    primitive:setColour("green")
    primitive:createPoints({{500, 101}, {500, 102}, {500, 103}})
    self:attach(primitive)

    primitive = Primitive()
    primitive:setColour("red")
    primitive:createRects({ { 120, 700, 40, 40 },{ 100, 650, 80, 80 } }, true)
    self:attach(primitive)
end

function TestPrimitivesScreen:onBackBtnClick()
    Screens.load("LoadingScreen", "TestScreen")
end