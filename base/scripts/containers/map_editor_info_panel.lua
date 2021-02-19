class "MapEditorInfoPanel" (Container)

local function __getUIDesc(self)
    return 
    {
        {
            id = "selectedImg", widget = "Image", ui = "selected_img",
            rect = {0, 0, 32, 32},
            angle = 0, center = {16, 16},
        },
        {
            id = "selectedLbl", widget = "Label", ui = "selected_lbl",
            rect = {40, 0, 200, 32},
            colour = "white", font = "system_15_fnt", text_align = "LEFT|MIDDLE",
        }
    }
end


function MapEditorInfoPanel:init()
    Observer:addListener("EntityChanged", self, self.__onEntityChanged)
    Observer:addListener("EntityRotated", self, self.__onEntityRotated)
    Observer:addListener("EntityFlipped", self, self.__onEntityFlipped)
--     self.current_map = nil
--     self.maps = {}
--     self.containers = {}

--     self.cnt_list = {
--         EntityType.Unit,
--         EntityType.WeaponMelee,
--         EntityType.WeaponRanged,
--         EntityType.ItemUseSelf,
--         EntityType.ItemUseThem,
--         EntityType.ItemAmmo,
--     }

--     self.generators = {
--         [EntityType.Unit]         = self.__generateUnitCnt,
--         [EntityType.WeaponMelee]  = self.__generateWeaponMeleeCnt,
--         [EntityType.WeaponRanged] = self.__generateWeaponRangedCnt,
--         [EntityType.ItemUseSelf]  = self.__generateItemUseSelfCnt,
--         [EntityType.ItemUseThem]  = self.__generateItemUseThemCnt,
--         [EntityType.ItemAmmo]     = self.__generateItemAmmoCnt,
--     }

    UIBuilder.create(self, __getUIDesc(self))
--     self:createContainers()
end

function MapEditorInfoPanel:__onEntityChanged(entity)
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

--     local entity_type = entity and GameData.getEntityType(entity.id)
--     for _, cnt_id in ipairs(self.cnt_list) do
--         local cnt = self.containers[cnt_id]
--         if (cnt) then
--             cnt:view(entity_type and cnt_id == entity_type)
--         end
--     end
--     if (entity and entity_type) then
--         self.current_map = self.maps[entity_type]
--         self:updateContainers(entity.settings)
--     end
end

-- function MapEditorInfoPanel:createContainers()
--     for _, cnt_id in ipairs(self.cnt_list) do
--         local cnt = Container()
--         self.containers[cnt_id] = cnt
--         cnt:view(false)
--         self:attach(cnt)

--         local generator = self.generators[cnt_id]
--         if (generator) then
--             self.maps[cnt_id] = {}
--             generator(self, cnt, self.maps[cnt_id])
--         end
--     end
-- end

-- function MapEditorInfoPanel:updateContainers(settings)
--     if (settings and self.current_map) then
--         for key, value in pairs(settings) do
--             if (self.current_map[key]) then
--                 self.current_map[key]:setText(value)
--             end
--         end
--     end
-- end

-- function MapEditorInfoPanel:__generateEditFields(cnt, map, params)
--     local params_bottom = 0
--     for i, data in ipairs(params) do
--         local lbl = Label()
--         lbl:setRect(240 + (i - 1) * 80, 8, 30, 15)
--         lbl:setText(data.text)
--         lbl:setFont("system_15_fnt")
--         lbl:setColour("white")
--         lbl:setTextAlignment("LEFT|MIDDLE")
--         cnt:attach(lbl)

--         lbl = Label()
--         lbl:setRect(270 + (i - 1) * 80, 8, 50, 15)
--         lbl:setFont("system_15_fnt")
--         lbl:setColour("white")
--         lbl:setTextAlignment("LEFT|MIDDLE")
--         cnt:attach(lbl)

--         map[data.slot] = lbl
--     end
--     return params_bottom
-- end

-- function MapEditorInfoPanel:__generateUnitCnt(cnt, map)
--     local params = {
--         {text = "HP:", slot = "health_max"},
--         {text = "MO:", slot = "morale_max"},
--         {text = "ST:", slot = "stamina_max"},
--         {text = "AR:", slot = "armour"},
--         {text = "AP:", slot = "action_points_max"},
--         {text = "WS:", slot = "weapon_skill"},
--     }
--     self:__generateEditFields(cnt, map, params)
-- end

-- function MapEditorInfoPanel:__generateWeaponMeleeCnt(cnt, map)
--     local params = {
--         {text = "DG:", slot = "damage"},
--         {text = "AC:", slot = "accuracy"},
--         {text = "CP:", slot = "capacity"},
--     }
--     self:__generateEditFields(cnt, map, params)
-- end

-- function MapEditorInfoPanel:__generateWeaponRangedCnt(cnt, map)
--     local params = {
--         {text = "DG:", slot = "damage"},
--         {text = "AC:", slot = "accuracy"},
--         {text = "CP:", slot = "capacity"},
--     }
--     self:__generateEditFields(cnt, map, params)
-- end

-- function MapEditorInfoPanel:generateItemUseSelfCnt(cnt, map)
--     local params = {
--         {text = "DG:", slot = "damage"},
--         {text = "CP:", slot = "capacity"},
--     }
--     self:__generateEditFields(cnt, map, params)
-- end

-- function MapEditorInfoPanel:__generateItemUseThemCnt(cnt, map)
--     local params = {
--         {text = "DG:", slot = "damage"},
--         {text = "CP:", slot = "capacity"},
--     }
--     self:__generateEditFields(cnt, map, params)
-- end

-- function MapEditorInfoPanel:__generateItemAmmoCnt(cnt, map)
--     local params = {
--         {text = "CP:", slot = "capacity"},
--     }
--     self:__generateEditFields(cnt, map, params)
-- end
