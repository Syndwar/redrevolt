class "SaveLoadDialog" (Dialog)

local function __getUIDesc(self)
    return 
    {
        {
            widget = "Image",
            rect = {0, 0, 500, 700},
            sprite = "dark_img_spr",
        },
        {
            id = "fileNameInput", widget = "TextEdit", ui = "file_name_input",
            rect = {50, 10, 400, 30},
            text = "new_map", colour = "white", font = "system_24_fnt",
        },
        {
            widget = "Label",
            rect = {50, 50, 400, 30},
            text = "Maps in folder:", colour = "green", font = "system_15_fnt", text_align = "CENTER|MIDDLE",
        },
        {
            id = "folderCnt", widget = "ScrollContainer", ui = "folder_cnt",
            rect = {50, 80, 400, 520},
        },
        {
            id = "okBtn", widget = "Button",
            rect = {100, 636, 64, 64},
            text = "OK", font = "system_15_fnt", colour = "white", text_align = "CENTER|MIDDLE",
            sprites = {"up_btn_spr", "down_btn_spr", "over_btn_spr"},
            callback = {"MouseUp_Left", self.__onOkBtnClick, self},
        },
        {
            id = "cancelBtn", widget = "Button",
            rect = {336, 636, 64, 64},
            text = "Cancel", font = "system_15_fnt", colour = "white", text_align = "CENTER|MIDDLE",
            sprites = {"up_btn_spr", "down_btn_spr", "over_btn_spr"},
            callback = {"MouseUp_Left", self.__onCancelBtnClick, self},
        },
    }
end

function SaveLoadDialog:init()
    self._is_save = true
    self._files = nil

    local open_transform = Transform()
    open_transform:add(0, 255, 500)
    self:attachTransform("WidgetOpening", open_transform)

    local close_transform = Transform()
    close_transform:add(255, 0, 500)
    self:attachTransform("WidgetClosing", close_transform)

    self:setModal(true)
    self:setRect(0, 0, 500, 700)
    self:setAlignment("CENTER|MIDDLE", 0, 0)

    self:addCallback("WidgetOpening", self.__onOpening, self)

    UIBuilder.create(self, __getUIDesc(self))
end

function SaveLoadDialog:__onOpening()
    -- Config.map_folder
    local folder_cnt = self:getUI("folder_cnt")
    if (folder_cnt) then
        local x, y = folder_cnt:getRect()
        local i = 0
        folder_cnt:detachAll()
        local files = self._files or {}
        for file in files do
            if (0 ~= string.find(file, "%.map")) then
                local btn = Button()
                btn:setText(string.gsub(file, "%.map", ""))
                btn:setFont("system_15_fnt")
                btn:setRect(x, y + i * 30, 400, 30)
                btn:setTextAlignment("CENTER|MIDDLE")
                btn:addCallback("MouseUp_Left", self.__onScrollerRowClick, {self, btn})
                btn:setColour("white")
                folder_cnt:attach(btn)
                i = i + 1
            end
        end
    end
end

function SaveLoadDialog:__onOkBtnClick()
    self:view(false)
    if (self._is_save) then
        Observer:call("SaveMapFile", self:__getMapFile())
    else
        Observer:call("LoadMapFile", nil, self:__getMapFile())
    end
end

function SaveLoadDialog:__onCancelBtnClick()
    self:view(false)
end

function SaveLoadDialog.__onScrollerRowClick(params)
    local self = params[1]
    local file_name_input = self:getUI("file_name_input")
    if (file_name_input) then
        local btn = params[2]
        local text = btn:getText()
        file_name_input:setText(text)
    end
end

function SaveLoadDialog:__getMapFile()
    local file_name_input = self:getUI("file_name_input")
    if (file_name_input) then
        return file_name_input:getText()
    end
    return ""
end

function SaveLoadDialog:switchToLoad()
    self._is_save = false
end

function SaveLoadDialog:switchToSave()
    self._is_save = true
end

function SaveLoadDialog:setFiles(files)
    self._files = files
end