class "MapEditorInfoPanel" (Container)

local function __getUIDesc(self)
    local tbl = {
        {
            id = "selectedImg", widget = "Image", ui = "selected_img",
            rect = {0, 0, 32, 32},
            angle = 0, center = {16, 16},
        },
        {
            id = "selectedLbl", widget = "Label", ui = "selected_lbl",
            rect = {40, 0, 200, 32},
            colour = "white", font = "system_15_fnt", text_align = "LEFT|MIDDLE",
        },
    }
    for i = 1, 6 do
        local slot_lbl_tbl = {
            id = string.format("slot%dLbl", i), widget = "Label", ui = string.format("slot_%d_lbl", i),
            rect = {240 + (i - 1) * 80, 8, 30, 15},
            colour = "white", font = "system_15_fnt", text_align = "LEFT|MIDDLE",
        }
        local value_lbl_tbl = {
            id = string.format("value%dLbl", i), widget = "Label", ui = string.format("value_%d_lbl", i),
            rect = {270 + (i - 1) * 80, 8, 50, 15},
            colour = "white", font = "system_15_fnt", text_align = "LEFT|MIDDLE",
        },
        table.insert(tbl, slot_lbl_tbl)
        table.insert(tbl, value_lbl_tbl)
    end
    return tbl
end


function MapEditorInfoPanel:init()
    Observer:addListener("EntityChanged", self, self.__onEntityChanged)
    Observer:addListener("EntityRotated", self, self.__onEntityRotated)
    Observer:addListener("EntityFlipped", self, self.__onEntityFlipped)

    UIBuilder.create(self, __getUIDesc(self))

    self:__closeSlots()
end

function MapEditorInfoPanel:__closeSlots()
    for i = 1, 6 do
        self:__viewSlot(i, false, nil, nil)
    end
end

function MapEditorInfoPanel:__viewSlot(index, show, slot_text, value_text)
    local slot_lbl = self:getUI(string.format("slot_%d_lbl", index))
    if (slot_lbl) then
        slot_lbl:instantView(show)
        if (slot_text) then
            slot_lbl:setText(slot_text)
        end
    end
    local value_lbl = self:getUI(string.format("value_%d_lbl", index))
    if (value_lbl) then
        value_lbl:instantView(show)
        if (value_text) then
            value_lbl:setText(value_text)
        end
    end
end

function MapEditorInfoPanel:__onEntityChanged(entity)
    self:__closeSlots()
    self:__update(entity)
end

function MapEditorInfoPanel:__onEntityFlipped(flip)
    if (flip) then
        local selected_img = self:getUI("selected_img")
        if (selected_img) then
            selected_img:setFlip(unpack(flip))
        end
    end
end

function MapEditorInfoPanel:__onEntityRotated(angle)
    if (angle) then
        local selected_img = self:getUI("selected_img")
        if (selected_img) then
            selected_img:setAngle(angle)
        end
    end
end

function MapEditorInfoPanel:__update(entity)
    local selected_img = self:getUI("selected_img")
    if (selected_img) then
        selected_img:instantView(nil ~= entity)
        if (entity) then
            selected_img:setSprite(entity:getSprite())
            selected_img:setAngle(entity:getAngle())
            selected_img:setFlip(unpack(entity:getFlip()))
        end
    end
    local selected_lbl = self:getUI("selected_lbl")
    if (selected_lbl) then
        selected_lbl:instantView(nil ~= entity)
        if (entity) then
            selected_lbl:setText(entity:getId())
        end
    end
    local info = entity and entity:getInfo()
    if (info) then
        for i, v in ipairs(info) do
            self:__viewSlot(i, true, v[1], v[2])
        end
    end    
end