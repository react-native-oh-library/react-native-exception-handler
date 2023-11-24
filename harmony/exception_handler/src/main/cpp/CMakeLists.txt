cmake_minimum_required(VERSION 3.13)
set(CMAKE_VERBOSE_MAKEFILE on)

file(GLOB rnoh_exception_handler_SRC CONFIGURE_DEPENDS *.cpp)
add_library(rnoh_exception_handler SHARED ${rnoh_exception_handler_SRC})
target_include_directories(rnoh_exception_handler PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_link_libraries(rnoh_exception_handler PUBLIC rnoh)
