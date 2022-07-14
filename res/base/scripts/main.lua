package.path = package.path .. ";./base/scripts/?.lua;./base/res/?.lua"

require("init")
require("file_system")
require("observer")
require("config")
require("fonts")
require("textures")
require("sprites")
require("texts")
require("sounds")
require("music")
require("hotkeys")
require("ui_builder")

require("usersave")

require("game/gamedata")
require("screens")

function log(...)
    if (SystemToolsPanel) then
        SystemToolsPanel:log(...)
    end
end

function main()
    UserSave:init()

    Engine.addCommand({id = "deserialize"})
    Engine.addCommand({id = "create_game"})

    SystemToolsPanel = SystemTools("systemTools")

    Screens.load("MainScreen", "MainScreen")
end

function exit()
    SystemToolsPanel = nil
end
