# SPDX-FileCopyrightText: 2025 DESY and the Constellation authors
# SPDX-License-Identifier: CC0-1.0

cmake_minimum_required(VERSION 3.11 FATAL_ERROR)
project(templatesatellite VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED TRUE)
set(CMAKE_CXX_STANDARD 20)

# Find Constellation via pkg-config
find_package(PkgConfig REQUIRED)
pkg_check_modules(CNSTLN_SAT REQUIRED ConstellationSatellite)
pkg_check_modules(CNSTLN_EXEC REQUIRED ConstellationExec)

# Create shared library for satellite
add_library(TemplateSatellite SHARED "TemplateSatellite.cpp" "generator.cpp")

# Add Constellation dependencies
target_include_directories(TemplateSatellite PUBLIC ${CNSTLN_SAT_INCLUDE_DIRS})
target_link_directories(TemplateSatellite PUBLIC ${CNSTLN_SAT_LIBRARY_DIRS})
target_link_libraries(TemplateSatellite PUBLIC ${CNSTLN_SAT_LIBRARIES})
target_compile_options(TemplateSatellite PUBLIC ${CNSTLN_SAT_CFLAGS_OTHER})

# Set library output name to satellite type (used in `Satellite -t`)
set_target_properties(TemplateSatellite PROPERTIES LIBRARY_OUTPUT_NAME "Template")

# Install satellite to Constellation prefix
set(CNSTLN_SAT_INSTALL_DIR "${CNSTLN_EXEC_LIBDIR}/ConstellationSatellites")
message(STATUS "Installing satellite to: \"${CNSTLN_SAT_INSTALL_DIR}\"")
install(TARGETS
    TemplateSatellite
    LIBRARY DESTINATION ${CNSTLN_SAT_INSTALL_DIR}
)
