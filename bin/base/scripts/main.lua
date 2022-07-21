package.path = package.path .. ";./base/scripts/?.lua;./base/res/?.lua"

require("utils/file_system")
require("utils/observer")
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

function main()
    UserSave:init()
end

function serialize()
    UserSave:save()
end

function exit()
end
