class "TestWidgetsScreen" (Screen)
class "TestDialog" (Dialog)

function TestDialog:init()
    local open_transform = Transform()
    open_transform:add(0, 100, 1000)
    open_transform:add(100, 255, 1000)
    self:attachTransform("WidgetOpening", open_transform)

    local close_transform = Transform()
    close_transform:add(255, 0, 3000)
    self:attachTransform("WidgetClosing", close_transform)

    self:setRect(0, 0, 400, 400)
    self:setAlignment("CENTER|MIDDLE", 0, 0)

    local back_img = Image()
    back_img:setRect(0, 0, 400, 400)
    back_img:setSprite("up_btn_spr")
    self:attach(back_img)

    local lbl = Label()
    lbl:setRect(100, 180, 200, 40)
    lbl:setText("Hello")
    lbl:setFont("system_24_fnt")
    lbl:setColour("green")
    lbl:setTextAlignment("CENTER|MIDDLE")
    self:attach(lbl)
end

function TestWidgetsScreen:init()
    local back_btn = Button("backBtn")
    back_btn:setText("Exit")
    back_btn:setFont("system_15_fnt")
    back_btn:setRect(0, 0, 256, 64)
    back_btn:setTextAlignment("CENTER|MIDDLE")
    back_btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    back_btn:addCallback("MouseUp_Left", self.onBackBtnClick, self)
    back_btn:setColour("red")
    self:attach(back_btn)

    local lock_btn = Button("lockBtn")
    lock_btn:setText("View Label")
    lock_btn:setFont("system_15_fnt")
    lock_btn:setRect(0, 64, 256, 64)
    lock_btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    lock_btn:addCallback("MouseUp_Left", self.onLockBtnClick, self)
    self:attach(lock_btn)

    local wind_btn = Button("windBtn")
    wind_btn:setText("Wind Progressbar")
    wind_btn:setFont("system_15_fnt")
    wind_btn:setRect(0, 128, 256, 64)
    wind_btn:setTextAlignment("CENTER|MIDDLE")
    wind_btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    wind_btn:addCallback("MouseUp_Left", self.onWindBtnClicked, self)
    wind_btn:setColour("yellow")
    self:attach(wind_btn)

    local move_cnt_btn = Button("moveCnt")
    move_cnt_btn:setText("Move Container")
    move_cnt_btn:setFont("system_15_fnt")
    move_cnt_btn:setRect(0, 192, 256, 64)
    move_cnt_btn:setTextAlignment("CENTER|MIDDLE")
    move_cnt_btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    move_cnt_btn:addCallback("MouseUp_Left", self.onMoveCntBtnClick, self)
    move_cnt_btn:setColour("white")
    self:attach(move_cnt_btn)

    local resize_btn = Button()
    resize_btn:setText("Increase Label")
    resize_btn:setFont("system_15_fnt")
    resize_btn:setRect(0, 256, 256, 64)
    resize_btn:setTextAlignment("CENTER|MIDDLE")
    resize_btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    resize_btn:addCallback("MouseUp_Left", self.onResizeBtnClick, {self, 10})
    resize_btn:setColour("white")
    self:attach(resize_btn)

    resize_btn = Button()
    resize_btn:setText("Decrease Label")
    resize_btn:setFont("system_15_fnt")
    resize_btn:setRect(0, 320, 256, 64)
    resize_btn:setTextAlignment("CENTER|MIDDLE")
    resize_btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    resize_btn:addCallback("MouseUp_Left", self.onResizeBtnClick, {self, -10})
    resize_btn:setColour("white")
    self:attach(resize_btn)

    local img = Image()
    img:setRect(0, 0, 100, 100)
    img:setSprite("round_btn_spr")
    img:setAlignment("RIGHT|TOP", 0, 0)
    img:setAngle(0)
    img:setFlip(true, true)
    self:attach(img)

    self.multiline_lbl = Label("multilineLbl")
    self.multiline_lbl:setRect(0, 0, 300, 20)
    self.multiline_lbl:setAlignment("CENTER|TOP", 0, 50)
    self.multiline_lbl:setText("Very long text for this label that should be rendered on several lines")
    self.multiline_lbl:setWrap(true)
    self.multiline_lbl:setFont("system_15_fnt")
    self.multiline_lbl:setColour("white")
    self:attach(self.multiline_lbl)

    self.exit_lbl = Label("exitLbl")
    self.exit_lbl:setRect(0, 0, 100, 100)
    self.exit_lbl:setAlignment("RIGHT|TOP", 0, 100)
    self.exit_lbl:setText("exit_lbl")
    self.exit_lbl:setFont("system_24_fnt")
    self.exit_lbl:setColour("green")
    self:attach(self.exit_lbl)

    self.pb1 = ProgressBar("pb1")
    self.pb1:setRect(656, 620, 100, 20)
    self.pb1:setSprite("progressbar_spr")
    self.pb1:setCurrentValue(0)
    self.pb1:setMaxValue(100)
    self.pb1:setFillSpeed(100)
    self.pb1:setVertical(false)
    self:attach(self.pb1)

    self.pb2 = ProgressBar("pb2")
    self.pb2:setRect(626, 620, 20, 100)
    self.pb2:setSprite("progressbar_spr")
    self.pb2:setCurrentValue(100)
    self.pb2:setMaxValue(100)
    self.pb2:setFillSpeed(100)
    self.pb2:setVertical(true)
    self:attach(self.pb2)

    local text_edit = TextEdit("textEdit")
    text_edit:setRect(400, 228, 300, 100)
    text_edit:setText("Click to enter the text")
    text_edit:setColour("blue")
    text_edit:setFont("system_24_fnt")
    text_edit:addCallback("TextEdited", self.onTextEdited, {self, text_edit})
    self:attach(text_edit)
        
    self.widget_cnt = Container("widgetCnt")
    self.widget_cnt:setRect(500, 328, 0, 0)
    self:attach(self.widget_cnt)

    local cnt_lbl = Label("cntLbl")
    cnt_lbl:setRect(500, 328, 100, 100)
    cnt_lbl:setText("Label in Container")
    cnt_lbl:setColour("white")
    cnt_lbl:setFont("system_24_fnt")
    cnt_lbl:setOrder(999)
    self.widget_cnt:attach(cnt_lbl)

    local cnt_btn = Button("cntBtn")
    cnt_btn:setText("Button in Container")
    cnt_btn:setFont("system_15_fnt")
    cnt_btn:setRect(600, 428, 256, 64)
    cnt_btn:setTextAlignment("CENTER|MIDDLE")
    cnt_btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    cnt_btn:setColour("white")
    cnt_btn:addCallback("MouseUp_Left", self.onButtonInContainerClick, self)
    self.widget_cnt:attach(cnt_btn)

    self.scroll_cnt = ScrollContainer("scrollCnt")
    self.scroll_cnt:setAlignment("RIGHT|TOP", -160, 60)
    self.scroll_cnt:setRect(0, 0, 100, 100)
    self.scroll_cnt:setScrollSpeed(500)
    self.scroll_cnt:setContentRect(0, 0, 100, 200)
    self:attach(self.scroll_cnt)

    local img1 = Image()
    img1:setRect(0, 0, 100, 100)
    img1:setSprite("round_btn_spr")
    self.scroll_cnt:attach(img1)

    local img2 = Image()
    img2:setRect(0, 100, 100, 100)
    img2:setSprite("round_btn_spr")
    self.scroll_cnt:attach(img2)

    local up_img = Image()
    up_img:setRect(0, 0, 100, 20)
    up_img:setAlignment("RIGHT|TOP", -160, 20)
    up_img:setSprite("up_btn_spr")
    self:attach(up_img)

    local scroll_up_area = Area("scrollUpArea")
    scroll_up_area:setRect(0, 0, 100, 20)
    scroll_up_area:setAlignment("RIGHT|TOP", -160, 20)
    scroll_up_area:addCallback("MouseOver", self.scrollTo, {self, "Up", true})
    scroll_up_area:addCallback("MouseLeft", self.scrollTo, {self, "Up", false})
    self:attach(scroll_up_area)

    local down_img = Image()
    down_img:setRect(0, 0, 100, 20)
    down_img:setAlignment("RIGHT|TOP", -160, 180)
    down_img:setSprite("up_btn_spr")
    self:attach(down_img)

    local scroll_down_area = Area("scrollDownArea")
    scroll_down_area:setRect(0, 0, 100, 20)
    scroll_down_area:setAlignment("RIGHT|TOP", -160, 180)
    scroll_down_area:addCallback("MouseOver", self.scrollTo, {self, "Down", true})
    scroll_down_area:addCallback("MouseLeft", self.scrollTo, {self, "Down", false})
    self:attach(scroll_down_area)

    self.test_dlg = TestDialog()
    self:attach(self.test_dlg)
