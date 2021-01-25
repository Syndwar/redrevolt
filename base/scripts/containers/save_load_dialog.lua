class "SaveLoadDialog" (Dialog)

function SaveLoadDialog:init()
    self.is_save = true

    local open_transform = Transform()
    open_transform:add(0, 255, 500)
    self:attachTransform("WidgetOpening", open_transform)

    local close_transform = Transform()
    close_transform:add(255, 0, 500)
    self:attachTransform("WidgetClosing", close_transform)

    self:setModal(true)
    self:setRect(0, 0, 500, 700)
    self:setAlignment("CENTER|MIDDLE", 0, 0)

    self:addCallback("WidgetOpening", self.onOpening, self)

    local screen_width = Engine.getScreenWidth()
    local screen_height = Engine.getScreenHeight()

    img = Image()
    img:setRect(0, 0, 500, 700)
    img:setSprite("dark_img_spr")
    self:attach(img)

    self.file_input = TextEdit("fileNameInput")
    self.file_input:setRect(50, 10, 400, 30)
    self.file_input:setText("new_map")
    self.file_input:setColour("white")
    self.file_input:setFont("system_24_fnt")
    self:attach(self.file_input)

    local lbl = Label()
    lbl:setRect(50, 50, 400, 30)
    lbl:setText("Maps in folder:")
    lbl:setFont("system_15_fnt")
    lbl:setColour("green")
    lbl:setTextAlignment("CENTER|MIDDLE")
    self:attach(lbl)

    self.folder_cnt = ScrollContainer("folderCnt")
    self.folder_cnt:setRect(50, 80, 400, 520)
    self:attach(self.folder_cnt)

    local btn = Button("okBtn")
    btn:setText("Ok")
    btn:setFont("system_15_fnt")
    btn:setRect(100, 636, 64, 64)
    btn:setTextAlignment("CENTER|MIDDLE")
    btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    btn:addCallback("MouseUp_Left", self.onOkBtnClick, self)
    btn:setColour("white")
    self:attach(btn)

    btn = Button("cancelBtn")
    btn:setText("Cancel")
    btn:setFont("system_15_fnt")
    btn:setRect(336, 636, 64, 64)
    btn:setTextAlignment("CENTER|MIDDLE")
    btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    btn:addCallback("MouseUp_Left", self.onCancelBtnClick, self)
    btn:setColour("white")
    self:attach(btn)
end

function SaveLoadDialog:onOpening()
    -- Config.map_folder
    local command = string.format("dir \"%s\" /b", Config.map_folder)
    local x, y = self.folder_cnt:getRect()
    local i = 0
    self.folder_cnt:detachAll()
    for dir in io.popen(command):lines() do
        if (0 ~= string.find(dir, "%.map")) then
            local btn = Button()
            btn:setText(string.gsub(dir, "%.map", ""))
            btn:setFont("system_15_fnt")
            btn:setRect(x, y + i * 30, 400, 30)
            btn:setTextAlignment("CENTER|MIDDLE")
            btn:addCallback("MouseUp_Left", self.onScrollerRowClick, {self, btn})
            btn:setColour("white")
            self.folder_cnt:attach(btn)
            i = i + 1
        end
    end
end

function SaveLoadDialog:onOkBtnClick()
    self:view(false)
    if (self.is_save) then
        Observer:call("SaveEditorMap", self:getMapFile())
    else
        Observer:call("LoadEditorMap", nil, self:getMapFile())
    end
end

function SaveLoadDialog:onCancelBtnClick()
    self:view(false)
end

function SaveLoadDialog:setMapFile(file)
    if (file) then
        self.file_input:setText(file)
    end
end

function SaveLoadDialog:getMapFile()
    return self.file_input:getText()
end

function SaveLoadDialog:switchToLoad()
    self.is_save = false
end

function SaveLoadDialog:switchToSave()
    self.is_save = true
end

function SaveLoadDialog.onScrollerRowClick(params)
    local self = params[1]
    local btn = params[2]
    local text = btn:getText()
    self.file_input:setText(text)
end