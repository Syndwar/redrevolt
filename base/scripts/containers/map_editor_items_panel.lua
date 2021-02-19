class "MapEditorItemsPanel" (Container)

function MapEditorItemsPanel:init()
    self._page_size = {}
    self._active_page = nil

    Observer:addListener("ChangeFilter", self, self.__onFilterChanged)

    local screen_width = Engine.getScreenWidth()
    local screen_height = Engine.getScreenHeight()

    local scroll_cnt = ScrollContainer("scrollCnt")
    scroll_cnt:setAlignment("RIGHT|TOP", 0, 32)
    scroll_cnt:setRect(0, 0, 32, screen_height - 64)
    scroll_cnt:setScrollSpeed(500)
    self:attach(scroll_cnt)
    self:setUI("scroll_cnt", scroll_cnt)

    local scroll_up_area = Area("scrollUpArea")
    scroll_up_area:setRect(0, 0, 32, 32)
    scroll_up_area:setAlignment("RIGHT|TOP", 0, 0)
    scroll_up_area:addCallback("MouseOver", self.__scrollTo, {self, "Up", true})
    scroll_up_area:addCallback("MouseLeft", self.__scrollTo, {self, "Up", false})
    self:attach(scroll_up_area)

    local scroll_down_area = Area("scrollDownArea")
    scroll_down_area:setRect(0, 0, 32, 32)
    scroll_down_area:setAlignment("RIGHT|BOTTOM", 0, 0)
    scroll_down_area:addCallback("MouseOver", self.__scrollTo, {self, "Down", true})
    scroll_down_area:addCallback("MouseLeft", self.__scrollTo, {self, "Down", false})
    self:attach(scroll_down_area)
end

function MapEditorItemsPanel:addPage(id, entities)
    local scroll_cnt = self:getUI("scroll_cnt")
    if (scroll_cnt) then
        local cnt = Container()
        cnt:view(false)
        scroll_cnt:attach(cnt)

        for i, data in ipairs(entities) do
            local btn = Button(data.id)
            btn:setRect(0, (i - 1) * 32, 32, 32)
            btn:setSprites(data.sprite, data.sprite, data.sprite)
            btn:addCallback("MouseUp_Left", self.__onEntityChanged, data.id)
            cnt:attach(btn)
        end
        self:setUI(id, cnt)
        self._page_size[id] = #entities
    end
end

function MapEditorItemsPanel.__scrollTo(params)
    local self = params[1]
    local scroll_cnt = self:getUI("scroll_cnt")
    if (scroll_cnt) then
        local direction = params[2]
        local value = params[3]
        scroll_cnt:enableScroll(direction, value)
    end
end

function MapEditorItemsPanel.__onEntityChanged(id)
    local entity = EntityHandler.new(id)
    Observer:call("EntityChanged", entity)
end

function MapEditorItemsPanel:__viewActivePage(value)
    if (self._active_page) then
        local active_cnt = self:getUI(self._active_page)
        if (active_cnt) then
            active_cnt:instantView(value)
        end
    end
end

function MapEditorItemsPanel:__onFilterChanged(id)
    local scroll_cnt = self:getUI("scroll_cnt")
    if (scroll_cnt) then
        scroll_cnt:jumpTo(0, 0)

        self:__viewActivePage(false)
        self._active_page = id
        self:__viewActivePage(true)

        local entities_count = self._page_size[id] or 0
        scroll_cnt:setContentRect(0, 0, 32, entities_count * 32)
    end
end