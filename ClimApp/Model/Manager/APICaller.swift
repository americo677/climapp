//
//  APICaller.swift
//  ClimApp
//
//  Created by Américo Cantillo Gutiérrez on 4/07/21.
//

import Foundation
import Alamofire
import SwiftyJSON

enum FetchError: Error {
    case noConnection
    case noDataFound
}

class APICaller: APICallerProtocol {

    // MARK: - APICaller singleton.
    static var shared: APICaller = {
        let instance = APICaller()
        return instance
    }()

    // MARK: - Constructor is privated for singleton.
    private init() {}
    
    // MARK: - Get an array with cities
    func performRequestForCity(searchText: String, success: @escaping (Int, [City]) -> (), failure: @escaping (Error) -> ()
    ) -> Void {
        
        let originalURL: URL = URL(string: WeatherEndpoints.URL_LOCATION)!
        
        var errMesage: String = ""

        let parameters = ["query": searchText]
        
        let url: Alamofire.URLConvertible = originalURL
        
        var cities: [City] = []
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            if (response.response?.statusCode == 200) {
                switch response.result {
                    case .success(_):
                        if let data = response.result.value {
                            
                            let dataJSON = JSON(data)
                            
                            for (_, subJson): (String, JSON) in dataJSON {

                                let woeid = subJson["woeid"].double
                                let title =  subJson["title"].stringValue
                                let location_type = subJson["location_type"].stringValue
                                let latt_long = subJson["latt_long"].stringValue

                                let city = City(title: title, location_type: location_type, woeid: woeid!, latt_long: latt_long)
                                print("\nCity: \(city)")
                                cities.append(city)
                            }
                            //print("City results:\(cities)")
                        }
                        success(response.response!.statusCode, cities)
                    case .failure(let error):
                        errMesage = "Error on weather request: \(error)"
                        print(errMesage)
                        failure(error)
                }
            }
        }
    }
    
    // MARK: - Get an array with the urls for fetching next days weather.
    func getURLWithDates(days: Int = 5) -> [String]? {
        var today = Date()
        let dateFormatter = DateFormatter()
        var counter = 0;
        var urls: [String] = []
        
        repeat {
            dateFormatter.dateFormat = "yyyy"
            let yearNumberStr = dateFormatter.string(from: today)
            
            dateFormatter.dateFormat = "M"
            let monthNumberStr = dateFormatter.string(from: today)
            
            dateFormatter.dateFormat = "d"
            let dayNumberStr = dateFormatter.string(from: today)
            
            let newDate = yearNumberStr + "/" + monthNumberStr + "/" + dayNumberStr
            // add a single day to date
            today = today + 86400
            counter += 1
            let newURL = WeatherEndpoints.URL_DATE_WEATHER.replacingOccurrences(of: "{date}", with: newDate)
            urls.append(newURL)
        } while (counter < days)
        
        return urls
    }
    
    // MARK: - Get an array with next weather lectures 5 by default.
    func performRequestForWeather(cityId: Double,  success: @escaping (Int, [ConsolidatedWeather]) -> (), failure: @escaping (Error) -> ()
    ) -> Void {
        
        // /api/location/(woeid)/(date)/
        // sample: /api/location/44418/2013/4/27/ - London on a 27th April 2013
        
        var weathers: [ConsolidatedWeather] = []
        
        var errMesage: String = ""
        
        if let urlsWithDate = getURLWithDates() {
            
            for urlWithDate in urlsWithDate {
                
                let url = urlWithDate.replacingOccurrences(of: "{woeid}", with: "\(Int(cityId))")
                //print("\nurl for fetching weather: \(url)")
                
                Alamofire.request(url, method: .get, parameters: nil).responseJSON { response in

                    if (response.response?.statusCode == 200) {
                        switch response.result {
                            case .success(_):
                                if let data = response.result.value {

                                    let dataJSON = JSON(data)

                                    for (_, subJson): (String, JSON) in dataJSON {

                                        let weather_state_abbr: String = subJson["weather_state_abbr"].stringValue
                                        let weather_state_name =  subJson["weather_state_name"].stringValue
                                        let the_temp = subJson["the_temp"].double
                                        let applicable_date = subJson["applicable_date"].stringValue
                                        let min_temp = subJson["min_temp"].double
                                        let max_temp = subJson["max_temp"].double
                                        
                                        let image_url: String = WeatherEndpoints.URL_IMAGE_64.replacingOccurrences(of: "{weather_state}", with: weather_state_abbr)

                                        let weather = ConsolidatedWeather(weather_state_abbr: weather_state_abbr, the_temp: the_temp, max_temp: max_temp, min_temp: min_temp, applicable_date: applicable_date, weather_state_name: weather_state_name, image_url: image_url)
                                        
                                        weathers.append(weather)
                                        //print("weather: \(weather)")
                                    }
                                }
                                success(response.response!.statusCode, weathers)
                            case .failure(let error):
                                errMesage = "Error on weather request: \(error)"
                                print(errMesage)
                                failure(error)
                        }
                    }
                }
            }
        }
    }
    
}

// MARK: - APICaller extension to avoid cloning for singleton.
extension APICaller: NSCopying {

    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
