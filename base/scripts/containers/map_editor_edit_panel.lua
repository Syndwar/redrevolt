class "MapEditorEditPanel" (Container)

function MapEditorEditPanel:init()
    self:addCallback("KeyUp_" .. HotKeys.Flip, self.onFlipItem, self)
    self:addCallback("KeyUp_" .. HotKeys.Rotate, self.onRotateItem, self)

    self:setRect(0, 0, 32, 32)
    self:setAlignment("LEFT|TOP", 0, 32)

    self.selected_item_angle = 0
    self.selected_item_flip = {false, false}

    local btn = Button("rotateBtn")
    btn:setText(0)
    btn:setFont("system_10_fnt")
    btn:setRect(0, 0, 32, 32)
    btn:setTextAlignment("CENTER|MIDDLE")
    btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    btn:addCallback("MouseUp_Left", self.onRotateItem, self)
    btn:setColour("green")
    self:attach(btn)

    self.rotate_btn = btn

    btn = Button("flipBtn")
    btn:setText("")
    btn:setFont("system_10_fnt")
    btn:setRect(0, 32, 32, 32)
    btn:setTextAlignment("CENTER|MIDDLE")
    btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    btn:addCallback("MouseUp_Left", self.onFlipItem, self)
    btn:setColour("green")
    self:attach(btn)

    self.flip_btn = btn
    
    btn = Button("cancelBtn")
    btn:setText("X")
    btn:setFont("system_10_fnt")
    btn:setRect(0, 64, 32, 32)
    btn:setTextAlignment("CENTER|MIDDLE")
    btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    btn:addCallback("MouseUp_Left", self.onCancelItem, self)
    btn:setColour("green")
    self:attach(btn)

    btn = Button("editBtn")
    btn:setText("E")
    btn:setFont("system_10_fnt")
    btn:setRect(0, 96, 32, 32)
    btn:setTextAlignment("CENTER|MIDDLE")
    btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    btn:addCallback("MouseUp_Left", self.onEditItem, self)
    btn:setColour("green")
    self:attach(btn)

    btn = Button("inventoryBtn")
    btn:setText("I")
    btn:setFont("system_10_fnt")
    btn:setRect(0, 128, 32, 32)
    btn:setTextAlignment("CENTER|MIDDLE")
    btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    btn:addCallback("MouseUp_Left", self.onInventoryItem, self)
    btn:setColour("green")
    self:attach(btn)

    self.edit_btn = btn
end

function MapEditorEditPanel:onRotateItem()
    self:switchAngle()
    Observer:call("RotateItem")
end

function MapEditorEditPanel:onFlipItem()
    self:switchFlip()
    Observer:call("FlipItem")
end

function MapEditorEditPanel:getAngle()
    return self.selected_item_angle
end

function MapEditorEditPanel:getFlip()
    return self.selected_item_flip
end

function MapEditorEditPanel:reset(angle, flip)
    self.selected_item_angle = angle or 0
    self.selected_item_flip = flip or {false, false}
    self:update()
end

function MapEditorEditPanel:switchAngle()
    self.selected_item_angle = self.selected_item_angle + 90
    if (360 == self.selected_item_angle) then
        self.selected_item_angle = 0
    end
    self:update()
end

function MapEditorEditPanel:switchFlip()
    local flip = self.selected_item_flip

    if (flip[1] and flip[2]) then
        flip[1] = false
        flip[2] = false
    elseif (not flip[1] and flip[2]) then
        flip[1] = true
        flip[2] = true
    elseif (not flip[1] and not flip[2]) then
        flip[1] = true
        flip[2] = false
    elseif (flip[1] and not flip[2]) then
        flip[1] = false
        flip[2] = true
    end
    self:update()
end

function MapEditorEditPanel:update()
    self.rotate_btn:setText(self.selected_item_angle)
    local h = self.selected_item_flip[1] and "-" or ""
    local v = self.selected_item_flip[2] and "|" or (self.selected_item_flip[1] and "-" or "")
    self.flip_btn:setText(string.format("%s%s%s", h, v, h))
end

function MapEditorEditPanel:onCancelItem()
    Observer:call("CancelItem")
end

function MapEditorEditPanel:onEditItem()
    Observer:call("EditItem")
end

function MapEditorEditPanel:onInventoryItem()
    Observer:call("ShowInventory")
end