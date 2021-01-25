require("base/scripts/config")
require("base/scripts/utils/table_ext")

local USERSAVEFILE = "save/user.sav"
local USERCONFIGFILE = "save/config.sav"

UserSaveDataDefault = 
{
    user_name = "Syndwar",
    created = nil,
    config = {},
    screens_queue = {},
    current_screen = nil,
}

UserSaveData = {}

UserSave = {}

function UserSave:init()
    self.load()
    if (not UserSaveData.created) then
        UserSaveData = table.deepcopy(UserSaveDataDefault);
        UserSaveData.created = os.time()
        for k, v in pairs(Config) do
            UserSaveData.config[k] = v
        end
    end
end

function UserSave:save()
    table.totxt(UserSaveData.config, USERCONFIGFILE)
    
    local current_screen = UserSaveData.current_screen
    UserSaveData.current_screen = nil
    
    local config = UserSaveData.config
    UserSaveData.config = nil
    
    table.totxt(UserSaveData, USERSAVEFILE)

    UserSaveData.config = config
    UserSaveData.current_screen = current_screen
end

function UserSave:load()
    local f = io.open(USERSAVEFILE, "r")
    if (f) then
        io.close(f)
        UserSaveData = dofile(USERSAVEFILE)
    end
    local cf = io.open(USERCONFIGFILE, "r")
    if (cf) then
        io.close(cf)
        UserSaveData.config = dofile(USERCONFIGFILE)
    end
end

function UserSave:getConfig()
    return UserSaveData.config or {}
end

function UserSave:getNextScreen()
    local queue = UserSaveData.screens_queue
    return queue[#queue]
end

function UserSave:popNextScreen()
    local queue = UserSaveData.screens_queue
    queue[#queue] = nil
end

function UserSave:addNextScreen(id)
    local queue = UserSaveData.screens_queue
    table.insert(queue, id)
end

function UserSave:setCurrentScreen(screen)
    UserSaveData.current_screen = screen
end

function UserSave:getCurrentScreen()
    return UserSaveData.current_screen
end

function UserSave:isVSync()
    local config = self.getConfig()
    return config.vsync or false
end

function UserSave:setVSync(value)
    local config = self.getConfig()
    config.vsync = value
end

function UserSave:isBorderless()
    local config = self.getConfig()
    return config.borderless or false
end

function UserSave:setBorderless(value)
    local config = self.getConfig()
    config.borderless = value
end

function UserSave:isFullscreen()
    local config = self.getConfig()
    return config.fullscreen or false
end

function UserSave:setFullscreen(value)
    local config = self.getConfig()
    config.fullscreen = value
end

function UserSave:getScreenWidth()
    local config = self.getConfig()
    return config.screen_width or 1024
end

function UserSave:setScreenWidth(value)
    local config = self.getConfig()
    config.screen_width = value
end

function UserSave:getScreenHeight()
    local config = self.getConfig()
    return config.screen_height or 768
end

function UserSave:setScreenHeight(value)
    local config = self.getConfig()
    config.screen_height = value
end

function UserSave:getFPSLimit()
    local config = self.getConfig()
    return config.fps_limit or 0
end

function UserSave:getTitle()
    local config = self.getConfig()
    return config.title or "GAME"
end