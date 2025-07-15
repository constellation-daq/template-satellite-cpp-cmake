/**
 * @file
 * @brief Template satellite
 *
 * @copyright Copyright (c) 2025 DESY and the Constellation authors.
 * This software is distributed under the terms of the EUPL-1.2 License, copied verbatim in the file "LICENSE.md".
 * SPDX-License-Identifier: EUPL-1.2
 */

#pragma once

#include <stop_token>
#include <string_view>

#include "constellation/core/config/Configuration.hpp"
#include "constellation/satellite/Satellite.hpp"

class TemplateSatellite final : public constellation::satellite::Satellite {
public:
    TemplateSatellite(std::string_view type, std::string_view name);

    void initializing(constellation::config::Configuration& config) final;
    void running(const std::stop_token& stop_token) final;
};
