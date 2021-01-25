class "TestScrollScreen" (Screen)

function TestScrollScreen:init()
    self.field_width = 80
    self.field_height = 50
    self.tile_width = 128
    self.tile_height = 64
    self.tile_sprite = "test_tile_spr"

    local screen_width = Engine.getScreenWidth()
    local screen_height = Engine.getScreenHeight()

    self.scroll_cnt = ScrollContainer("scrollCnt")
    self.scroll_cnt:setRect(0, 0, screen_width, screen_height)
    self.scroll_cnt:setScrollSpeed(1000)
    self:attach(self.scroll_cnt)

    local left_area = Area("scrollLeftArea")
    left_area:setRect(0, 0, 20, 700)
    left_area:setAlignment("LEFT|MIDDLE", 0, 0)
    left_area:addCallback("MouseOver", self.scrollTo, {self, "Left", true})
    left_area:addCallback("MouseLeft", self.scrollTo, {self, "Left", false})
    self:attach(left_area)

    local up_area = Area("scrollUpArea")
    up_area:setRect(0, 0, 1000, 20)
    up_area:setAlignment("CENTER|TOP", 0, 0)
    up_area:addCallback("MouseOver", self.scrollTo, {self, "Up", true})
    up_area:addCallback("MouseLeft", self.scrollTo, {self, "Up", false})
    self:attach(up_area)

    local down_area = Area("scrollDownArea")
    down_area:setRect(0, 0, 1000, 20)
    down_area:setAlignment("CENTER|BOTTOM", 0, 0)
    down_area:addCallback("MouseOver", self.scrollTo, {self, "Down", true})
    down_area:addCallback("MouseLeft", self.scrollTo, {self, "Down", false})
    self:attach(down_area)

    local right_area = Area("scrollRightArea")
    right_area:setRect(0, 0, 20, 700)
    right_area:setAlignment("RIGHT|MIDDLE", 0, 0)
    right_area:addCallback("MouseOver", self.scrollTo, {self, "Right", true})
    right_area:addCallback("MouseLeft", self.scrollTo, {self, "Right", false})
    self:attach(right_area)

    local btn = Button("backBtn")
    btn:setText("Exit")
    btn:setFont("system_15_fnt")
    btn:setRect(0, 0, 64, 64)
    btn:setAlignment("RIGHT|BOTTOM", 0, 0)
    btn:setTextAlignment("CENTER|MIDDLE")
    btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    btn:addCallback("MouseUp_Left", self.onBackBtnClick, self)
    btn:setColour("red")
    self:attach(btn)

    btn = Button("jumpBtn")
    btn:setText("Jump")
    btn:setFont("system_15_fnt")
    btn:setRect(0, 0, 64, 64)
    btn:setAlignment("RIGHT|BOTTOM", 0, -64)
    btn:setTextAlignment("CENTER|MIDDLE")
    btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    btn:setColour("red")
    btn:addCallback("MouseUp_Left", self.onJumpBtnClick, self)
    self:attach(btn)

    btn = Button("scrollBtn")
    btn:setText("Scroll")
    btn:setFont("system_15_fnt")
    btn:setRect(0, 0, 64, 64)
    btn:setAlignment("RIGHT|BOTTOM", 0, -128)
    btn:setTextAlignment("CENTER|MIDDLE")
    btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    btn:setColour("red")
    btn:addCallback("MouseUp_Left", self.onScrollBtnClick, self)
    self:attach(btn)

    self:addScrollContent()
end

function TestScrollScreen.scrollTo(params)
    local screen = params[1]
    local direction = params[2]
    local value = params[3]
    if (screen and screen.scroll_cnt) then
        screen.scroll_cnt:enableScroll(direction, value)
    end
end

function TestScrollScreen:onBackBtnClick()
    Screens.load("LoadingScreen", "TestScreen")
end

function TestScrollScreen:onJumpBtnClick()
    if (self.scroll_cnt) then
        self.scroll_cnt:jumpTo(1024, 768)
    end
end

function TestScrollScreen:onScrollBtnClick()
    if (self.scroll_cnt) then
        if (not self.scroll_cnt:isScrolling()) then
            self.scroll_cnt:scrollTo(0, 0)
        end
    end
end

function TestScrollScreen:addScrollContent()
    if (self.scroll_cnt) then
        local content_width = 0
        local content_height = 0
        for i = 0, self.field_width - 1 do
            for j = 0, self.field_height - 1 do
                local is_odd = 1 == j % 2

                local offset_x = is_odd and (self.tile_width / 2) or 0
                local x = self.tile_width * (self.field_width - 1 - i) + offset_x
                local y = self.tile_height / 2 * j

                local img = Image()
                img:setRect(x, y, self.tile_width, self.tile_height)
                img:setSprite(self.tile_sprite)
                self.scroll_cnt:attach(img)

                if (x + self.tile_width > content_width) then
                    content_width = x + self.tile_width
                end
                if (y + self.tile_height) then
                    content_height = y + self.tile_height
                end
            end
        end
        self.scroll_cnt:setContentRect(0, 0, content_width, content_height)
    end
end