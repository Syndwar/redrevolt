class "EditEntityDialog" (Dialog)

local kSlotIdTemplate = "slot_%d_cnt"
local kMaxSlotsCount = 12

local function __getUIDesc(self)
    local tbl = 
    {
        {
            widget = "Image",
            rect = {0, 0, 500, 700},
            sprite = "dark_img_spr",
        },
        {
            id = "okBtn", widget = "Button",
            rect = {100, 636, 64, 64},
            text = "Ok", colour = "white", font = "system_15_fnt", text_align = "CENTER|MIDDLE",
            sprites = {"up_btn_spr", "down_btn_spr", "over_btn_spr"},
            callback = {"MouseUp_Left", self.__onOkBtnClick, self},
        },
        {
            id = "cancelBtn", widget = "Button",
            rect = {336, 636, 64, 64},
            text = "Cancel", colour = "white", font = "system_15_fnt", text_align = "CENTER|MIDDLE",
            sprites = {"up_btn_spr", "down_btn_spr", "over_btn_spr"},
            callback = {"MouseUp_Left", self.__onCancelBtnClick, self},
        },
        {
            widget = "Label",
            rect = {0, 10, 500, 15},
            text = "Edit Settings", colour = "red", font = "system_15_fnt", 
        },
    }

    for i = 1, kMaxSlotsCount do
        local slot_cnt = 
        {
            id = string.format("slot%dCnt", i), widget = "Container", ui = string.format(kSlotIdTemplate, i),
            attached = {
                {
                    id = "slotNameLbl", widget = "Label", ui = "slot_name_lbl",
                    text = "ID",
                    rect = {10, 50 + (i - 1) * 20, 100, 15},
                    font = "system_15_fnt", colour = "blue", text_align = "LEFT|MIDDLE",
                },
                {
                    id = "curValueInput", widget = "TextEdit", ui = "cur_value_input",
                    text = "VALUE1",
                    rect = {115, 50 + (i - 1) * 20, 50, 15},
                    font = "system_15_fnt", colour = "white", text_align = "LEFT|MIDDLE",
                },
                {
                    id = "dividerLbl", widget = "Label", ui = "divider_lbl",
                    text = "/",
                    rect = {165, 50 + (i - 1) * 20, 50, 15},
                    font = "system_15_fnt", colour = "white", text_align = "CENTER|MIDDLE",
                },
                {
                    id = "maxValueInput", widget = "TextEdit", ui = "max_value_input",
                    text = "VALUE2",
                    rect = {215, 50 + (i - 1) * 20, 50, 15},
                    font = "system_15_fnt", colour = "white", text_align = "LEFT|MIDDLE",
                },
            }
        }
        table.insert(tbl, slot_cnt)
    end
    return tbl
end

function EditEntityDialog:init()
    local open_transform = Transform()
    open_transform:add(0, 255, 500)
    self:attachTransform("WidgetOpening", open_transform)

    local close_transform = Transform()
    close_transform:add(255, 0, 500)
    self:attachTransform("WidgetClosing", close_transform)

    self:setModal(true)
    self:setRect(0, 0, 500, 700)
    self:setAlignment("CENTER|MIDDLE", 0, 0)

    UIBuilder.create(self, __getUIDesc(self))
end

--[[ Private ]]

function EditEntityDialog:__onOkBtnClick()
    self:__applyChanges()
    self:view(false)
end

function EditEntityDialog:__onCancelBtnClick()
    self:view(false)
end

function EditEntityDialog:__applyChanges()
end

--[[ Public ]]

function EditEntityDialog:tune(params)
    for i = 1, kMaxSlotsCount do
        local slot_id = string.format(kSlotIdTemplate, i)
        local cnt = self:getUI(slot_id)
        if (cnt) then
            local param = params and params[i]
            cnt:view(nil ~= param)
            if (param) then
                local id_lbl = cnt:getUI("slot_name_lbl")
                id_lbl:setText(param[1])
                
                local cur_value_input = cnt:getUI("cur_value_input")
                cur_value_input:view(nil ~= param[2])
                if (param[2]) then
                    cur_value_input:setText(param[2])
                end

                local divider_lbl = cnt:getUI("divider_lbl")
                divider_lbl:view(nil ~= param[3])
                
                local max_value_input = cnt:getUI("max_value_input")
                max_value_input:view(nil ~= param[3])
                if (param[3]) then
                    max_value_input:setText(param[3])
                end
            end
        end
    end
end