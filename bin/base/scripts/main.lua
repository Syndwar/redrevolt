package.path = package.path .. ";./base/?.lua;./base/scripts/?.lua;./base/res/?.lua"

require("utils/file_system")
require("utils/observer")
require("system/config")
require("res/fonts")
require("res/textures")
require("res/sprites")
require("res/texts")
require("res/sounds")
require("res/music")
require("system/hotkeys")
require("system/usersave")

function main()
    UserSave:init()
end

function serialize()
    UserSave:save()
end

function exit()
end
