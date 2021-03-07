EntityHandler = {
    _id = nil,
    _pos = nil,
    _angle = nil,
    _flip = nil,
    _default_settings = nil,
    _default_desc = nil,
    _settings = nil,
    _inventory = nil,
    _obj = nil,
}

--[[ Private ]]
local function __mirror_line(tbl)
    local result = {}
    for i = 1, #tbl do
        local last = #tbl - i + 1
        if (i <= last) then
            result[i] = tbl[last]
            result[last] = tbl[i]
        end
    end
    return result
end

local function __mirror_col(tbl)
    return __mirror_line(tbl)
end

local function __mirror_all(tbl)
    local result = {}
    for i, row in ipairs(tbl) do
        result[#tbl - i + 1] = __mirror_line(row)
    end
    return result
end

local function __transpose(tbl)
    local result = {}
    for i, row in ipairs(tbl) do
        for j, value in ipairs(row) do
            if (not result[j]) then
                result[j] = {}
            end
            result[j][#tbl - i + 1] = value    
        end
    end
    return result
end

function EntityHandler:__getSettings()
    return self._settings or self._default_settings
end

function EntityHandler:__getDescription()
    return self._default_desc
end

--[[ Public ]]
function EntityHandler.new(id)
    local entity = table.deepcopy(EntityHandler)
    entity._id = id
    entity._default_settings = GameData.getDefaultSettings(id)
    entity._default_desc = GameData.find(id)
    return entity
end

function EntityHandler.load(data)
    local entity = table.deepcopy(EntityHandler)
    entity._id = data.id
    entity._angle = data.angle
    entity._pos = data.pos
    entity._flip = data.flip
    entity._inventory = data.inventory
    entity._settings = data.settings
    entity._default_settings = GameData.getDefaultSettings(data.id)
    entity._default_desc = GameData.find(data.id)
    return entity
end

function EntityHandler:save(data)
    local data = {}
    data["id"] = self._id
    data["angle"] = self._angle
    data["pos"] = self._pos
    data["flip"] = self._flip
    data["inventory"] = self._inventory
    data["settings"] = self._settings
    return data
end

function EntityHandler:isValid()
    return "" ~= self._id
end

function EntityHandler:getId()
    return self._id or ""
end

function EntityHandler:setId(id)
    self._id = id or ""
end

function EntityHandler:getPos()
    return self._pos or {0, 0}
end

function EntityHandler:getAngle()
    return self._angle or 0
end

function EntityHandler:getFlip()
    return self._flip or {false, false}
end

function EntityHandler:setPos(i, j)
    if (not self._pos) then
        self._pos = {i, j}
    else
        self._pos[1] = i
        self._pos[2] = j
    end
end

function EntityHandler:setObj(obj)
    if (not self._obj) then
        self._obj = obj
    end
end

function EntityHandler:setAngle(angle)
    self._angle = angle
    if (self._obj) then
        self._obj:setAngle(angle)
    end
end

function EntityHandler:setFlip(fliph, flipv)
    if (not self._flip) then
        self._flip = {fliph, flipv}
    else
        self._flip[1] = fliph
        self._flip[2] = flipv
    end
    if (self._obj) then
        self._obj:setFlip(fliph, flipv)
    end
end

function EntityHandler:getSprite()
    local desc = self:__getDescription()
    return desc and desc.sprite or ""
end

function EntityHandler:getSize()
    local desc = self:__getDescription()
    return desc and desc.size or {0, 0}
end

function EntityHandler:getName()
    local settings = self:__getSettings()
    return settings and settings.name or ""
end

function EntityHandler.flipGeometry(geometry, horizontal, vertical)
    local result = nil
    if (horizontal) then
        result = {}
        for i, row in ipairs(geometry) do
            result[i] = __mirror_line(row)
        end
    else
        result = table.deepcopy(geometry)
    end
    if (vertical) then
        result = __mirror_col(result)
    end
    log(#result)
    return result
end

function EntityHandler.rotateGeometry(geometry, angle)
    local result = geometry
    if (90 == angle) then
        result = __transpose(geometry)
    elseif (180 == angle) then
        result = __mirror_all(geometry)
    elseif (270 == angle) then
        local transposed = __transpose(geometry)
        result = __mirror_all(transposed)
    end
    return result
end

function EntityHandler:geDefaultGeometry()
    local desc = self:__getDescription()
    return desc and desc.geometry
end

function EntityHandler:getGeometry()
    local geometry = self:geDefaultGeometry()
    if (1 == #geometry and 1 == geometry[1]) then return geometry end
    
    local result = geometry
    if (self._angle) then
        result = EntityHandler.rotateGeometry(result, self._angle)
    end
    if (self._flip) then
        result = EntityHandler.flipGeometry(result, self._flip[1], self._flip[2])
    end
    return result
end

local _info_params = {
    {"HP:", "health_max"},
    {"MO:", "morale_max"},
    {"ST:", "stamina_max"},
    {"AR:", "armour"},
    {"AP:", "action_points_max"},
    {"WS:", "weapon_skill"},
    {"DG:", "damage"},
    {"AC:", "accuracy"},
    {"CP:", "capacity"},
}

function EntityHandler:getInfo()
    local result = nil
    local settings = self:__getSettings()
    for _, param in ipairs(_info_params) do
        local shortcut = param[1]
        local value = settings and settings[param[2]]
        if (value) then
            if (not result) then
                result = {}
            end
            table.insert(result, {shortcut, value})
        end
    end
    return result
end

local _edit_params = {
    {"Name:",           "name"},
    {"Morale:",         "morale_cur", "morale_max"},
    {"Stamina:",        "stamina_cur", "stamina_max"},
    {"Health:",         "health_cur", "health_max"},
    {"Armour:",         "armour"},
    {"Action Points:",  "action_points_cur", "action_points_max"},
    {"Weapon Skill:",   "weapon_skill"},
    {"Damage:",         "damage"},
    {"Accuracy:",       "accuracy"},
    {"Capacity:",       "capacity"},
}

function EntityHandler:__findParamsInSettings(params)
    local result = nil
    if (not params) then return result end

    local settings = self:__getSettings()
    if (not settings) then return result end

    for i = 2, #params do
        local value = settings[params[i]]
        if (value) then
            -- if there is at least 1 param found - create result
            if (not result) then
                result = {params[1]}
            end
            table.insert(result, value)
        end
    end
    if (result) then log(result[1], result[2], result[3]) end
    return result
end

function EntityHandler:__fillTemplateParams(templates)
    local result = nil
    for _, params in ipairs(templates) do
        local settings_params = self:__findParamsInSettings(params)
        if (settings_params) then
            if (not result) then
                result = {}
            end
            table.insert(result, settings_params)
        end
    end
    return result
end

function EntityHandler:getEditParams()
    return self:__fillTemplateParams(_edit_params)
end

function EntityHandler:getHotSpot()
    local desc = self:__getDescription()
    assert(desc, self._default_desc)
    local size = desc.size or {0, 0}
    local angle = self._angle
    local w, h = size[1], size[2]
    local midw = w / 2
    local midh = h / 2
    if (w == h) then
        return midw, midh
    elseif (90 == angle) then
        return midh, midh
    elseif (270 == angle) then
        return midw, midw
    end
    return midw, midh
end

function EntityHandler:copy()
    return table.deepcopy(self)
end

function EntityHandler:destroy()
    if (self._obj) then
        self._obj:detach()
    end
end

function EntityHandler:isHit(i, j)
    local geometry = self:getGeometry()
    local pos = self:getPos()
    for k, row in ipairs(geometry) do
        for l, value in ipairs(row) do
            if (1 == value) then
                local obj_part_x = pos[1] + (l - 1)
                local obj_part_y = pos[2] + (k - 1)
                if (obj_part_x == i and obj_part_y == j) then
                    return true
                end
            end
        end
    end
    return false
end

function EntityHandler:hasObj()
    return nil ~= self._obj
end