EntityHandler = {
    __id = nil,
    __pos = nil,
    __angle = nil,
    __flip = nil,
    __settings = nil,
    __inventory = nil,
}

function EntityHandler.new(id)
    local entity = table.deepcopy(EntityHandler)
    entity.__id = id
    return entity
end

function EntityHandler:getId()
    return self.__id or ""
end

function EntityHandler:getPos()
    return self.__pos or {0, 0}
end

function EntityHandler:getAngle()
    return self.__angle or 0
end

function EntityHandler:getFlip()
    return self.__flip or {false, false}
end

function EntityHandler:setPos(i, j)
    if (not self.__pos) then
        self.__pos = {i, j}
    else
        self.__pos[1] = i
        self.__pos[2] = j
    end
end

function EntityHandler:setAngle(angle)
    self.__angle = angle
end

function EntityHandler:setFlip(fliph, flipv)
    if (not self.__flip) then
        self.__flip = {fliph, flipv}
    else
        self.__flip[1] = fliph
        self.__flip[2] = flipv
    end
end

function EntityHandler:setSettings(settings)
    self.settings = table.deepcopy(settings or GameData.getDefaultSettings(self.__id))
end