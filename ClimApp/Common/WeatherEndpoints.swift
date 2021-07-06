//
//  WeatherEndpoints.swift
//  ClimApp
//
//  Created by Américo Cantillo Gutiérrez on 4/07/21.
//

import Foundation

struct WeatherEndpoints {
    
    static let URL_LOCATION: String     = "https://www.metaweather.com/api/location/search/"
    static let URL_DATE_WEATHER: String = "https://www.metaweather.com/api/location/{woeid}/{date}/"
    static let URL_IMAGE: String        = "https://www.metaweather.com/static/img/weather/png/{weather_state}.png"
    static let URL_IMAGE_64: String        = "https://www.metaweather.com/static/img/weather/png/64/{weather_state}.png"

}
