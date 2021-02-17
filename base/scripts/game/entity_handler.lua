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
    return desc and desc.sprite or nil
end

function EntityHandler:getName()
    local settings = self._settings or self._default_settings
    return settings and settings.name or nil
end