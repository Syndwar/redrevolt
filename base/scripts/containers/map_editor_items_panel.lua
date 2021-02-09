class "MapEditorItemsPanel" (Container)

function MapEditorItemsPanel:init()
    self._ui = {}
    self._page_size = {}
    self._active_page = nil

    Observer:addListener("ChangeFilter", self, self.onFilterChanged)

    local screen_width = Engine.getScreenWidth()
    local screen_height = Engine.getScreenHeight()

    local scroll_cnt = ScrollContainer("scrollCnt")
    scroll_cnt:setAlignment("RIGHT|TOP", 0, 32)
    scroll_cnt:setRect(0, 0, 32, screen_height - 64)
    scroll_cnt:setScrollSpeed(500)
    self:attach(scroll_cnt)
    self._ui["scroll_cnt"] = scroll_cnt

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
end

function MapEditorItemsPanel:addPage(id, entities)
    local scroll_cnt = self._ui["scroll_cnt"]
    if (scroll_cnt and not self._ui[id]) then
        local cnt = Container()
        cnt:view(false)
        scroll_cnt:attach(cnt)

        for i, data in ipairs(entities) do
            local btn = Button(data.id)
            btn:setRect(0, (i - 1) * 32, 32, 32)
            btn:setSprites(data.sprite, data.sprite, data.sprite)
            btn:addCallback("MouseUp_Left", self.onEntityClicked, data.id)
            cnt:attach(btn)
        end
        self._ui[id] = cnt
        self._page_size[id] = #entities
    end
end

function MapEditorItemsPanel.scrollTo(params)
    local self = params[1]
    local scroll_cnt = self._ui["scroll_cnt"]
    if (scroll_cnt) then
        local direction = params[2]
        local value = params[3]
        scroll_cnt:enableScroll(direction, value)
    end
end

function MapEditorItemsPanel.onEntityClicked(id)
    Observer:call("SelectItem", id)
end

function MapEditorItemsPanel:viewActivePage(value)
    if (self._active_page) then
        local active_cnt = self._ui[self._active_page]
        active_cnt:view(value)
    end
end

function MapEditorItemsPanel:onFilterChanged(id)
    local scroll_cnt = self._ui["scroll_cnt"]
    if (scroll_cnt) then
        scroll_cnt:jumpTo(0, 0)

        self:viewActivePage(false)
        self._active_page = id
        self:viewActivePage(true)

        local entities_count = self._page_size[id] or 0
        scroll_cnt:setContentRect(0, 0, 32, entities_count * 32)
    end
end