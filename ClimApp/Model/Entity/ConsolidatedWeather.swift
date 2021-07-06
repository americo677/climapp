//
//  ConsolidatedWeather.swift
//  ClimApp
//
//  Created by Américo Cantillo Gutiérrez on 4/07/21.
//

import Foundation

struct ConsolidatedWeather: Codable {
    let weather_state_abbr: String?
    let the_temp: Double?
    let max_temp: Double?
    let min_temp: Double?
    let applicable_date: String?
    let weather_state_name: String?
    let image_url: String?
}
