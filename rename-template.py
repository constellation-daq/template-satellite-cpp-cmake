#!/usr/bin/env python3
"""
SPDX-FileCopyrightText: 2025 DESY and the Constellation authors
SPDX-License-Identifier: EUPL-1.2
"""

import argparse
import os
import pathlib


def file_replace(old_text: str, new_text: str, file_path: pathlib.Path) -> None:
    with open(file_path) as file:
        text = file.read()
        text = text.replace(old_text, new_text)
    with open(file_path, "w") as file:
        file.write(text)


def rename_template(new_type: str) -> None:
    wd = pathlib.Path(__file__).parent

    # Rename class
    file_replace("Template", new_type, wd.joinpath("TemplateSatellite.hpp"))
    file_replace("Template", new_type, wd.joinpath("TemplateSatellite.cpp"))
    file_replace("Template", new_type, wd.joinpath("main.cpp"))
    file_replace("Template", new_type, wd.joinpath("generator.cpp"))
    file_replace("Template", new_type, wd.joinpath("CMakeLists.txt"))

    # Rename class files
    os.rename(wd.joinpath("TemplateSatellite.hpp"), wd.joinpath(new_type + "Satellite.hpp"))
    os.rename(wd.joinpath("TemplateSatellite.cpp"), wd.joinpath(new_type + "Satellite.cpp"))

    # Remove the rename script
    os.remove(__file__)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("new_type")
    args = parser.parse_args()
    rename_template(args.new_type)
