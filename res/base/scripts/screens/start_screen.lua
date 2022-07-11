class "StartScreen" (Screen)

function StartScreen:init(id)
    local screen_width = Engine.getScreenWidth()
    local screen_height = Engine.getScreenHeight()

    local logo_btn = Button("logo_btn")
    logo_btn:setRect(0, 0, screen_width, screen_height)
    logo_btn:setAlignment("LEFT|TOP", 0, 0)
    logo_btn:addCallback("MouseUp_Left", self.goToNextScreen, self)
    self:attach(logo_btn)

    local lbl = Label()
    lbl:setRect(0, 0, 200, 40)
    lbl:setText("Click to continue.")
    lbl:setAlignment("CENTER|BOTTOM", -40, 0)
    lbl:setFont("system_24_fnt")
    lbl:setColour("white")
    lbl:setTextAlignment("CENTER|BOTTOM")
    self:attach(lbl)

    local timer = Timer()
    timer:addCallback("TimerElapsed", self.goToNextScreen, self)
    self:attach(timer)
    
    timer:restart(5000)
end

function StartScreen:goToNextScreen()
    Screens.load("LoadingScreen", "MainScreen")
end