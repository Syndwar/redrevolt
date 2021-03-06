local function __getUIDesc(self)
    local tbl = {
        {
            widget = "Image",
            rect = {45, 0, 230, 40},
            sprite = "up_btn_spr",
        },
        {
            id = "selectBtn", widget = "Button", ui = "select_btn",
            rect = {0, 0, 40, 40},
            sprites = {"up_btn_spr", "down_btn_spr", "over_btn_spr"},
            callback = {"MouseUp_Left", self.__selectSlot, self},
        },
        {
            id = "iconImg", widget = "Image", ui = "icon_img",
            rect = {45, 0, 40, 40},
            sprite = "up_btn_spr",
        },
        {
            id = "nameLbl", widget = "Label", ui = "name_lbl",
            rect = {95, 0, 150, 40},
            text = "", font = "system_15_fnt", colour = "white", text_align = "LEFT|MIDDLE",
        },
    }
    return tbl
end

class "InventorySlot" (Container)

function InventorySlot:init()
    UIBuilder.create(self, __getUIDesc(self))
end

-- [[ Private ]]

function InventorySlot:__selectSlot()
end

-- [[ Public ]]
function InventorySlot:setName(name)
    local lbl = self:getUI("name_lbl")
    if (lbl) then
        lbl:setText(name)
    end
end

function InventorySlot:setIcon(icon_id)
    local img = self:getUI("icon_img")
    if (img) then
        img:setSprite(icon_id)
    end
end