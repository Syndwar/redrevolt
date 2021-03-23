class "MapEditorSelectionPanel" (Container)

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

function MapEditorSelectionPanel:init()
    UIBuilder.create(self, __getUIDesc(self))
end

function MapEditorSelectionPanel:tune(entities)
    self._entities = entities
    log(#entities)
    local scroll_cnt = self:getUI("scroll_cnt")
    if (scroll_cnt) then
        scroll_cnt:detachAll()
        scroll_cnt:jumpTo(0, 0)
        local x, y, _, _ = scroll_cnt:getRect()
        for i, entity in ipairs(entities) do
            local id = entity:getId()
            local sprite = entity:getSprite()

            local btn = Button(id)
            btn:setRect(x, y + (i - 1) * 32, 32, 32)
            btn:setSprites(sprite, sprite, sprite)
            btn:addCallback("MouseUp_Left", self.__entitySelected, entity)
            scroll_cnt:attach(btn)
        end
        scroll_cnt:setContentRect(0, 0, 32, #entities * 32)
    end
end

function MapEditorSelectionPanel.__scrollTo(params)
    local self = params[1]
    local scroll_cnt = self:getUI("scroll_cnt")
    if (scroll_cnt) then
        local direction = params[2]
        local value = params[3]
        scroll_cnt:enableScroll(direction, value)
    end
end

function MapEditorSelectionPanel.__entitySelected(entity)
    -- Observer:call("EntityChanged", entity)
end