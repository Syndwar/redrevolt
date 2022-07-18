class "NotificationDialog" (Dialog)

local function __getUIDesc(self)
    return 
    {
        {
            widget = "Image",
            rect = {0, 0, 300, 100},
            sprite = "dark_img_spr",
            alignment = {"CENTER|MIDDLE", 0, 0},
        },
        {
            widget = "Label", ui = "message_lbl",
            rect = {0, 0, 100, 30},
            alignment = {"CENTER|MIDDLE", 0, 0},
            text = "no text", colour = "white", font = "system_15_fnt", text_align = "CENTER|MIDDLE",
        },
        {
            widget = "Button",
            rect = {0, 0, Engine.getScreenWidth(), Engine.getScreenHeight()},
            alignment = {"CENTER|MIDDLE", 0, 0},
            callback = {"MouseUp_Left", self.__onCloseBtnClick, self},
        },
    }
end

function NotificationDialog:init()
    local open_transform = Transform()
    open_transform:add(0, 255, 500)
    self:attachTransform("WidgetOpening", open_transform)

    local close_transform = Transform()
    close_transform:add(255, 0, 500)
    self:attachTransform("WidgetClosing", close_transform)

    self:setRect(0, 0, Engine.getScreenWidth(), Engine.getScreenHeight())
    self:setModal(true)

    UIBuilder.create(self, __getUIDesc(self))
end

function NotificationDialog:__onCloseBtnClick()
    self:view(false)
end

function NotificationDialog:setMessage(msg)
    local message_lbl = self:getUI("message_lbl")
    if (message_lbl) then
        message_lbl:setText(msg)
    end
end

function NotificationDialog:__onCloseBtnClick()
    self:view(false)
end