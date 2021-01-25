require("screens/loading_screen")
require("screens/start_screen")
require("screens/main_screen")
require("screens/test_screen")
require("screens/test_primitives_screen")
require("screens/test_fader_screen")
require("screens/test_font_screen")
require("screens/test_sound_screen")
require("screens/test_atlas_screen")
require("screens/test_widgets_screen")
require("screens/test_scroll_screen")
require("screens/test_battlefield_screen")
require("screens/options_screen")
require("screens/map_editor_screen")

Screens = {
    ["LoadingScreen"] = LoadingScreen,
    ["StartScreen"] = StartScreen,
    ["MainScreen"] = MainScreen,
    ["TestScreen"] = TestScreen,
    ["TestPrimitivesScreen"] = TestPrimitivesScreen,
    ["TestFaderScreen"] = TestFaderScreen,
    ["TestFontScreen"] = TestFontScreen,
    ["TestSoundScreen"] = TestSoundScreen,
    ["TestAtlasScreen"] = TestAtlasScreen,
    ["TestWidgetsScreen"] = TestWidgetsScreen,
    ["TestScrollScreen"] = TestScrollScreen,
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