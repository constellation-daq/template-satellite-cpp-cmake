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

#adding clang-tidy target if found
find_program(CLANG_TIDY NAMES "clang-tidy")
if(CLANG_TIDY)
    if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
        # Write a .clang-tidy file in the binary dir to disable checks for created files
        file(WRITE ${CMAKE_BINARY_DIR}/.clang-tidy "\n---\nChecks: '-*,llvm-twine-local'\n...\n")

        # Set export commands on
        set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

        # Get amount of processors to speed up linting
        include(ProcessorCount)
        PROCESSORCOUNT(NPROC)
        if(NPROC EQUAL 0)
            SET(NPROC 1)
        endif()

        # Enable checking and formatting through run-clang-tidy if available
        get_filename_component(CLANG_TIDY ${CLANG_TIDY} REALPATH)
        get_filename_component(CLANG_DIR ${CLANG_TIDY} DIRECTORY)
        find_program(
            RUN_CLANG_TIDY
            NAMES "run-clang-tidy" "run-clang-tidy.py"
            HINTS /usr/share/clang/ ${CLANG_DIR}/../share/clang/ /usr/bin/)
        if(RUN_CLANG_TIDY)
            message(STATUS "Found ${RUN_CLANG_TIDY}, adding full-code linting targets")

            add_custom_target(
                clang-tidy
                COMMAND ${RUN_CLANG_TIDY} -clang-tidy-binary=${CLANG_TIDY} -fix -format -header-filter=${CMAKE_SOURCE_DIR}
                        -j${NPROC}
                COMMENT "Auto linting source files")
        else()
            message(STATUS "Could NOT find run-clang-tidy script")
        endif()
    else()
        message(STATUS "Could NOT check for clang-tidy, wrong compiler: ${CMAKE_CXX_COMPILER_ID}")
    endif()
else(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    message(STATUS "Could NOT find clang-tidy")
endif()
