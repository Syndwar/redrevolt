require('containers/inventory_slot')

class "FloorSlot" (Container)

function FloorSlot:init()
--     self.entity = nil

--     self:setRect(0, 0, 200, 40)

--     self.back_img = Image()
--     self.back_img:setSprite("up_btn_spr")
--     self.back_img:setRect(40, y, 200, 40)
--     self:attach(self.back_img)

--     self.select_btn = Button("selectBtn")
--     self.select_btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr", "up_btn_spr")
--     self.select_btn:setRect(0, y, 40, 40)
--     self.select_btn:addCallback("MouseUp_Left", self.onSelectItemsBtnClick, self)
--     self:attach(self.select_btn)

--     self.icon_img = Image()
--     self.icon_img:setRect(40, y, 40, 40)
--     self:attach(self.icon_img)

--     self.name_lbl = Label()
--     self.name_lbl:setTextAlignment("LEFT|MIDDLE")
--     self.name_lbl:setFont("system_15_fnt")
--     self.name_lbl:setColour("black")
--     self.name_lbl:setRect(90, y, 150, 40)
--     self:attach(self.name_lbl)
   
--     UIBuilder.create(self, __getSlotUIDesc(self))
end

-- function FloorSlot:update(entity)
--     self.entity = entity

--     self.select_btn:enable(nil ~= entity)
--     self.name_lbl:view(nil ~= entity)
--     self.icon_img:view(nil ~= entity)

--     if (entity) then
--         self.icon_img:setSprite(entity:getSprite())
--         self.name_lbl:setText(entity.settings.name)
--     end
-- end

local kInventorySlots = 4
local kSlotIdTemplate = "slot_%d_cnt"

class "InventoryDialog" (Dialog)

local function __getUIDesc(self)
    local tbl = {
        {
            widget = "Image",
            rect = {0, 0, 500, 700},
            sprite = "dark_img_spr",
        },
        {
            widget = "Label",
            rect = {0, 10, 500, 15},
            text = "Inventory", font = "system_15_fnt", colour = "red", text_align = "CENTER|MIDDLE",
        },
        {
            widget = "Button",
            rect = {186, 668, 128, 32},
            text = "Ok", font = "system_15_fnt", colour = "white", text_align = "CENTER|MIDDLE",
            sprites = {"up_btn_spr", "down_btn_spr", "over_btn_spr"},
            callback = {"MouseUp_Left", self.__closeDialog, self},
        },
        {
            id = "slot1Cnt", widget = "InventorySlot", ui = "slot_1_cnt",
            rect = {150, 40, 275, 40},
        },
        {
            id = "slot2Cnt", widget = "InventorySlot", ui = "slot_2_cnt",
            rect = {150, 90, 275, 40},
        },
        {
            id = "slot3Cnt", widget = "InventorySlot", ui = "slot_3_cnt",
            rect = {150, 140, 275, 40},
        },
        {
            id = "slot4Cnt", widget = "InventorySlot", ui = "slot_4_cnt",
            rect = {150, 190, 275, 40},
        },
        {
            id = "floorCnt", widget = "ScrollContainer", ui = "floor_cnt",
            rect = {150, 280, 240, 320}, scroll_speed = 500,
        }
    }
    return tbl
end

function InventoryDialog:init()
    local open_transform = Transform()
    open_transform:add(0, 255, 500)
    self:attachTransform("WidgetOpening", open_transform)

    local close_transform = Transform()
    close_transform:add(255, 0, 500)
    self:attachTransform("WidgetClosing", close_transform)

    self:setModal(true)
    self:setRect(0, 0, 500, 700)
    self:setAlignment("CENTER|MIDDLE", 0, 0)

    self._content = nil

    UIBuilder.create(self, __getUIDesc(self))
end

-- [[ Private ]]
function InventoryDialog:__closeDialog()
    Observer:call("UpdateInventory", self._content)
    self:view(false)
end

function InventoryDialog:__updateInventory(content)
    for i = 1, kInventorySlots do
        local slot = self:getUI(string.format(kSlotIdTemplate, i))
        local data = content and content[i]
        if (slot) then
            if (data) then
                local entity = EntityHandler.new(data:getId())
                if (entity) then
                    slot:setName(entity:getName())
                    slot:setIcon(entity:getSprite())
                end
            else
                slot:setName("")
                slot:setIcon("")
            end
        end
    end
end

function InventoryDialog:__updateGround(content)
    local floor_cnt = self:getUI("floor_cnt")
    if (floor_cnt) then
        floor_cnt:detachAll()
        local x, y = floor_cnt:getRect()
        for i, data in ipairs(content) do
            local entity = EntityHandler.new(data:getId())
            if (entity) then
                local slot = InventorySlot()
                slot:setIcon(entity:getSprite())
                slot:setName(entity:getName())
                slot:moveTo(x, y + (i - 1) * 50)
                floor_cnt:attach(slot)
            end

        end
        local content_width = 275
        local content_height = content and (50 * #content) or 0
        floor_cnt:setContentRect(0, 0, content_width, content_height)
    end
end

-- [[ Public ]]
function InventoryDialog:tune(content)
    self._content = content
    self:__updateInventory(self._content["inventory"])
    self:__updateGround(self._content["ground"])
end

-- function InventoryDialog:updateUnitSlots()
--     for i = #self.slots, 1, -1 do
--         local inventory = self.entity.inventory
--         local entity = inventory and inventory[i]
--         local slot = self.slots[i]
--         slot:update(entity)
--     end
-- end

-- function InventoryDialog:updateFloorSlots()

-- end

-- function InventoryDialog:createFloorContainers()

-- end

-- function InventoryDialog:onAddEntity(entity)
--     if (entity) then
--         if (not self.entity.inventory) then
--             self.entity.inventory = {}
--         end
--         if (#self.entity.inventory < kInventorySlots) then
--             table.insert(self.entity.inventory, entity)
--             Observer:call("DeleteEntity", nil, entity)
--             self:updateUnitSlots()
--             self:updateFloorSlots()
--         end
--     end
-- end

-- function InventoryDialog:onRemoveEntity(entity)
--     if (entity) then
--         local inventory = self.entity.inventory
--         if (inventory) then
--             for i, inventory_entity in ipairs(inventory) do
--                 if (inventory_entity == entity) then
--                     table.remove(inventory, i)
--                     break
--                 end
--             end
--             Observer:call("AddEntity", entity, self.entity.pos[1], self.entity.pos[2])
--             self:updateUnitSlots()
--             self:updateFloorSlots()
--         end
--     end
-- end