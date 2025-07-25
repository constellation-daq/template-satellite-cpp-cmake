# SPDX-FileCopyrightText: 2025 DESY and the Constellation authors
# SPDX-License-Identifier: CC0-1.0

cmake_minimum_required(VERSION 3.11 FATAL_ERROR)
project(TemplateSatellite VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED TRUE)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Find Constellation via pkg-config
find_package(PkgConfig REQUIRED)
pkg_check_modules(CNSTLN_SAT REQUIRED ConstellationSatellite)
pkg_check_modules(CNSTLN_EXEC REQUIRED ConstellationExec)

# Create shared library for satellite
add_library(TemplateSatelliteLib SHARED "TemplateSatellite.cpp" "generator.cpp")

# Add Constellation dependencies
target_include_directories(TemplateSatelliteLib PUBLIC ${CNSTLN_SAT_INCLUDE_DIRS})
target_link_directories(TemplateSatelliteLib PUBLIC ${CNSTLN_SAT_LIBRARY_DIRS})
target_link_libraries(TemplateSatelliteLib PUBLIC ${CNSTLN_SAT_LIBRARIES})
target_compile_options(TemplateSatelliteLib PUBLIC ${CNSTLN_SAT_CFLAGS_OTHER})
set_target_properties(TemplateSatelliteLib PROPERTIES INSTALL_RPATH_USE_LINK_PATH TRUE)

# Set library output name to satellite type (used in `Satellite -t`)
set_target_properties(TemplateSatelliteLib PROPERTIES LIBRARY_OUTPUT_NAME "Template")

# Create executable for satellite
add_executable(SatelliteTemplate "main.cpp")

# Add Constellation dependencies
target_include_directories(SatelliteTemplate PUBLIC ${CNSTLN_EXEC_INCLUDE_DIRS})
target_link_directories(SatelliteTemplate PUBLIC ${CNSTLN_EXEC_LIBRARY_DIRS})
target_link_libraries(SatelliteTemplate PUBLIC ${CNSTLN_EXEC_LIBRARIES})
target_compile_options(SatelliteTemplate PUBLIC ${CNSTLN_EXEC_CFLAGS_OTHER})
set_target_properties(SatelliteTemplate PROPERTIES INSTALL_RPATH_USE_LINK_PATH TRUE)

# Get Constellation prefix for library and executable
set(CNSTLN_SAT_LIB_INSTALL_DIR "${CNSTLN_EXEC_LIBDIR}/ConstellationSatellites")
pkg_get_variable(CNSTLN_SAT_EXEC_INSTALL_DIR ConstellationExec bindir)

# Install library and executable
message(STATUS "Installing satellite library to: \"${CNSTLN_SAT_LIB_INSTALL_DIR}\"")
message(STATUS "Installing satellite executable to: \"${CNSTLN_SAT_EXEC_INSTALL_DIR}\"")
install(TARGETS
    TemplateSatelliteLib
    SatelliteTemplate
    LIBRARY DESTINATION ${CNSTLN_SAT_LIB_INSTALL_DIR}
    RUNTIME DESTINATION ${CNSTLN_SAT_EXEC_INSTALL_DIR}
)
