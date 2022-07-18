class "MapEditorEntitiesPanel" (Container)

local function __getUIDesc(self)
    return 
    {
        {
            id = "scrollCnt", widget = "ScrollContainer", ui = "scroll_cnt",
            rect = {0, 0, 32,  Engine.getScreenHeight() - 64},
            alignment = {"RIGHT|TOP", 0, 32},
            scroll_speed = 500,
        },
        {
            id = "scrollUpArea", widget = "Area",
            rect = {0, 0, 32, 32},
            alignment = {"RIGHT|TOP", 0, 0},
            callbacks = {
                {"MouseOver", self.__scrollTo, {self, "Up", true}},
                {"MouseLeft", self.__scrollTo, {self, "Up", false}},
            }
        },
        {
            id = "scrollDownArea", widget = "Area",
            rect = {0, 0, 32, 32},
            alignment = {"RIGHT|BOTTOM", 0, 0},
            callbacks = {
                {"MouseOver", self.__scrollTo, {self, "Down", true}},
                {"MouseLeft", self.__scrollTo, {self, "Down", false}},
            }
        },
    }
end

function MapEditorEntitiesPanel:init()
    self._page_size = {}
    self._active_page = nil

    Observer:addListener("ChangeFilter", self, self.__changeFilter)

    UIBuilder.create(self, __getUIDesc(self))
end

function MapEditorEntitiesPanel:addPage(id, entities)
    local scroll_cnt = self:getUI("scroll_cnt")
    if (scroll_cnt) then
        local cnt = Container()
        cnt:view(false)
        scroll_cnt:attach(cnt)

        for i, data in ipairs(entities) do
            local btn = Button(data.id)
            btn:setRect(0, (i - 1) * 32, 32, 32)
            btn:setSprites(data.sprite, data.sprite, data.sprite)
            btn:addCallback("MouseUp_Left", self.__changeEntity, data.id)
            cnt:attach(btn)
        end
        self:setUI(id, cnt)
        self._page_size[id] = #entities
    end
end

function MapEditorEntitiesPanel.__scrollTo(params)
    local self = params[1]
    local scroll_cnt = self:getUI("scroll_cnt")
    if (scroll_cnt) then
        local direction = params[2]
        local value = params[3]
        scroll_cnt:enableScroll(direction, value)
    end
end

function MapEditorEntitiesPanel.__changeEntity(id)
    local entity = EntityHandler.new(id)
    Observer:call("EntityChanged", entity)
end

function MapEditorEntitiesPanel:__viewActivePage(value)
    if (self._active_page) then
        local active_cnt = self:getUI(self._active_page)
        if (active_cnt) then
            active_cnt:instantView(value)
        end
    end
end

function MapEditorEntitiesPanel:__changeFilter(id)
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