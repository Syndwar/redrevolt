package.path = package.path .. ";./base/scripts/?.lua;./base/res/?.lua"

require("init")
require("observer")
require("config")
require("fonts")
require("textures")
require("sprites")
require("texts")
require("sounds")
require("music")
require("hotkeys")

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

    Engine.deserialize()
    Engine.createGame()

    SystemToolsPanel = SystemTools("systemTools")

    Screens.load("LoadingScreen", "MapEditorScreen")
end

function exit()
    SystemToolsPanel = nil
end