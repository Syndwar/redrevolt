require("screens/test_battlefield_screen")
require("screens/options_screen")
require("screens/map_editor_screen")

Screens = {
    ["TestBattlefieldScreen"] = TestBattlefieldScreen,
    ["OptionsScreen"] = OptionsScreen,
    ["MapEditorScreen"] = MapEditorScreen,
}

function Screens.load(id, next_id)
    UserSave:addNextScreen(next_id)
    
    local current_screen = UserSave:getCurrentScreen()
    if (current_screen) then
        current_screen:unload()
    end

    local screen_class = Screens[id]
    assert(screen_class, string.format("[Error]: Screen %s was not created", id))
    local screen = screen_class(id)
    screen:load()
    UserSave:setCurrentScreen(screen)
end
