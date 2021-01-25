class "TestFontScreen" (Screen)

function TestFontScreen:init()
    self.index = 0

    self.font_img = Image("fontImg")
    self:attach(self.font_img)

    local btn = Button("backBtn")
    btn:setText("Exit")
    btn:setFont("system_15_fnt")
    btn:setRect(0, 0, 256, 64)
    btn:setTextAlignment("CENTER|MIDDLE")
    btn:setAlignment("RIGHT|BOTTOM")
    btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    btn:addCallback("MouseUp_Left", self.onBackBtnClick, self)
    btn:setColour("red")
    self:attach(btn)

    btn = Button("changeFontBtn");
    btn:setText("Show Next Font");
    btn:setFont("system_15_fnt");
    btn:setRect(0, 0, 256, 64);
    btn:setTextAlignment("CENTER|MIDDLE");
    btn:setAlignment("RIGHT|BOTTOM", 0, -70);
    btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    btn:addCallback("MouseUp_Left", self.onChangeFontBtnClick, self);
    self:attach(btn);
end

function TestFontScreen:onBackBtnClick()
    Screens.load("LoadingScreen", "TestScreen")
end

function TestFontScreen:onChangeFontBtnClick()
    local img = self.font_img
    if not img then return end

    self.index = self.index + 1
    if (self.index > #Fonts) then
        self.index = 1
    end

    local font = Fonts[self.index]
    if (font) then
        local font_id = font["id"]
        for _, data in ipairs(Sprites) do
            if (data.texture == font_id) then
                img:setSprite(data.id)
                local textureWidth, textureHeight = Engine.getTextureSize(font_id)
                img:setRect(0, 0, textureWidth, textureHeight)
            end
        end
    end
end