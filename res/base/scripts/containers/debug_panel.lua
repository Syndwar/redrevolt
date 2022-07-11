class "DebugPanel" (Dialog)

function DebugPanel:init()
    self.fps_lbl = Label("fpsLbl")
    self.fps_lbl:setFont("system_15_fnt")
    self.fps_lbl:setTextAlignment("CENTER|MIDDLE")
    self.fps_lbl:setRect(0, 0, 100, 30)
    self.fps_lbl:setColour("green")
    self.fps_lbl:setAlignment("LEFT|TOP", 0, 0)
    self.fps_lbl:setText("0")
    self:attach(self.fps_lbl)

    self.mouse_pos_lbl = Label("mousePosLbl")
    self.mouse_pos_lbl:setFont("system_15_fnt")
    self.mouse_pos_lbl:setTextAlignment("CENTER|MIDDLE")
    self.mouse_pos_lbl:setRect(0, 0, 120, 30)
    self.mouse_pos_lbl:setColour("green")
    self.mouse_pos_lbl:setAlignment("RIGHT|TOP", 0, 0)
    self.mouse_pos_lbl:setText("0")
    self:attach(self.mouse_pos_lbl)

    self.timer = Timer("updateTimer")
    self.timer:restart(100)
    self.timer:addCallback("TimerElapsed", self.onTimerElapsed, self)
    self:attach(self.timer)
end

local mouse_pos_format = "%s|%s"

function DebugPanel:onTimerElapsed()
    if (self.fps_lbl) then
        self.fps_lbl:setText(Engine.getFPS())
    end
    if (self.mouse_pos_lbl) then
        local x, y = Engine.getMousePos()
        self.mouse_pos_lbl:setText(string.format(mouse_pos_format, x, y))
    end
    if (self.timer) then
        self.timer:restart(100)
    end
end