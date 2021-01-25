class "NotificationDialog" (Dialog)

function NotificationDialog:init()
    local open_transform = Transform()
    open_transform:add(0, 255, 500)
    self:attachTransform("WidgetOpening", open_transform)

    local close_transform = Transform()
    close_transform:add(255, 0, 500)
    self:attachTransform("WidgetClosing", close_transform)

    local screen_width = Engine.getScreenWidth()
    local screen_height = Engine.getScreenHeight()

    self:setRect(0, 0, screen_width, screen_height)
    self:setModal(true)

    img = Image()
    img:setRect(0, 0, 300, 100)
    img:setSprite("dark_img_spr")
    img:setAlignment("CENTER|MIDDLE", 0, 0)
    self:attach(img)

    self.message = Label()
    self.message:setRect(0, 0, 100, 30)
    self.message:setAlignment("CENTER|MIDDLE", 0, 0)
    self.message:setFont("system_15_fnt")
    self.message:setColour("white")
    self.message:setTextAlignment("CENTER|MIDDLE")
    self:attach(self.message)

    local close_btn = Button()
    close_btn:setRect(0, 0, screen_width, screen_height)
    close_btn:setAlignment("CENTER|MIDDLE", 0, 0)
    close_btn:addCallback("MouseUp_Left", self.onCloseBtnClick, self)
    self:attach(close_btn)
end

function NotificationDialog:setMessage(msg)
    self.message:setText(msg)
end

function NotificationDialog:onCloseBtnClick()
    self:view(false)
end