class "MapEditorEditPanel" (Container)

local function __getUIDesc(self)
    return 
    {
        {
            id = "rotateBtn", widget = "Button", ui = "rotate_btn",
            rect = {0, 0, 32, 32},
            callback = {"MouseUp_Left", self.__rotateEntity, self},
            text = 0, colour = "green", font = "system_10_fnt", text_align = "CENTER|MIDDLE",
            sprites = {"up_btn_spr", "down_btn_spr", "over_btn_spr"},
        },
        {
            id = "flipBtn", widget = "Button", ui = "flip_btn",
            rect = {0, 32, 32, 32},
            callback = {"MouseUp_Left", self.__flipEntity, self},
            text = "", colour = "green", font = "system_10_fnt", text_align = "CENTER|MIDDLE",
            sprites = {"up_btn_spr", "down_btn_spr", "over_btn_spr"},
        },
        {
            id = "cancelBtn", widget = "Button",
            rect = {0, 64, 32, 32},
            callback = {"MouseUp_Left", self.__cancelEntity, self},
            text = "X", colour = "green", font = "system_10_fnt", text_align = "CENTER|MIDDLE",
            sprites = {"up_btn_spr", "down_btn_spr", "over_btn_spr"},
        },
        {
            id = "editBtn", widget = "Button",
            rect = {0, 96, 32, 32},
            callback = {"MouseUp_Left", self.__editEntity, self},
            text = "E", colour = "green", font = "system_10_fnt", text_align = "CENTER|MIDDLE",
            sprites = {"up_btn_spr", "down_btn_spr", "over_btn_spr"},
        },
        {
            id = "inventoryBtn", widget = "Button",
            rect = {0, 128, 32, 32},
            callback = {"MouseUp_Left", self.__showInventory, self},
            text = "I", colour = "green", font = "system_10_fnt", text_align = "CENTER|MIDDLE",
            sprites = {"up_btn_spr", "down_btn_spr", "over_btn_spr"},
        },
        {
            id = "orderBtn", widget = "Button", ui = "order_btn",
            rect = {0, 160, 32, 32},
            callback = {"MouseUp_Left", self.__changeOrder, self},
            text = "0", colour = "green", font = "system_10_fnt", text_align = "CENTER|MIDDLE",
            sprites = {"up_btn_spr", "down_btn_spr", "over_btn_spr"},
        },
    }
   
end

function MapEditorEditPanel:init()
    self._angles = nil
    self._flips = nil
    self._angle_index = 1
    self._flip_index = 1
    self._orders = {0, 0}
    self._order = 0

    Observer:addListener("EntityChanged", self, self.__changeEntity)

    self:addCallback("KeyUp_" .. HotKeys.Flip,      self.__flipEntity,      self)
    self:addCallback("KeyUp_" .. HotKeys.Rotate,    self.__rotateEntity,    self)
    self:addCallback("KeyUp_" .. HotKeys.Cancel,    self.__cancelEntity,    self)
    self:addCallback("KeyUp_" .. HotKeys.Edit,      self.__editEntity,      self)
    self:addCallback("KeyUp_" .. HotKeys.Inventory, self.__showInventory,   self)

    self:setRect(0, 0, 32, 32)
    self:setAlignment("LEFT|TOP", 0, 32)

    UIBuilder.create(self, __getUIDesc(self))
    self:__update()
end

function MapEditorEditPanel:setAngles(angles)
    self._angles = angles
end

function MapEditorEditPanel:setFlips(flips)
    self._flips = flips
end

function MapEditorEditPanel:setOrders(min, max)
    self._orders = {min, max}
end

function MapEditorEditPanel:__getFlip()
    return self._flips and self._flips[self._flip_index]
end

function MapEditorEditPanel:__getAngle()
    return self._angles and self._angles[self._angle_index] or 0
end

function MapEditorEditPanel:__getOrder()
    return self._order or 0
end

function MapEditorEditPanel:__reset(angle, flip, order)
    self._angle_index = 1
    if (angle) then
        for i, v in ipairs(self._angles) do
            if (angle == v) then
                self._angle_index = i
            end
        end
    end

    self._flip_index = 1
    if (flip) then
        for i, v in ipairs(self._flips) do
            if (flip[1] == v[1] and flip[2] == v[2]) then
             self._flip_index = i
            end
        end
    end

    self:__setOrder(order)
end

function MapEditorEditPanel:__switchAngle()
    self._angle_index = self._angle_index + 1
    if (self._angle_index > #self._angles) then
        self._angle_index = 1
    end
end

function MapEditorEditPanel:__switchFlip()
    self._flip_index = self._flip_index + 1
    if (self._flip_index > #self._flips) then
        self._flip_index = 1
    end
end

function MapEditorEditPanel:__updateRotateBtn()
    local rotate_btn = self:getUI("rotate_btn")
    if (rotate_btn) then
        local angle = self._angles and self._angles[self._angle_index] or 0
        rotate_btn:setText(angle)
    end
end

function MapEditorEditPanel:__updateFlipBtn()
    local flip_btn = self:getUI("flip_btn")
    if (flip_btn) then
        local flip = self._flips and self._flips[self._flip_index]
        local text = flip and flip[3] or ""
        flip_btn:setText(text)
    end
end

function MapEditorEditPanel:__updateLayerBtn()
    local order_btn = self:getUI("order_btn")
    if (order_btn) then
        order_btn:setText(self._order)
    end
end

function MapEditorEditPanel:__update()
    self:__updateRotateBtn()
    self:__updateFlipBtn()
    self:__updateLayerBtn()
end

function MapEditorEditPanel:__cancelEntity()
    Observer:call("EntityChanged", nil)
    Observer:call("ShowEntityPanel")
end

function MapEditorEditPanel:__editEntity()
    Observer:call("EditEntity")
end

function MapEditorEditPanel:__showInventory()
    Observer:call("EditInventory")
end

function MapEditorEditPanel:__rotateEntity()
    self:__switchAngle()
    self:__update()
    Observer:call("EntityRotated", self:__getAngle())
end

function MapEditorEditPanel:__flipEntity()
    self:__switchFlip()
    self:__update()
    Observer:call("EntityFlipped", self:__getFlip())
end

function MapEditorEditPanel:__changeEntity(entity)
    local angle = entity and entity:getAngle()
    local flip = entity and entity:getFlip()
    local order = entity and entity:getOrder()
    self:__reset(angle, flip, order)
    self:__update()
end

function MapEditorEditPanel:__changeOrder()
    self:__setOrder(self._order + 1)
    self:__update()
    Observer:call("EntityOrderChanged", self:__getOrder())
end

function MapEditorEditPanel:__setOrder(order)
    self._order = order or 0
    if (self._order > self._orders[2]) then
        self._order = self._orders[1]
    end
end