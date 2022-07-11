require("class")

class "Widget"

function Widget:instantiate(id)
    self.this = id and self.new(id) or self.new()
    return self.this
end

function Widget:getInstance()
    return self.this
end

class "Area" (Widget)

class "Timer" (Widget)

class "Image" (Widget)

class "Label" (Widget) 

class "TextEdit" (Widget) 

class "Button" (Widget) 

class "Fader" (Widget)

class "Primitive" (Widget)

class "Container" (Widget)

function Container:getUI(id)
    if (self._ui) then
        return self._ui[id]
    end
    return nil
end

function Container:setUI(id, widget)
    if (not self._ui) then
        self._ui = {}
    end
    assert(not self._ui[id], string.format("Duplicate found in UI: %s", id))
    self._ui[id] = widget
end

class "ProgressBar" (Widget)

class "Dialog" (Container)

class "ScrollContainer" (Container)

class "Screen" (Container)

function Screen:load()
    if (SystemToolsPanel) then
        SystemToolsPanel:reset()
        self:attach(SystemToolsPanel)
    end
    Game.changeScreen(self)
end

function Screen:unload()
    if (SystemToolsPanel) then
        self:detach(SystemToolsPanel)
    end
    Observer:clear()
end

class "Battlefield" (ScrollContainer)

