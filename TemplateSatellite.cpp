/**
 * @file
 * @brief Implementation of the template satellite
 *
 * @copyright Copyright (c) 2025 DESY and the Constellation authors.
 * This software is distributed under the terms of the EUPL-1.2 License, copied verbatim in the file "LICENSE.md".
 * SPDX-License-Identifier: EUPL-1.2
 */

#include "TemplateSatellite.hpp"

#include <stop_token>
#include <string_view>
#include <thread>

#include "constellation/core/config/Configuration.hpp"
#include "constellation/satellite/Satellite.hpp"

using namespace constellation::config;
using namespace constellation::satellite;

TemplateSatellite::TemplateSatellite(std::string_view type, std::string_view name) : Satellite(type, name) {}

void TemplateSatellite::initializing(Configuration& /*config*/) {}

void TemplateSatellite::running(const std::stop_token& stop_token) {
    while(!stop_token.stop_requested()) {
        std::this_thread::yield();
    }
}