end

function TestWidgetsScreen.onTextEdited(params)
    -- local self = params[1]
    -- local edit = params[2]
    -- log(edit:getText())
end

function TestWidgetsScreen.scrollTo(params)
    local screen = params[1]
    local direction = params[2]
    local value = params[3]
    if (screen and screen.scroll_cnt) then
        screen.scroll_cnt:enableScroll(direction, value)
    end
end

function TestWidgetsScreen:onBackBtnClick()
    Screens.load("LoadingScreen", "TestScreen")
end

function TestWidgetsScreen:onLockBtnClick()
    if (self.exit_lbl) then
        self.exit_lbl:view(not self.exit_lbl:isOpened())
    end
end

function TestWidgetsScreen:onWindBtnClicked()
    local toValue = 100
    if (self.pb1) then
        local value = self.pb1:getCurrentValue()
        if (100 == value) then
            toValue = 0
            self.pb1:windTo(toValue)
        elseif (0 == value) then
            toValue = 100
            self.pb1:windTo(toValue)
        end
    end

    if (self.pb2) then
        local value = self.pb2:getCurrentValue()
        if (100 == value) then
            toValue = 0
            self.pb2:windTo(toValue)
        elseif (0 == value) then
            toValue = 100
            self.pb2:windTo(toValue)
        end
    end
end

function TestWidgetsScreen:onMoveCntBtnClick()
    if (self.widget_cnt) then
        self.widget_cnt:moveTo(600, 328)
    end
end

function TestWidgetsScreen.onResizeBtnClick(tbl)
    local self = tbl[1]
    local increment = tbl[2]
    if (self.multiline_lbl) then
        local x, y, w, h = self.multiline_lbl:getRect()
        self.multiline_lbl:setRect(x, y, w + increment, h)
    end
end

function TestWidgetsScreen:onButtonInContainerClick()
    if (self.test_dlg) then
        self.test_dlg:view(not self.test_dlg:isOpened())
    end
end