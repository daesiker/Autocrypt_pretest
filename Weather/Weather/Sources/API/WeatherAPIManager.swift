//
//  WeatherAPIManager.swift
//  Weather
//
//  Created by Daesik Jun on 10/30/24.
//

import Foundation
import Alamofire
import RxSwift

class WeatherAPIManager {
    static let shared = WeatherAPIManager()
    private let apiKey = "4ec06f40de7282fd09995f10ce38b6a7"
    private let baseUrl = "https://api.openweathermap.org/data/2.5/forecast"

    func fetchWeather(cityName: String) -> Observable<[WeatherData]> {
        let parameters: [String: Any] = ["q": cityName, "appid": apiKey, "units": "metric", "cnt": 7]

        return Observable.create { observer in
            AF.request(self.baseUrl, parameters: parameters).responseDecodable(of: WeatherResponse.self) { response in
                switch response.result {
                case .success(let weather):
                    observer.onNext(weather.list)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
