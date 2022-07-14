require("containers/system_tools")

class "MainScreen"(Screen)

MainScreen.desc = 
{
    ui = {
        {
            type = "Button",
            id = "testBtn",
            text = "Test Screen",
            font = "system_15_fnt",
            rect = {0, 0, 256, 64},
            colour = "green",
            text_align = {"CENTER|MIDDLE"},
            sprites = {"up_btn_spr", "down_btn_spr", "over_btn_sptr"},
            callback = {"MouseUp_Left", "MainScreen.onTestBtnClicked"}
        },
        {
            type = "Button",
            id = "newGameBtn",
            text = "New Game",
            font = "system_15_fnt",
            rect = {0, 0, 256, 64},
            align = {"RIGHT|TOP", -64, 64},
            colour = "white",
            text_align = {"CENTER|MIDDLE"},
            sprites = {"up_btn_spr", "down_btn_spr", "over_btn_sptr"},
            callback = {"MouseUp_Left", "MainScreen.onNewGameBtnClicked"}
        },
        {
            type = "Button",
            id = "loadGameBtn",
            text = "Load Game",
            font = "system_15_fnt",
            rect = {0, 0, 256, 64},
            align = {"RIGHT|TOP", -64, 138},
            colour = "white",
            text_align = {"CENTER|MIDDLE"},
            sprites = {"up_btn_spr", "down_btn_spr", "over_btn_sptr"},
            callback = {"MouseUp_Left", "MainScreen.onLoadGameBtnClicked"}
        },
        {
            type = "Button",
            id = "optionsBtn",
            text = "Options",
            font = "system_15_fnt",
            rect = {0, 0, 256, 64},
            align = {"RIGHT|TOP", -64, 212},
            colour = "white",
            text_align = {"CENTER|MIDDLE"},
            sprites = {"up_btn_spr", "down_btn_spr", "over_btn_sptr"},
            callback = {"MouseUp_Left", "MainScreen.onOptionsBtnClicked"}
        },
        {
            type = "Button",
            id = "mapEditorBtn",
            text = "Map Editor",
            font = "system_15_fnt",
            rect = {0, 0, 256, 64},
            align = {"RIGHT|TOP", -64, 286},
            colour = "white",
            text_align = {"CENTER|MIDDLE"},
            sprites = {"up_btn_spr", "down_btn_spr", "over_btn_sptr"},
            callback = {"MouseUp_Left", "MainScreen.onMapEditorBtnClicked"}
        },
        {
            type = "Button",
            id = "exitBtn",
            text = "Exit",
            font = "system_15_fnt",
            rect = {0, 0, 256, 64},
            align = {"RIGHT|TOP", -64, -64},
            colour = "red",
            text_align = {"CENTER|MIDDLE"},
            sprites = {"up_btn_spr", "down_btn_spr", "over_btn_sptr"},
            callback = {"MouseUp_Left", "MainScreen.onExitBtnClicked"}
        }
        }
}

function MainScreen:init()
    local btn = Button("testBtn")
    btn:setText("Test Screen")
    btn:setFont("system_15_fnt")
    btn:setRect(0, 0, 256, 64)
    btn:setColour("green")
    btn:setTextAlignment("CENTER|MIDDLE")
    btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    btn:addCallback("MouseUp_Left", self.onTestBtnClicked, self)
    self:attach(btn)

    btn = Button("newGameBtn")
    btn:setText("New Game")
    btn:setFont("system_15_fnt")
    btn:setRect(0, 0, 256, 64)
    btn:setAlignment("RIGHT|TOP", -64, 64)
    btn:setTextAlignment("CENTER|MIDDLE")
    btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    btn:addCallback("MouseUp_Left", self.onNewGameBtnClicked, self)
    self:attach(btn)

    btn = Button("loadGameBtn")
    btn:setText("Load Game")
    btn:setFont("system_15_fnt")
    btn:setRect(0, 0, 256, 64)
    btn:setAlignment("RIGHT|TOP", -64, 138)
    btn:setTextAlignment("CENTER|MIDDLE")
    btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    btn:addCallback("MouseUp_Left", self.onLoadGameBtnClicked, self)
    self:attach(btn)

    btn = Button("optionsBtn")
    btn:setText("Options")
    btn:setFont("system_15_fnt")
    btn:setRect(0, 0, 256, 64)
    btn:setAlignment("RIGHT|TOP", -64, 212)
    btn:setTextAlignment("CENTER|MIDDLE")
    btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    btn:addCallback("MouseUp_Left", self.onOptionsBtnClicked, self)
    self:attach(btn)

    btn = Button("mapEditorBtn")
    btn:setText("Map Editor")
    btn:setFont("system_15_fnt")
    btn:setRect(0, 0, 256, 64)
    btn:setAlignment("RIGHT|TOP", -64, 286)
    btn:setTextAlignment("CENTER|MIDDLE")
    btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    btn:addCallback("MouseUp_Left", self.onMapEditorBtnClicked, self)
    self:attach(btn)

    btn = Button("exitBtn")
    btn:setText("Exit")
    btn:setFont("system_15_fnt")
    btn:setRect(0, 0, 256, 64)
    btn:setColour("red")
    btn:setAlignment("RIGHT|BOTTOM", -64, -64)
    btn:setTextAlignment("CENTER|MIDDLE")
    btn:setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr")
    btn:addCallback("MouseUp_Left", self.onExitBtnClicked, self)
    self:attach(btn)
end

function MainScreen:onExitBtnClicked()
    Engine.addCommand({id = "shutdown"})
end

function MainScreen:onMapEditorBtnClicked()
    Screens.load("LoadingScreen", "MapEditorScreen")
end

function MainScreen:onOptionsBtnClicked()
    Screens.load("LoadingScreen", "OptionsScreen")
end

function MainScreen:onLoadGameBtnClicked()
end

function MainScreen:onNewGameBtnClicked()
end

function MainScreen:onTestBtnClicked()
    Screens.load("LoadingScreen", "TestScreen")
end
