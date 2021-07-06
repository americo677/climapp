//
//  City.swift
//  ClimApp
//
//  Created by Américo Cantillo Gutiérrez on 4/07/21.
//

import Foundation

// [{"title":"London","location_type":"City","woeid":44418,"latt_long":"51.506321,-0.12714"}]
struct City: Codable {
    let title: String
    let location_type: String
    let woeid: Double
    let latt_long: String
}
