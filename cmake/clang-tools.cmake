# SPDX-FileCopyrightText: 2025 DESY and the Constellation authors
# SPDX-License-Identifier: CC0-1.0

# Adding clang-format target if found
find_program(CLANG_FORMAT NAMES "clang-format")
if(CLANG_FORMAT)
    add_custom_target(
        clang-format
        COMMAND ${CLANG_FORMAT} -i -style=file ${CXX_SOURCE_FILES}
        COMMENT "Auto formatting of source files")
else()
    message(STATUS "Could NOT find clang-format, not adding formatting target")
endif()
