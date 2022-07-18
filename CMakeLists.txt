cmake_minimum_required(VERSION "3.23.2")

set(CMAKE_CXX_STANDARD 11) # specify the C++ standard
set(CMAKE_CXX_STANDARD_REQUIRED True)

project("redrevolt" VERSION 0.1)

# Set defaults preventing destination file conflicts
set(RED_CMAKE_DEBUG_POSTFIX "d" CACHE STRING "Name suffix for debug builds")

add_subdirectory(libs/stren)

configure_file(src/config.h.in config.h)
configure_file(src/version.rc.in version.rc)

add_executable(${PROJECT_NAME} WIN32 src/main.cpp version.rc)

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
