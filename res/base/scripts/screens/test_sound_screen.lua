class "TestSoundScreen" (Screen)

function TestSoundScreen:init()
    local btn = Button("backBtn");
    btn:setText("Exit");
    btn:setFont("system_15_fnt");
    btn:setRect(0, 0, 256, 64);
    btn:setTextAlignment("CENTER|MIDDLE");
    btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    btn:addCallback("MouseUp_Left", self.onBackBtnClick, self);
    btn:setColour("red");
    self:attach(btn);

    btn = Button("playMusicBtn");
    btn:setText("Music On");
    btn:setFont("system_15_fnt");
    btn:setRect(256, 0, 256, 64);
    btn:setTextAlignment("CENTER|MIDDLE");
    btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    btn:addCallback("MouseUp_Left", self.onPlayMusicBtnClick, self);
    btn:setColour("red");
    self:attach(btn);

    btn = Button("stopMusicBtn");
    btn:setText("Music Off");
    btn:setFont("system_15_fnt");
    btn:setRect(256, 64, 256, 64);
    btn:setTextAlignment("CENTER|MIDDLE");
    btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    btn:addCallback("MouseUp_Left", self.onStopMusicBtnClick, self);
    btn:setColour("red");
    self:attach(btn);

    btn = Button("playSoundBtn");
    btn:setText("Play Sound");
    btn:setFont("system_15_fnt");
    btn:setRect(512, 0, 256, 64);
    btn:setTextAlignment("CENTER|MIDDLE");
    btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    btn:addCallback("MouseUp_Left", self.onPlaySoundBtnClick, self);
    btn:setColour("red");
    self:attach(btn);

    btn = Button("playDoubleSoundBtn");
    btn:setText("Play Double Sound");
    btn:setFont("system_15_fnt");
    btn:setRect(512, 64, 256, 64);
    btn:setTextAlignment("CENTER|MIDDLE");
    btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    btn:addCallback("MouseUp_Left", self.onPlayDoubleSoundBtnClick, self);
    btn:setColour("red");
    self:attach(btn);
end

function TestSoundScreen:onBackBtnClick()
    Screens.load("LoadingScreen", "TestScreen")
end

function TestSoundScreen:onPlayMusicBtnClick()
    Engine.addCommand({id = "play_music", value = "main_menu_mus"})
end

function TestSoundScreen:onStopMusicBtnClick()
    Engine.addCommand({id = "stop_music"})
end

function TestSoundScreen:onPlaySoundBtnClick()
    Engine.addCommand({id = "play_sound", value = "kick_snd", loop = 0})
end

function TestSoundScreen:onPlayDoubleSoundBtnClick()
    Engine.addCommand({id = "play_sound", value = "kick_snd", loop = 1})
end
