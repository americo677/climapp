//
//  CityPresenter.swift
//  ClimApp
//
//  Created by Américo Cantillo Gutiérrez on 4/07/21.
//

import Foundation
import UIKit

class CityPresenter {
    
    weak var delegate: PresenterToCityDelegate?
    
    public func getCities(searchText: String) {
        APICaller.shared.performRequestForCity(searchText: searchText, success: { (code, cities) in
            self.delegate?.presentGet(cities: cities)
        }) { (code) in
            self.delegate?.presentAlert(title: "ClimAapp", message: "Error \(code): No hay conexión a la red, no es posible consultar datos en este momento.")
        }
    }
    
    public func setViewDelegate(delegate: PresenterToCityDelegate) {
        self.delegate = delegate
    }
    
}
