class "MapEditorInfoPanel" (Container)

function MapEditorInfoPanel:init()
    self.selected_item_img = Image("selectedItemImg")
    self.selected_item_img:setRect(0, 0, 32, 32)
    self.selected_item_img:setAngle(self.selected_item_angle)
    self.selected_item_img:setCenter(16, 16)
    self:attach(self.selected_item_img)

    self.selected_item_lbl = Label("selectedItemLbl")
    self.selected_item_lbl:setRect(40, 0, 200, 32)
    self.selected_item_lbl:setFont("system_15_fnt")
    self.selected_item_lbl:setColour("white")
    self.selected_item_lbl:setTextAlignment("LEFT|MIDDLE")
    self:attach(self.selected_item_lbl)

    self.current_map = nil
    self.maps = {}

    self.cnt_list = {
        EntityType.Unit,
        EntityType.WeaponMelee,
        EntityType.WeaponRanged,
        EntityType.ItemUseSelf,
        EntityType.ItemUseThem,
        EntityType.ItemAmmo,
    }
    self.containers = {}

    self.generators = {
        [EntityType.Unit]         = self.generateUnitCnt,
        [EntityType.WeaponMelee]  = self.generateWeaponMeleeCnt,
        [EntityType.WeaponRanged] = self.generateWeaponRangedCnt,
        [EntityType.ItemUseSelf]  = self.generateItemUseSelfCnt,
        [EntityType.ItemUseThem]  = self.generateItemUseThemCnt,
        [EntityType.ItemAmmo]     = self.generateItemAmmoCnt,
    }

    self:createContainers()
end

function MapEditorInfoPanel:update(sprite, angle, flip, text, entity)
    if (sprite) then
        self.selected_item_img:setSprite(sprite)
    end
    if (angle) then
        self.selected_item_img:setAngle(angle)
    end
    if (flip) then
        self.selected_item_img:setFlip(unpack(flip))
    end
    if (text) then
        self.selected_item_lbl:setText(text)
    end

    local entity_type = entity and GameData.getEntityType(entity.id)
    for _, cnt_id in ipairs(self.cnt_list) do
        local cnt = self.containers[cnt_id]
        if (cnt) then
            cnt:view(entity_type and cnt_id == entity_type)
        end
    end
    if (entity and entity_type) then
        self.current_map = self.maps[entity_type]
        self:updateContainers(entity.settings)
    end
end

function MapEditorInfoPanel:createContainers()
    for _, cnt_id in ipairs(self.cnt_list) do
        local cnt = Container()
        self.containers[cnt_id] = cnt
        cnt:view(false)
        self:attach(cnt)

        local generator = self.generators[cnt_id]
        if (generator) then
            self.maps[cnt_id] = {}
            generator(self, cnt, self.maps[cnt_id])
        end
    end
end

function MapEditorInfoPanel:updateContainers(settings)
    if (settings and self.current_map) then
        for key, value in pairs(settings) do
            if (self.current_map[key]) then
                self.current_map[key]:setText(value)
            end
        end
    end
end

function MapEditorInfoPanel:generateEditFields(cnt, map, params)
    local params_bottom = 0
    for i, data in ipairs(params) do
        local lbl = Label()
        lbl:setRect(240 + (i - 1) * 80, 8, 30, 15)
        lbl:setText(data.text)
        lbl:setFont("system_15_fnt")
        lbl:setColour("white")
        lbl:setTextAlignment("LEFT|MIDDLE")
        cnt:attach(lbl)

        lbl = Label()
        lbl:setRect(270 + (i - 1) * 80, 8, 50, 15)
        lbl:setFont("system_15_fnt")
        lbl:setColour("white")
        lbl:setTextAlignment("LEFT|MIDDLE")
        cnt:attach(lbl)

        map[data.slot] = lbl
    end
    return params_bottom
end

function MapEditorInfoPanel:generateUnitCnt(cnt, map)
    local params = {
        {text = "HP:", slot = "health_max"},
        {text = "MO:", slot = "morale_max"},
        {text = "ST:", slot = "stamina_max"},
        {text = "AR:", slot = "armour"},
        {text = "AP:", slot = "action_points_max"},
        {text = "WS:", slot = "weapon_skill"},
    }
    self:generateEditFields(cnt, map, params)
end

function MapEditorInfoPanel:generateWeaponMeleeCnt(cnt, map)
    local params = {
        {text = "DG:", slot = "damage"},
        {text = "AC:", slot = "accuracy"},
        {text = "CP:", slot = "capacity"},
    }
    self:generateEditFields(cnt, map, params)
end

function MapEditorInfoPanel:generateWeaponRangedCnt(cnt, map)
    local params = {
        {text = "DG:", slot = "damage"},
        {text = "AC:", slot = "accuracy"},
        {text = "CP:", slot = "capacity"},
    }
    self:generateEditFields(cnt, map, params)
end

function MapEditorInfoPanel:generateItemUseSelfCnt(cnt, map)
    local params = {
        {text = "DG:", slot = "damage"},
        {text = "CP:", slot = "capacity"},
    }
    self:generateEditFields(cnt, map, params)
end

function MapEditorInfoPanel:generateItemUseThemCnt(cnt, map)
    local params = {
        {text = "DG:", slot = "damage"},
        {text = "CP:", slot = "capacity"},
    }
    self:generateEditFields(cnt, map, params)
end

function MapEditorInfoPanel:generateItemAmmoCnt(cnt, map)
    local params = {
        {text = "CP:", slot = "capacity"},
    }
    self:generateEditFields(cnt, map, params)
end
