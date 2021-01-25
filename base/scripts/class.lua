function class(base)
    if (not _G[base]) then
        _G[base] = {}
    end
    local c = _G[base]
    c.__index = c

    -- expose a constructor which can be called by <classname>(<args>)
    local mt = {}
    mt.__call = function(self, ...)
        local obj = {}
        setmetatable(obj, c)
        if (self.instantiate) then
            self.instantiate(obj, ...)
        end
        if self.init then
           self.init(obj, ...)
        end

        return obj
    end

    setmetatable(c, mt)

    local inherit = function(parent)
        if (type(parent) == "table") then
            -- our new class is a shallow copy of the base class!
            for k, v in pairs(parent) do
                if (not c[k]) then
                    c[k] = v
                end
            end
        end
    end

    return inherit
end

function cast(given, target)
    setmetatable(given, target)
    return given
end