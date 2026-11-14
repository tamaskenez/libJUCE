cmake_minimum_required(VERSION 3.22)

project(libjuce_test VERSION 0.1.0 LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if(NOT CMAKE_PREFIX_PATH)
    set(CMAKE_PREFIX_PATH "${CMAKE_SOURCE_DIR}/_d")
endif()

# JUCE installed by ./1_build_juce.sh; pass -DCMAKE_PREFIX_PATH=<repo>/_d
find_package(JUCE CONFIG REQUIRED)

juce_add_console_app(test_console)

target_sources(test_console PRIVATE src/main.cpp)

target_link_libraries(test_console
    PRIVATE
        juce::juce_core
    PUBLIC
        juce::juce_recommended_config_flags
        juce::juce_recommended_warning_flags)
