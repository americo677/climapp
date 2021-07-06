//
//  APICallerContract.swift
//  ClimApp
//
//  Created by Américo Cantillo Gutiérrez on 4/07/21.
//

import Foundation

protocol APICallerProtocol {
    func performRequestForCity(searchText: String, success: @escaping (Int, [City]) -> (), failure: @escaping (Error) -> ()
    ) -> Void
    func performRequestForWeather(cityId: Double,  success: @escaping (Int, [ConsolidatedWeather]) -> (), failure: @escaping (Error) -> ()) -> Void
}
