//
//  PresenterContract.swift
//  ClimApp
//
//  Created by Américo Cantillo Gutiérrez on 6/07/21.
//

import Foundation
import UIKit

protocol CityPresenterDelegate: class {
    func presentGet(cities: [City])
    func presentAlert(title: String, message: String)
}

protocol WeatherPresenterDelegate: class {
    func presentGet(weathers: [ConsolidatedWeather])
    func presentAlert(title: String, message: String)
}

typealias PresenterToCityDelegate    = CityPresenterDelegate & UIViewController
typealias PresenterToWeatherDelegate = WeatherPresenterDelegate & UIViewController

