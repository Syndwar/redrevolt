class "MapEditorFiltersPanel" (Container)

function MapEditorFiltersPanel:init()
    self:setRect(0, 0, 384, 64)
    self:setAlignment("CENTER|BOTTOM", 0, 0)

    self.filter = nil

    local prev_btn = Button("prev_btn")
    prev_btn:setText("Prev")
    prev_btn:setFont("system_15_fnt")
    prev_btn:setRect(0, 0, 64, 64)
    prev_btn:setTextAlignment("CENTER|MIDDLE")
    prev_btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    prev_btn:addCallback("MouseUp_Left", self.onPrevBtnClick, self)
    prev_btn:setColour("green")
    self:attach(prev_btn)

    local next_btn = Button("next_btn")
    next_btn:setText("Next")
    next_btn:setFont("system_15_fnt")
    next_btn:setRect(64, 0, 64, 64)
    next_btn:setTextAlignment("CENTER|MIDDLE")
    next_btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    next_btn:addCallback("MouseUp_Left", self.onNextBtnClick, self)
    next_btn:setColour("green")
    self:attach(next_btn)

    local items_btn = Button("itemsBtn")
    items_btn:setText("Items")
    items_btn:setFont("system_15_fnt")
    items_btn:setRect(128, 0, 64, 64)
    items_btn:setTextAlignment("CENTER|MIDDLE")
    items_btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    items_btn:addCallback("MouseUp_Left", self.onFilterBtnClick, {self, "items"})
    items_btn:setColour("green")
    self:attach(items_btn)

    local units_btn = Button("unitsBtn")
    units_btn:setText("Units")
    units_btn:setFont("system_15_fnt")
    units_btn:setRect(192, 0, 64, 64)
    units_btn:setTextAlignment("CENTER|MIDDLE")
    units_btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    units_btn:addCallback("MouseUp_Left", self.onFilterBtnClick, {self, "units"})
    units_btn:setColour("green")
    self:attach(units_btn)

    local objects_btn = Button("objectsBtn")
    objects_btn:setText("Objects")
    objects_btn:setFont("system_15_fnt")
    objects_btn:setRect(256, 0, 64, 64)
    objects_btn:setTextAlignment("CENTER|MIDDLE")
    objects_btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    objects_btn:addCallback("MouseUp_Left", self.onFilterBtnClick, {self, "objects"})
    objects_btn:setColour("green")
    self:attach(objects_btn)

    local terrain_btn = Button("terrainBtn")
    terrain_btn:setText("Terrain")
    terrain_btn:setFont("system_15_fnt")
    terrain_btn:setRect(320, 0, 64, 64)
    terrain_btn:setTextAlignment("CENTER|MIDDLE")
    terrain_btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    terrain_btn:addCallback("MouseUp_Left", self.onFilterBtnClick, {self, "terrain"})
    terrain_btn:setColour("green")
    self:attach(terrain_btn)
end

function MapEditorFiltersPanel.onFilterBtnClick(params)
    local id = params[2]
    local self = params[1]
    if (id) then
        self.filter = id
        Observer:call("ChangeFilter", id)
    end
end

function MapEditorFiltersPanel:getFilter()
    return self.filter
end

function MapEditorFiltersPanel:onNextBtnClick()
    Observer:call("NextItem")
end

function MapEditorFiltersPanel:onPrevBtnClick()
    Observer:call("PrevItem")
end