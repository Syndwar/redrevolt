EntityHandler = {
    _geometry = {
        -- angle = nil,
        -- flip = nil,
        -- pos = nil,
        -- order = 0,
    },
    _desc = {},
    _settings = {},
    _inventory = nil, -- {{id = "medi_probe", settings = {capacity_cur = 0}}, {id = "laser_pack_1", capacity_cur = 5}}},
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
    return self._settings
end

function EntityHandler:__getDescription()
    return self._desc
end

function EntityHandler:__getDefaultGeometry()
    local desc = self:__getDescription()
    return desc and desc.geometry
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

--[[ Public ]]
function EntityHandler.new(id)
    local entity = table.deepcopy(EntityHandler)
    local settings_mt = {
        __index = GameData.getDefaultSettings(id)
    }
    setmetatable(entity._settings, settings_mt)
    local desc_mt = {
        __index = GameData.getDefaultDesc(id)
    }
    setmetatable(entity._desc, desc_mt)
    return entity
end

function EntityHandler.load(data)
    local entity = EntityHandler.new(data.id)
    entity._geometry.angle = data.angle
    entity._geometry.pos = data.pos
    entity._geometry.flip = data.flip
    entity._geometry.order = data.order
    entity._inventory = data.inventory
    if (data.settings) then
        for k, v in pairs(data.settings) do
            entity._settings[k] = v
        end
    end
    return entity
end

function EntityHandler:save(data)
    local data = {}
    data["id"] = self._desc["id"]
    data["angle"] = self._geometry.angle
    data["pos"] = self._geometry.pos
    data["flip"] = self._geometry.flip
    data["order"] = self._geometry.order
    data["inventory"] = self._inventory
    data["settings"] = self._settings
    return data
end

function EntityHandler:getId()
    local desc = self:__getDescription()
    return desc and desc.id or ""
end

function EntityHandler:getLayer()
    local desc = self:__getDescription()
    return desc.layer or 0
end

function EntityHandler:getOrder()
    return self._geometry.order or 0
end

function EntityHandler:setOrder(order)
    self._geometry.order = order
end

function EntityHandler:getPos()
    return self._geometry.pos or {0, 0}
end

function EntityHandler:getAngle()
    return self._geometry.angle or 0
end

function EntityHandler:getFlip()
    return self._geometry.flip or {false, false}
end

function EntityHandler:setPos(i, j)
    if (not self._geometry.pos) then
        self._geometry.pos = {i, j}
    else
        self._geometry.pos[1] = i
        self._geometry.pos[2] = j
    end
end

function EntityHandler:setObj(obj)
    if (not self._obj) then
        self._obj = obj
    end
end

function EntityHandler:setAngle(angle)
    self._geometry.angle = angle
    if (self._obj) then
        self._obj:setAngle(angle)
    end
end

function EntityHandler:setFlip(fliph, flipv)
    if (not self._geometry.flip) then
        self._geometry.flip = {fliph, flipv}
    else
        self._geometry.flip[1] = fliph
        self._geometry.flip[2] = flipv
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

function EntityHandler:getGeometry()
    local geometry = self:__getDefaultGeometry()
    if (1 == #geometry and 1 == geometry[1]) then return geometry end
    
    local result = geometry
    if (self._geometry.angle) then
        result = EntityHandler.rotateGeometry(result, self._geometry.angle)
    end
    if (self._geometry.flip) then
        result = EntityHandler.flipGeometry(result, self._geometry.flip[1], self._geometry.flip[2])
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
    {"CP:", "capacity_max"},
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
    {"Faction:",        "faction"},
    {"Name:",           "name"},
    {"Morale:",         "morale_cur", "morale_max"},
    {"Stamina:",        "stamina_cur", "stamina_max"},
    {"Health:",         "health_cur", "health_max"},
    {"Armour:",         "armour"},
    {"Action Points:",  "action_points_cur", "action_points_max"},
    {"Weapon Skill:",   "weapon_skill"},
    {"Damage:",         "damage"},
    {"Accuracy:",       "accuracy"},
    {"Capacity:",       "capacity_cur", "capacity_max"},
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
    return result
end

function EntityHandler:getEditParams()
    return self:__fillTemplateParams(_edit_params)
end

function EntityHandler:setEditParams(params)
    for _, param in ipairs(params) do
        for _, edit_param in ipairs(_edit_params) do
            if (param[1] == edit_param[1]) then
                for i = 2, #edit_param do
                    local key = edit_param[i]
                    if (not self._settings) then
                        self._settings = {}
                    end
                    self._settings[key] = param[i]
                end
                break
            end
        end
    end
end

function EntityHandler:getHotSpot()
    local desc = self:__getDescription()
    local size = desc.size or {0, 0}
    local angle = self._geometry.angle
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

function EntityHandler:isValid()
    return nil ~= self._obj
end

function EntityHandler:getInventory()
    if (self._inventory) then
        return self._inventory
    end
    return {}
end

function EntityHandler:hasInventory()
    local desc = self:__getDescription()
    return desc.has_inventory
end