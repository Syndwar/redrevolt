class "MapEditorItemsPanel" (Container)

function MapEditorItemsPanel:init()
    Observer:addListener("ChangeFilter", self, self.onFilterChangedCallback)

    local screen_width = Engine.getScreenWidth()
    local screen_height = Engine.getScreenHeight()

    local scroll_cnt = ScrollContainer("scrollCnt")
    scroll_cnt:setAlignment("RIGHT|TOP", 0, 32)
    scroll_cnt:setRect(0, 0, 32, screen_height - 64)
    scroll_cnt:setScrollSpeed(500)
    self:attach(scroll_cnt)

    self.units_cnt = Container("unitsCnt")
    self.units_cnt:view(false)
    scroll_cnt:attach(self.units_cnt)

    self.items_cnt = Container("itemsCnt")
    self.items_cnt:view(false)
    scroll_cnt:attach(self.items_cnt)

    self.objects_cnt = Container("objectsCnt")
    self.objects_cnt:view(false)
    scroll_cnt:attach(self.objects_cnt)

    self.terrain_cnt = Container("terrainCnt")
    self.terrain_cnt:view(false)
    scroll_cnt:attach(self.terrain_cnt)

    local items_count = 0
    local units_count = 0
    local objects_count = 0
    local terrain_count = 0

    for i, data in ipairs(Items) do
        local btn = Button(data.id)
        btn:setRect(0, items_count * 32, 32, 32)
        btn:setSprites(data.sprite, data.sprite, data.sprite)
        btn:addCallback("MouseUp_Left", self.onMapItemClicked, btn)
        self.items_cnt:attach(btn)
        items_count = items_count + 1
    end
    
    for i, data in ipairs(Units) do
        local btn = Button(data.id)
        btn:setRect(0, units_count * 32, 32, 32)
        btn:setSprites(data.sprite, data.sprite, data.sprite)
        btn:addCallback("MouseUp_Left", self.onMapItemClicked, btn)
        self.units_cnt:attach(btn)
        units_count = units_count + 1
    end

    for i, data in ipairs(Objects) do
        local btn = Button(data.id)
        btn:setRect(0, objects_count * 32, 32, 32)
        btn:setSprites(data.sprite, data.sprite, data.sprite)
        btn:addCallback("MouseUp_Left", self.onMapItemClicked, btn)
        self.objects_cnt:attach(btn)
        objects_count = objects_count + 1
    end

    for i, data in ipairs(Terrain) do
        local btn = Button(data.id)
        btn:setRect(0, terrain_count * 32, 32, 32)
        btn:setSprites(data.sprite, data.sprite, data.sprite)
        btn:addCallback("MouseUp_Left", self.onMapItemClicked, btn)
        self.terrain_cnt:attach(btn)
        terrain_count = terrain_count + 1
    end

    local max_row = items_count
    if (units_count > max_row) then
        max_row = units_count
    end
    if (objects_count > max_row) then
        max_row = objects_count
    end
    if (terrain_count > max_row) then
        max_row = terrain_count
    end

    scroll_cnt:setContentRect(0, 0, 32, max_row * 32)

    local scroll_up_area = Area("scrollUpArea")
    scroll_up_area:setRect(0, 0, 32, 32)
    scroll_up_area:setAlignment("RIGHT|TOP", 0, 0)
    scroll_up_area:addCallback("MouseOver", self.scrollTo, {self, "Up", true})
    scroll_up_area:addCallback("MouseLeft", self.scrollTo, {self, "Up", false})
    self:attach(scroll_up_area)

    local scroll_down_area = Area("scrollDownArea")
    scroll_down_area:setRect(0, 0, 32, 32)
    scroll_down_area:setAlignment("RIGHT|BOTTOM", 0, 0)
    scroll_down_area:addCallback("MouseOver", self.scrollTo, {self, "Down", true})
    scroll_down_area:addCallback("MouseLeft", self.scrollTo, {self, "Down", false})
    self:attach(scroll_down_area)

    self.scroll_cnt = scroll_cnt
end

function MapEditorItemsPanel.scrollTo(params)
    local cnt = params[1]
    local direction = params[2]
    local value = params[3]
    if (cnt and cnt.scroll_cnt) then
        cnt.scroll_cnt:enableScroll(direction, value)
    end
end

function MapEditorItemsPanel.onMapItemClicked(sender)
    if (sender and sender.getId) then
        Observer:call("SelectItem", sender:getId())
    end
end

function MapEditorItemsPanel:onFilterChangedCallback(id)
    self:changeFilter(id)
end

function MapEditorItemsPanel:changeFilter(id)
    self.scroll_cnt:jumpTo(0, 0)
    self.objects_cnt:view(id == "objects")
    self.units_cnt:view(id == "units")
    self.items_cnt:view(id == "items")
    self.terrain_cnt:view(id == "terrain")
end