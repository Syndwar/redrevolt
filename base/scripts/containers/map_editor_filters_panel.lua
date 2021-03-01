class "MapEditorFiltersPanel" (Container)

local function __getUIDesc(self)
    return 
    {
        {
            id = "prevBtn", widget = "Button",
            rect = {0, 0, 64, 64},
            callback = {"MouseUp_Left", self.__selectPrevEntity, self},
            text = "Prev", colour = "green", font = "system_15_fnt", text_align = "CENTER|MIDDLE",
            sprites = {"up_btn_spr", "down_btn_spr", "over_btn_spr"},
        },
        {
            id = "nextBtn", widget = "Button",
            rect = {64, 0, 64, 64},
            callback = {"MouseUp_Left", self.__selectNextEntity, self},
            text = "Next", colour = "green", font = "system_15_fnt", text_align = "CENTER|MIDDLE",
            sprites = {"up_btn_spr", "down_btn_spr", "over_btn_spr"},
        },
        {
            id = "itemsBtn", widget = "Button",
            rect = {128, 0, 64, 64},
            callback = {"MouseUp_Left", self.__onFilterBtnClick, {self, 1}},
            text = "Items", colour = "green", font = "system_15_fnt", text_align = "CENTER|MIDDLE",
            sprites = {"up_btn_spr", "down_btn_spr", "over_btn_spr"},
        },
        {
            id = "unitsBtn", widget = "Button",
            rect = {192, 0, 64, 64},
            callback = {"MouseUp_Left", self.__onFilterBtnClick, {self, 2}},
            text = "Units", colour = "green", font = "system_15_fnt", text_align = "CENTER|MIDDLE",
            sprites = {"up_btn_spr", "down_btn_spr", "over_btn_spr"},
        },
        {
            id = "objectsBtn", widget = "Button",
            rect = {256, 0, 64, 64},
            callback = {"MouseUp_Left", self.__onFilterBtnClick, {self, 3}},
            text = "Objects", colour = "green", font = "system_15_fnt", text_align = "CENTER|MIDDLE",
            sprites = {"up_btn_spr", "down_btn_spr", "over_btn_spr"},
        },
        {
            id = "terrainBtn", widget = "Button",
            rect = {320, 0, 64, 64},
            callback = {"MouseUp_Left", self.__onFilterBtnClick, {self, 4}},
            text = "Terrain", colour = "green", font = "system_15_fnt", text_align = "CENTER|MIDDLE",
            sprites = {"up_btn_spr", "down_btn_spr", "over_btn_spr"},
        },
    }
end

function MapEditorFiltersPanel:init()
    self:setRect(0, 0, 384, 64)
    self:setAlignment("CENTER|BOTTOM", 0, 0)

    self:addCallback("KeyUp_" .. HotKeys.Panel1, self.__changeFilter, 1)
    self:addCallback("KeyUp_" .. HotKeys.Panel2, self.__changeFilter, 2)
    self:addCallback("KeyUp_" .. HotKeys.Panel3, self.__changeFilter, 3)
    self:addCallback("KeyUp_" .. HotKeys.Panel4, self.__changeFilter, 4)

    self:addCallback("KeyUp_" .. HotKeys.Next,     self.__selectNextEntity, self)
    self:addCallback("KeyUp_" .. HotKeys.Previous, self.__selectPrevEntity, self)

    UIBuilder.create(self, __getUIDesc(self))
end

function MapEditorFiltersPanel.__onFilterBtnClick(params)
    local id = params[2]
    local self = params[1]
    if (id) then
        self.__changeFilter(id)
    end
end

function MapEditorFiltersPanel.__changeFilter(id)
    Observer:call("ChangeFilter", id)
end

function MapEditorFiltersPanel:__selectNextEntity()
    Observer:call("NextEntity")
end

function MapEditorFiltersPanel:__selectPrevEntity()
    Observer:call("PrevEntity")
end