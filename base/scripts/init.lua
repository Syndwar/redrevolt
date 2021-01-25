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

class "ProgressBar" (Widget)

class "Dialog" (Container)

class "ScrollContainer" (Container)

class "Screen" (Container)

class "Battlefield" (ScrollContainer)

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