class "TestAtlasScreen" (Screen)

function TestAtlasScreen:init()
    for _, data in ipairs(Sprites) do
        if ("atlas_1_tex" == data.texture) then
            local img = Image()
            img:setSprite(data.id)
            img:setRect(unpack(data.rect))
            self:attach(img)
        end
    end

    local btn = Button("backBtn")
    btn:setText("Exit")
    btn:setFont("system_15_fnt")
    btn:setRect(0, 0, 256, 64)
    btn:setAlignment("RIGHT|BOTTOM", -64, -64)
    btn:setTextAlignment("CENTER|MIDDLE")
    btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    btn:addCallback("MouseUp_Left", self.onBackBtnClick, self)
    btn:setColour("red")
    self:attach(btn)
end

function TestAtlasScreen:onBackBtnClick()
    Screens.load("LoadingScreen", "TestScreen")
end