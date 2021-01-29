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

    self.number_of_slots = 4
    self.entity = nil

    img = Image()
    img:setRect(0, 0, 500, 700)
    img:setSprite("dark_img_spr")
    self:attach(img)

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

    local lbl = Label()
    lbl:setRect(0, 10, 500, 15)
    lbl:setText("Inventory")
    lbl:setFont("system_15_fnt")
    lbl:setColour("red")
    lbl:setTextAlignment("CENTER|MIDDLE")
    self:attach(lbl)

    self.slots = {}

    self:createUnitContainers()
    self:createFloorContainers()
end

function InventoryDialog:onOkBtnClick()
    self:view(false)
end

function InventoryDialog:onCancelBtnClick()
    self:view(false)
end

function InventoryDialog:tune(entity)
    self.entity = entity
end

function InventoryDialog:onOpening()
    for i, slot in ipairs(self.slots) do
        slot.btn:enable(true)
        slot.frame:view(false)
    end
    self.floor_cnt:detachAll()
    if (self.entity) then
        -- get list of the entities in units position on the map
        local entities_on_floor = MapHandler.getEntitiesInPos(unpack(self.entity.pos))
        -- remove from table all non item entities
        for i, v in ipairs(entities_on_floor) do
            if (GameData.isItem(v.id)) then
                self:createFloorSlots(i, v)
            end
        end
    end
end

function InventoryDialog:createFloorSlots(index, entity)
    local x, y = self.floor_cnt:getRect()
    y = y + (index - 1) * 50
    local slot_cnt = Container()
    slot_cnt:setRect(x, y, 200, 40)
    self.floor_cnt:attach(slot_cnt)

    local slot_back_img = Image("slotBack")
    slot_back_img:setSprite("up_btn_spr")
    slot_back_img:setRect(x + 40, y, 200, 40)
    slot_cnt:attach(slot_back_img)

    local frame_img = Primitive("frameImg")
    frame_img:createRect(x + 40, y, 200, 40, false)
    frame_img:setColour("red")
    slot_cnt:attach(frame_img)

    local select_btn = Button("selectBtn")
    select_btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    select_btn:setRect(x, y, 40, 40)
    select_btn:addCallback("MouseUp_Left", self.onFloorItemBtnClick, {self, index})
    slot_cnt:attach(select_btn)

    local icon_img = Image("iconImg")
    icon_img:setSprite(GameData.getSprite(entity.id))
    icon_img:setRect(x + 40, y, 40, 40)
    slot_cnt:attach(icon_img)

    local name_lbl = Label("nameLbl")
    name_lbl:setText(entity.settings.name)
    name_lbl:setTextAlignment("LEFT|MIDDLE")
    name_lbl:setFont("system_15_fnt")
    name_lbl:setColour("white")
    name_lbl:setRect(x + 90, y, 150, 40)
    slot_cnt:attach(name_lbl)
end

function InventoryDialog:createUnitContainers()
    for i = 1, self.number_of_slots do
        local y = 40 + (i - 1) * 50
        local slot_cnt = Container()
        slot_cnt:setRect(150, y, 200, 40)
        self:attach(slot_cnt)

        local slot_back_img = Image()
        slot_back_img:setSprite("up_btn_spr")
        slot_back_img:setRect(150, y, 200, 40)
        slot_cnt:attach(slot_back_img)

        local frame_img = Primitive()
        frame_img:createRect(150, y, 200, 40, false)
        frame_img:setColour("red")
        slot_cnt:attach(frame_img)

        local select_btn = Button("selectBtn")
        select_btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
        select_btn:setRect(110, y, 40, 40)
        select_btn:addCallback("MouseUp_Left", self.onSelectItemsBtnClick, {self, i})
        slot_cnt:attach(select_btn)

        local icon_img = Image()
        icon_img:setRect(150, y, 40, 40)
        slot_cnt:attach(icon_img)

        local name_lbl = Label()
        name_lbl:setTextAlignment("LEFT|MIDDLE")
        name_lbl:setFont("system_15_fnt")
        name_lbl:setColour("black")
        name_lbl:setRect(200, y, 150, 40)
        slot_cnt:attach(name_lbl)

        self.slots[i] = {
            btn = select_btn,
            frame = frame_img,
        }
    end
end

function InventoryDialog:createFloorContainers()
    self.floor_cnt = ScrollContainer("floorCnt")
    self.floor_cnt:setRect(110, 280, 240, 320)
    self.floor_cnt:setScrollSpeed(500)
    self:attach(self.floor_cnt)
end

function InventoryDialog.onSelectItemsBtnClick(params)
    local self = params[1]
    local index = params[2]
    for i, slot in ipairs(self.slots) do
        slot.btn:enable(i ~= index)
        slot.frame:view(i == index)
    end
end

function InventoryDialog.onFloorItemBtnClick(params)
    local self = params[1]
    local index = params[2]
end