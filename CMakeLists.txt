cmake_minimum_required(VERSION 3.5)

project(3dViewer VERSION 0.1 LANGUAGES CXX C)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_PREFIX_PATH "/Users/kirillsmagin/Qt/6.4.2/macos/lib/cmake")

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Widgets)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Widgets)
find_package(Qt6 REQUIRED COMPONENTS OpenGLWidgets)
find_package(Qt6 REQUIRED COMPONENTS QuickWidgets)
find_package(Qt6 REQUIRED COMPONENTS Quick3D)
find_package(Qt6 REQUIRED COMPONENTS Charts)
find_package(Qt6 REQUIRED COMPONENTS PrintSupport)  # Добавлено

include(FetchContent)
FetchContent_Declare(
      googletest
      URL https://github.com/google/googletest/archive/03597a01ee50ed33e9dfd640b249b4be3799d395.zip
)

set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
FetchContent_MakeAvailable(googletest)

enable_testing()

include_directories(.)
include_directories(Model)
include_directories(Controller)
include_directories(View)
include_directories(Tests)


set(PROJECT_SOURCES
        main.cpp
        ./View/modelfacade.h
        ./View/modelview.h
        ./View/modelview.cc
        ./View/modelinstance.cc
        ./View/modelinstance.h
        ./View/gradienttex.cc
        ./View/gradienttex.h
        ./Controller/controller.h
        ./Controller/controller.cc
        ./Model/saveload.cc
        ./Model/saveload.h
        ./Model/gifcreator.cc
        ./Model/gifcreator.h
        ./Model/gif.h
        ./Model/modelcore.h
        ./Model/modelcore.cc
)

if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
    qt_add_executable(3dViewer
        MANUAL_FINALIZATION
        ${PROJECT_SOURCES}
    )
else()
    if(ANDROID)
        add_library(3dViewer SHARED
            ${PROJECT_SOURCES}
        )
    else()
        add_executable(3dViewer
            ${PROJECT_SOURCES}
        )
    endif()
endif()

target_link_libraries(3dViewer PRIVATE Qt6::QuickWidgets)
target_link_libraries(3dViewer PRIVATE Qt6::OpenGLWidgets)
target_link_libraries(3dViewer PRIVATE Qt6::Gui)
target_link_libraries(3dViewer PRIVATE Qt6::Quick3D)

qt_add_qml_module(3dViewer
    URI Example
    VERSION 1.0
    QML_FILES
        main.qml
    NO_RESOURCE_TARGET_PATH
)

target_compile_options(3dViewer PRIVATE -std=c++17 -Wall -Werror -Wextra)

set_target_properties(3dViewer PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

install(TARGETS 3dViewer
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})

if(QT_VERSION_MAJOR EQUAL 6)
    qt_finalize_executable(3dViewer)
endif()

set_target_properties(3dViewer PROPERTIES LINKER_LANGUAGE CXX)

add_executable(3dViewer_Tests
   ./Tests/tests.cc
   ./Model/modelcore.h
   ./Model/modelcore.cc
)

target_link_libraries(3dViewer_Tests PRIVATE
   Qt${QT_VERSION_MAJOR}::Widgets
   Qt${QT_VERSION_MAJOR}::Charts
   Qt${QT_VERSION_MAJOR}::PrintSupport
   GTest::gtest_main
)

include(GoogleTest)
gtest_discover_tests(3dViewer_Tests)
