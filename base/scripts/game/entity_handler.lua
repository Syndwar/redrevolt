EntityHandler = {
    _id = nil,
    _pos = nil,
    _angle = nil,
    _flip = nil,
    _default_settings = nil,
    _default_desc = nil,
    _settings = nil,
    _inventory = nil,
}

function EntityHandler.new(id)
    local entity = table.deepcopy(EntityHandler)
    entity._id = id
    entity._default_settings = GameData.getDefaultSettings(id)
    entity._default_desc = GameData.find(id)
    return entity
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

function EntityHandler:setAngle(angle)
    self._angle = angle
end

function EntityHandler:setFlip(fliph, flipv)
    if (not self._flip) then
        self._flip = {fliph, flipv}
    else
        self._flip[1] = fliph
        self._flip[2] = flipv
    end
end

function EntityHandler:setSettings(settings)
    self._settings = settings
end

function EntityHandler:getSprite()
    local desc = self._default_desc
    return desc and desc.sprite or ""
end

function EntityHandler:getName()
    local settings = self._settings or self._default_settings
    return settings and settings.name or ""
end

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
    local desc = self._default_desc
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

function EntityHandler:getInfo()
    local info = {}
    local settings = self._settings or self._default_settings

    local slots = {
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
    for _, slot in ipairs(slots) do
        local shortcut = slot[1]
        local value = settings[slot[2]]
        if (value) then
            table.insert(info, {shortcut, value})
        end
    end
    return info
end