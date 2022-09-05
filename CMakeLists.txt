cmake_minimum_required(VERSION "3.23.2")

set(CMAKE_CXX_STANDARD 11) # specify the C++ standard
set(CMAKE_CXX_STANDARD_REQUIRED True)

project("redrevolt" VERSION 0.1)

# Set defaults preventing destination file conflicts
set(RED_CMAKE_DEBUG_POSTFIX "d" CACHE STRING "Name suffix for debug builds")

add_subdirectory(libs/stren)

configure_file(src/config.h.in config.h)
configure_file(src/version.rc.in version.rc)

add_executable(${PROJECT_NAME} WIN32 
    src/main.cpp
    src/redrevolt_game.cpp

    src/loading_screen.cpp
    src/main_screen.cpp
    src/start_screen.cpp
    src/options_screen.cpp
    src/map_editor_screen.cpp
    src/map_editor_system_panel.cpp
    src/test_screen.cpp
    src/test_dialog.cpp
    src/test_atlas_screen.cpp
    src/test_font_screen.cpp
    src/test_sound_screen.cpp
    src/test_scroll_screen.cpp
    src/test_fader_screen.cpp
    src/test_widgets_screen.cpp
    src/test_primitives_screen.cpp
    src/test_battlefield_screen.cpp

    src/system_tools.cpp
    src/console.cpp
    src/debug_panel.cpp
    src/widgets_tree.cpp
    src/widget_tree_branch.cpp
    version.rc)

set_target_properties(${PROJECT_NAME} PROPERTIES DEBUG_POSTFIX ${RED_CMAKE_DEBUG_POSTFIX})

list(APPEND RED_EXTRA_INCLUDE_DIR 
    src
)
target_include_directories(${PROJECT_NAME} INTERFACE ${PROJECT_BINARY_DIR} ${RED_EXTRA_INCLUDE_DIR})

list(APPEND RED_EXTRA_LIBS 
    stren
    SDL2
    SDL2main
)

target_link_libraries(${PROJECT_NAME} PUBLIC ${RED_EXTRA_LIBS})

install(TARGETS ${PROJECT_NAME} RUNTIME DESTINATION "bin")
