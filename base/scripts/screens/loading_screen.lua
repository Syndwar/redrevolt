class "LoadingScreen" (Screen)

function LoadingScreen:init()
    local lbl = Label()
    lbl:setRect(0, 0, 200, 40)
    lbl:setText("Loading...")
    lbl:setAlignment("CENTER|MIDDLE", 0, 0)
    lbl:setFont("system_24_fnt")
    lbl:setColour("white")
    lbl:setTextAlignment("CENTER|BOTTOM")
    self:attach(lbl)

    local timer = Timer()
    timer:addCallback("TimerElapsed", self.goToScreen, self)
    self:attach(timer)
    
    timer:restart(1000)
end

function LoadingScreen:goToScreen()
    local next_screen_id = UserSave:getNextScreen()
    UserSave:popNextScreen()
    Screens.load(next_screen_id)
end
