class "ConsolePanel" (Dialog)

function ConsolePanel:init()
    self.labels = {}
    self.stack = {}

    local screen_width = Engine.getScreenWidth()
    local screen_height = Engine.getScreenHeight()
    local dialog_height = screen_height / 2

    local back_img = Image()
    back_img:setRect(0, 0, screen_width, dialog_height)
    back_img:setSprite("dark_img_spr")
    self:attach(back_img)

    local primitive = Primitive()
    primitive:createLines({ { 0, 0 },{ screen_width, 0 } })
    primitive:moveBy(0, dialog_height)
    primitive:setColour("green")
    self:attach(primitive)

    local label_height = 16
    local labels_amount = dialog_height / label_height
    for i = 1, labels_amount do
        local lbl = Label()
        lbl:setRect(0, (i - 1) * label_height, screen_width, label_height)
        lbl:setColour("white")
        lbl:setTextAlignment("LEFT|TOP")
        lbl:setFont("system_15_fnt")
        self:attach(lbl)
        table.insert(self.labels, lbl)
        self.stack[i] = ""
    end
end

function ConsolePanel:log(...)
    local args = {...}
    local format = ""
    for i = 1, #args do
        args[i] = tostring(args[i])
        format = format .. "%s "
    end
    local new_value = string.format(format, unpack(args))
    for i = #self.stack, 1, -1 do
        local old_value = self.stack[i]
        self.stack[i] = new_value
        new_value = old_value
    end

    for i, lbl in ipairs(self.labels) do
        Label.setText(lbl, self.stack[i])
    end
end