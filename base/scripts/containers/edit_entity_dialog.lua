class "EditEntityDialog" (Dialog)

local function __getUIDesc(self)
    return 
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
        {
            id = "slot1Cnt", widget = "Container", ui = "slot_1_cnt",
            attached = {
                {
                    id = "slotNameLbl", widget = "Label", ui = "slot_name_lbl",
                    rect = {10, 50, 100, 15},
                    font = "system_15_fnt", colour = "blue", text_align = "LEFT|MIDDLE",
                }
            }
        }
    }
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

    self:addCallback("WidgetOpening", self.__onOpening, self)

    UIBuilder.create(self, __getUIDesc(self))

    -- local cnt = self

    -- local faction_lbl = Label()
    -- faction_lbl:setRect(10, 30, 100, 15)
    -- faction_lbl:setText("Faction:")
    -- faction_lbl:setFont("system_15_fnt")
    -- faction_lbl:setColour("blue")
    -- faction_lbl:setTextAlignment("LEFT|MIDDLE")
    -- cnt:attach(faction_lbl)

    -- local faction_value_lbl = Label()
    -- faction_value_lbl:setRect(115, 30, 100, 15)
    -- faction_value_lbl:setFont("system_15_fnt")
    -- faction_value_lbl:setColour("white")
    -- faction_value_lbl:setTextAlignment("LEFT|MIDDLE")
    -- cnt:attach(faction_value_lbl)

    -- local params = {
    --     {text = "Name:", slots = {"name"}},
    --     {text = "Morale:", slots = {"morale_cur", "morale_max"}},
    --     {text = "Stamina:", slots = {"stamina_cur", "stamina_max"}},
    --     {text = "Health:", slots = {"health_cur", "health_max"}},
    --     {text = "Armour:", slots = {"armour"}},
    --     {text = "Action Points:", slots = {"action_points_cur", "action_points_max"}},
    --     {text = "Weapon Skill:", slots = {"weapon_skill"}},
    -- }

    -- local params_bottom = 0
    -- for i, data in ipairs(params) do
    --     local lbl = Label()
    --     lbl:setRect(10, 50 + (i - 1) * 20, 100, 15)
    --     lbl:setText(data.text)
    --     lbl:setFont("system_15_fnt")
    --     lbl:setColour("blue")
    --     lbl:setTextAlignment("LEFT|MIDDLE")
    --     cnt:attach(lbl)

    --     for j, key in ipairs(data.slots) do
    --         local edit = TextEdit(key)

    --         local x = 115 + (j - 1) * 100
    --         local y = 50 + (i - 1) * 20
    --         params_bottom = y + 20

    --         edit:setRect(x, y, 50, 15)
    --         edit:setFont("system_15_fnt")
    --         edit:setColour("white")
    --         edit:setTextAlignment("LEFT|MIDDLE")
    --         cnt:attach(edit)
    --         if (#data.slots > 1 and 1 == j) then
    --             local lbl = Label()
    --             lbl:setRect(165, y, 50, 15)
    --             lbl:setText("/")
    --             lbl:setFont("system_15_fnt")
    --             lbl:setColour("white")
    --             lbl:setTextAlignment("CENTER|MIDDLE")
    --             cnt:attach(lbl)
    --         end
    --     end
    -- end

    -- for i, value in ipairs(Factions) do
    --     local faction_btn = Button()
    --     faction_btn:setText(value)
    --     faction_btn:setFont("system_15_fnt")
    --     faction_btn:setRect(10 + (i - 1) * 120 , params_bottom, 120, 20)
    --     faction_btn:setTextAlignment("CENTER|MIDDLE")
    --     faction_btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    --     faction_btn:addCallback("MouseUp_Left", self.__onFactionBtnClick, {self, value})
    --     faction_btn:setColour("white")
    --     cnt:attach(faction_btn)
    -- end
end

--[[ Private ]]

function EditEntityDialog:__onOkBtnClick()
    self:view(false)
    -- local settings = self.entity.settings
    -- if (settings) then
    --     for key, widget in pairs(self.current_map) do
    --         local text = widget:getText()
    --         settings[key] = tonumber(text) or text
    --     end
    -- end
end

function EditEntityDialog:__onCancelBtnClick()
    self:view(false)
end

function EditEntityDialog:__onOpening()
    -- if (self.entity) then
    --     local settings = self.entity.settings
    --     if (settings) then
    --         for key, value in pairs(settings) do
    --             if (self.current_map[key]) then
    --                 self.current_map[key]:setText(value)
    --             end
    --         end
    --     end
    -- end
end

-- function EditEntityDialog.__onFactionBtnClick(params)
--     local self = params[1]
--     local value = params[2]
--     local widget = self.current_map["faction"]
--     if (widget) then
--         widget:setText(value)
--     end
-- end

--[[ Public ]]

function EditEntityDialog:tune(params)
    -- self.type = GameData.getEntityType(entity.id)

    -- for _, cnt_id in ipairs(self.cnt_list) do
    --     local cnt = self.containers[cnt_id]
    --     if (cnt) then
    --         cnt:view(cnt_id == self.type)
    --     end
    -- end

    -- self.current_map = self.maps[self.type]
end