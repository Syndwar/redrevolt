class "OptionsScreen" (Screen)

local kVSyncOn = "VSync On"
local kVSyncOff = "VSync Off"
local kWindowBorderOn = "Window Border On"
local kWindowBorderOff = "Window Border Off"
local kFullscreenOn = "Fullscreen On"
local kFullscreenOff = "Fullscreen Off"

local kResolutions = {
    { 800, 600 },
    { 1024, 768 },
    { 1280, 720 },
    { 1360, 768 },
    { 1600, 1900 },
    { 1920, 1080 }
}

function OptionsScreen:init()
    local saved_config = UserSave:getConfig()

    self.is_vsync = UserSave:isVSync()
    self.is_borderless = UserSave:isBorderless()
    self.is_fullscreen = UserSave:isFullscreen()
    self.res_index = 1
    self.res_buttons = {}

    local btn = Button("backBtn")
    btn:setText("Main Screen")
    btn:setFont("system_15_fnt")
    btn:setRect(0, 0, 256, 64)
    btn:setColour("red")
    btn:setTextAlignment("CENTER|MIDDLE")
    btn:setAlignment("RIGHT|TOP", -64, 64)
    btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    btn:addCallback("MouseUp_Left", self.onBackBtnClick, self)
    self:attach(btn)

    btn = Button("applyBtn")
    btn:setText("Apply")
    btn:setFont("system_15_fnt")
    btn:setRect(0, 0, 256, 64)
    btn:setAlignment("RIGHT|BOTTOM", -64, -64)
    btn:setTextAlignment("CENTER|MIDDLE")
    btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    btn:setColour("white")
    btn:addCallback("MouseUp_Left", self.onApplyBtnClick, self)
    self:attach(btn)

    self.vsync_btn = Button("vsyncBtn")
    self.vsync_btn:setText(self.is_vsync and kVSyncOn or kVSyncOff)
    self.vsync_btn:setFont("system_15_fnt")
    self.vsync_btn:setRect(0, 0, 256, 64)
    self.vsync_btn:setAlignment("LEFT|TOP", 64, 64)
    self.vsync_btn:setTextAlignment("CENTER|MIDDLE")
    self.vsync_btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    self.vsync_btn:setColour(self.is_vsync and "green" or "red")
    self.vsync_btn:addCallback("MouseUp_Left", self.onVsyncBtnClick, self)
    self:attach(self.vsync_btn)

    self.borderless_btn = Button("borderlessBtn")
    self.borderless_btn:setText(self.is_borderless and kWindowBorderOn or kWindowBorderOff)
    self.borderless_btn:setFont("system_15_fnt")
    self.borderless_btn:setRect(0, 0, 256, 64)
    self.borderless_btn:setAlignment("LEFT|TOP", 64, 128)
    self.borderless_btn:setTextAlignment("CENTER|MIDDLE")
    self.borderless_btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    self.borderless_btn:setColour(self.is_borderless and "green" or "red")
    self.borderless_btn:addCallback("MouseUp_Left", self.onBorderlessBtnClick, self)
    self:attach(self.borderless_btn)

    self.fullscreen_btn = Button("fullscreenBtn")
    self.fullscreen_btn:setText(self.is_fullscreen and kFullscreenOn or kFullscreenOff)
    self.fullscreen_btn:setFont("system_15_fnt")
    self.fullscreen_btn:setRect(0, 0, 256, 64)
    self.fullscreen_btn:setAlignment("LEFT|TOP", 64, 196)
    self.fullscreen_btn:setTextAlignment("CENTER|MIDDLE")
    self.fullscreen_btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    self.fullscreen_btn:setColour(self.is_fullscreen and "green" or "red")
    self.fullscreen_btn:addCallback("MouseUp_Left", self.onFullscreenBtnClick, self)
    self:attach(self.fullscreen_btn)

    local screen_width = Engine.getScreenWidth()
    local screen_height = Engine.getScreenHeight()

    for i, res in ipairs(kResolutions) do
        local is_selected = screen_width == res[1] and screen_height == res[2]

        btn = Button()
        btn:setText(string.format("%ix%i", res[1], res[2]))
        btn:setFont("system_15_fnt")
        btn:setRect(0, 0, 256, 64)
        btn:addCallback("MouseUp_Left", self.onResolutionBtnClick, {self, btn})
        btn:setTextAlignment("CENTER|MIDDLE")
        btn:setAlignment("LEFT|TOP", 320, (i + 1) * 64)
        btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
        btn:setColour(is_selected and "green" or "red")
        self:attach(btn)

        table.insert(self.res_buttons, btn)

        if (is_selected) then
            self.res_index = i
        end
    end
end

function OptionsScreen:onBackBtnClick()
    Screens.load("LoadingScreen", "MainScreen")
end

function OptionsScreen:onApplyBtnClick()
    UserSave:setVSync(self.is_vsync)
    UserSave:setBorderless(self.is_borderless)
    UserSave:setFullscreen(self.is_fullscreen)
    local res = kResolutions[self.res_index]
    UserSave:setScreenWidth(res[1])
    UserSave:setScreenHeight(res[2])
    UserSave:save()

    Engine.addCommand({id = "restart"})
end

function OptionsScreen:onVsyncBtnClick()
    self.is_vsync = not self.is_vsync
    if (self.vsync_btn) then
        self.vsync_btn:setText(self.is_vsync and kVSyncOn or kVSyncOff)
        self.vsync_btn:setColour(self.is_vsync and "green" or "red")
    end
end

function OptionsScreen:onBorderlessBtnClick()
    self.is_borderless = not self.is_borderless

    if (self.borderless_btn) then
        self.borderless_btn:setText(self.is_borderless and kWindowBorderOn or kWindowBorderOff)
        self.borderless_btn:setColour(self.is_borderless and "green" or "red")
    end
end

function OptionsScreen:onFullscreenBtnClick()
    self.is_fullscreen = not self.is_fullscreen
    if (self.fullscreen_btn) then
        self.fullscreen_btn:setText(self.is_fullscreen and kFullscreenOn or kFullscreenOff)
        self.fullscreen_btn:setColour(self.is_fullscreen and "green" or "red")
    end
end

function OptionsScreen.onResolutionBtnClick(params)
    local self = params[1]
    local sender = params[2]

    for i, btn in ipairs(self.res_buttons) do
        if (btn == sender) then
            btn:setColour("green")
            self.res_index = i
        else
            btn:setColour("red")
        end
    end
end
