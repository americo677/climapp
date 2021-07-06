//
//  WeatherPresenter.swift
//  ClimApp
//
//  Created by Américo Cantillo Gutiérrez on 6/07/21.
//

import Foundation

class WeatherPresenter {
    
    weak var delegate: PresenterToWeatherDelegate?
    
    public func getWeathers(cityId: Double) {
        APICaller.shared.performRequestForWeather(cityId: cityId, success: { (code, weathers) in
            self.delegate?.presentGet(weathers: weathers)
        }) { (code) in
            self.delegate?.presentAlert(title: "ClimAapp", message: "Error \(code): No hay conexión a la red, no es posible consultar datos en este momento.")
        }
    }

    public func setViewDelegate(delegate: PresenterToWeatherDelegate) {
        self.delegate = delegate
    }
    
}
