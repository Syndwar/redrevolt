class "InventorySlot" (Container)

function InventorySlot:init()
    self.entity = nil

    self:setRect(0, 0, 200, 40)

    self.back_img = Image()
    self.back_img:setSprite("up_btn_spr")
    self.back_img:setRect(40, y, 200, 40)
    self:attach(self.back_img)

    self.select_btn = Button("selectBtn")
    self.select_btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr", "up_btn_spr")
    self.select_btn:setRect(0, y, 40, 40)
    self.select_btn:addCallback("MouseUp_Left", self.onSelectItemsBtnClick, self)
    self:attach(self.select_btn)

    self.icon_img = Image()
    self.icon_img:setRect(40, y, 40, 40)
    self:attach(self.icon_img)

    self.name_lbl = Label()
    self.name_lbl:setTextAlignment("LEFT|MIDDLE")
    self.name_lbl:setFont("system_15_fnt")
    self.name_lbl:setColour("black")
    self.name_lbl:setRect(90, y, 150, 40)
    self:attach(self.name_lbl)
end

function InventorySlot:onSelectItemsBtnClick()
    Observer:call("InventoryRemove", self.entity)
end

function InventorySlot:update(entity)
    self.entity = entity

    self.select_btn:enable(nil ~= entity)
    self.name_lbl:view(nil ~= entity)
    self.icon_img:view(nil ~= entity)

    if (entity) then
        self.icon_img:setSprite(GameData.getSprite(entity.id))
        self.name_lbl:setText(entity.settings.name)
    end
end

class "FloorSlot" (Container)

function FloorSlot:init()
    self.entity = nil

    self:setRect(0, 0, 200, 40)

    self.back_img = Image()
    self.back_img:setSprite("up_btn_spr")
    self.back_img:setRect(40, y, 200, 40)
    self:attach(self.back_img)

    self.select_btn = Button("selectBtn")
    self.select_btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr", "up_btn_spr")
    self.select_btn:setRect(0, y, 40, 40)
    self.select_btn:addCallback("MouseUp_Left", self.onSelectItemsBtnClick, self)
    self:attach(self.select_btn)

    self.icon_img = Image()
    self.icon_img:setRect(40, y, 40, 40)
    self:attach(self.icon_img)

    self.name_lbl = Label()
    self.name_lbl:setTextAlignment("LEFT|MIDDLE")
    self.name_lbl:setFont("system_15_fnt")
    self.name_lbl:setColour("black")
    self.name_lbl:setRect(90, y, 150, 40)
    self:attach(self.name_lbl)
end

function FloorSlot:onSelectItemsBtnClick()
    Observer:call("InventoryAdd", self.entity)
end

function FloorSlot:update(entity)
    self.entity = entity

    self.select_btn:enable(nil ~= entity)
    self.name_lbl:view(nil ~= entity)
    self.icon_img:view(nil ~= entity)

    if (entity) then
        self.icon_img:setSprite(GameData.getSprite(entity.id))
        self.name_lbl:setText(entity.settings.name)
    end
end

class "InventoryDialog" (Dialog)

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

    self:addCallback("WidgetOpening", self.onOpening, self)

    Observer:addListener("InventoryRemove", self, self.onRemoveEntity)
    Observer:addListener("InventoryAdd", self, self.onAddEntity)

    self.number_of_slots = 4
    self.entity = nil

    img = Image()
    img:setRect(0, 0, 500, 700)
    img:setSprite("dark_img_spr")
    self:attach(img)

    local btn = Button("okBtn")
    btn:setText("Ok")
    btn:setFont("system_15_fnt")
    btn:setRect(218, 636, 64, 64)
    btn:setTextAlignment("CENTER|MIDDLE")
    btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    btn:addCallback("MouseUp_Left", self.onOkBtnClick, self)
    btn:setColour("white")
    self:attach(btn)

    local lbl = Label()
    lbl:setRect(0, 10, 500, 15)
    lbl:setText("Inventory")
    lbl:setFont("system_15_fnt")
    lbl:setColour("red")
    lbl:setTextAlignment("CENTER|MIDDLE")
    self:attach(lbl)

    self.slots = {}
    self.floor_slots = {}

    self:createUnitContainers()
    self:createFloorContainers()
end

function InventoryDialog:onOkBtnClick()
    self:view(false)
end

function InventoryDialog:tune(entity)
    self.entity = entity
end

function InventoryDialog:onOpening()
    self:updateUnitSlots()
    self:updateFloorSlots()
end

function InventoryDialog:updateUnitSlots()
    for i = #self.slots, 1, -1 do
        local inventory = self.entity.inventory
        local entity = inventory and inventory[i]
        local slot = self.slots[i]
        slot:update(entity)
    end
end

function InventoryDialog:updateFloorSlots()
    self.floor_slots = {}
    self.floor_cnt:detachAll()
    if (self.entity) then
        -- get list of the entities in units position on the map
        local entities_on_floor = MapHandler.getEntitiesInPos(unpack(self.entity.pos))
        -- remove from table all non item entities
        local x, y = self.floor_cnt:getRect()
        for i, entity in ipairs(entities_on_floor) do
            if (GameData.isItem(entity.id)) then
                local slot_cnt = FloorSlot()
                slot_cnt:update(entity)
                slot_cnt:moveTo(x, y + (i - 1) * 50)
                self.floor_cnt:attach(slot_cnt)
                table.insert(self.floor_slots, slot_cnt)
            end
        end
        local content_width, content_height = 200, #self.floor_slots * 50
        self.floor_cnt:setContentRect(0, 0, content_width, content_height)
    end
end

function InventoryDialog:createUnitContainers()
    local x = 110
    for i = 1, self.number_of_slots do
        local y = 40 + (i - 1) * 50
        local slot_cnt = InventorySlot()
        slot_cnt:moveTo(x, y)
        self:attach(slot_cnt)

        table.insert(self.slots, slot_cnt)
    end
end

function InventoryDialog:createFloorContainers()
    self.floor_cnt = ScrollContainer("floorCnt")
    self.floor_cnt:setRect(110, 280, 240, 320)
    self.floor_cnt:setScrollSpeed(500)
    self:attach(self.floor_cnt)
end

function InventoryDialog:onAddEntity(entity)
    if (entity) then
        if (not self.entity.inventory) then
            self.entity.inventory = {}
        end
        if (#self.entity.inventory < self.number_of_slots) then
            table.insert(self.entity.inventory, entity)
            Observer:call("DeleteEntity", nil, entity)
            self:updateUnitSlots()
            self:updateFloorSlots()
        end
    end
end

function InventoryDialog:onRemoveEntity(entity)
    if (entity) then
    end
end