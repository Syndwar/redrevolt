Observer = {}

Observer._listeners = {}

function Observer:call(id, ...)
    for _, listener in ipairs(self._listeners) do
        if (listener.id == id) then
            listener.method(listener.holder, ...)
        end
    end
end

function Observer:addListener(id, holder, method)
    if (0 == #self._listeners) then
        table.insert(self._listeners, {id = id, holder = holder, method = method})
    else
        for _, listener in ipairs(self._listeners) do
            if (listener.id ~= id or listener.holder ~= holder or listener.method ~= method) then
                table.insert(self._listeners, {id = id, holder = holder, method = method})
                break
            end
        end
    end
end

function Observer:clear()
    if (0 ~= #self._listeners) then
        self._listeners = {}
    end
end