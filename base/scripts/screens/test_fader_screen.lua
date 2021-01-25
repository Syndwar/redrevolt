class "TestFaderScreen" (Screen)

function TestFaderScreen:init()
    local screen_width = Engine.getScreenWidth()
    local screen_height = Engine.getScreenHeight()
    local fadeSpeed = 100
    
    local primitive = Primitive()
    primitive:setColour("white")
    primitive:createRect(0, 0, screen_width, screen_height, true)
    self:attach(primitive)

    local btn = Button("backBtn")
    btn:setText("Exit")
    btn:setFont("system_15_fnt")
    btn:setRect(0, 0, 256, 64)
    btn:setTextAlignment("CENTER|MIDDLE")
    btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    btn:setOrder(2)
    btn:addCallback("MouseUp_Left", self.onBackBtnClick, self)
    btn:setColour("red")
    self:attach(btn)

    self.fader = Fader("fader")
    self.fader:setRect(0, 0, screen_width, screen_height)
    self.fader:setFadeSpeed(fadeSpeed)
    self.fader:setSprite("dark_img_spr")
    self:attach(self.fader)

    btn = Button("fadeInBtn")
    btn:setText("Fade In")
    btn:setFont("system_15_fnt")
    btn:setRect(0, 70, 256, 64)
    btn:setTextAlignment("CENTER|MIDDLE")
    btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    btn:addCallback("MouseUp_Left", self.onFadeInBtnClick, self)
    self:attach(btn)

    btn = Button("fadeOutBtn")
    btn:setText("Fade Out")
    btn:setFont("system_15_fnt")
    btn:setRect(0, 140, 256, 64)
    btn:setTextAlignment("CENTER|MIDDLE")
    btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    btn:addCallback("MouseUp_Left", self.onFadeOutBtnClick, self)
    self:attach(btn)

    btn = Button("fadeSpeedUpBtn")
    btn:setText("+")
    btn:setFont("system_15_fnt")
    btn:setRect(50, 210, 64, 64)
    btn:setTextAlignment("CENTER|MIDDLE")
    btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    btn:addCallback("MouseUp_Left", self.onFadeSpeedUpBtnClick, self)
    self:attach(btn)

    btn = Button("fadeSpeedDownBtn")
    btn:setText("-")
    btn:setFont("system_15_fnt")
    btn:setRect(150, 210, 64, 64)
    btn:setTextAlignment("CENTER|MIDDLE")
    btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    btn:addCallback("MouseUp_Left", self.onFadeSpeedDownBtnClick, self)
    self:attach(btn)

    local lbl = Label()
    lbl:setRect(50, 280, 100, 64)
    lbl:setText("Fade speed:")
    lbl:setFont("system_15_fnt")
    lbl:setTextAlignment("RIGHT|MIDDLE")
    lbl:setColour("red")
    self:attach(lbl)

    self.fade_speed_lbl = Label("fadeSpeedLbl")
    self.fade_speed_lbl:setRect(164, 280, 256, 64)
    self.fade_speed_lbl:setText(fadeSpeed)
    self.fade_speed_lbl:setFont("system_15_fnt")
    self.fade_speed_lbl:setTextAlignment("LEFT|MIDDLE")
    self.fade_speed_lbl:setColour("blue")
    self:attach(self.fade_speed_lbl)
end

function TestFaderScreen:onBackBtnClick()
    Screens.load("LoadingScreen", "TestScreen")
end

function TestFaderScreen:onFadeSpeedUpBtnClick()
    if (self.fader) then
        local speed = self.fader:getFadeSpeed()
        self.fader:setFadeSpeed(speed + 1)
        if (self.fade_speed_lbl) then
            speed = self.fader:getFadeSpeed(fader)
            self.fade_speed_lbl:setText(speed)
        end
    end
end

function TestFaderScreen:onFadeSpeedDownBtnClick()
    if (self.fader) then
        local speed = self.fader:getFadeSpeed()
        self.fader:setFadeSpeed(speed - 1)
        if (self.fade_speed_lbl) then
            speed = self.fader:getFadeSpeed(fader)
            self.fade_speed_lbl:setText(speed)
        end
    end
end

function TestFaderScreen:onFadeInBtnClick()
    if (self.fader) then
        self.fader:fadeIn(fader)
    end
end

function TestFaderScreen:onFadeOutBtnClick()
    if (self.fader) then
        self.fader:fadeOut(fader)
    end
end