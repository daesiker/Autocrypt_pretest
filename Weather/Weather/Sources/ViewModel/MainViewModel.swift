//
//  MainViewModel.swift
//  Weather
//
//  Created by Daesik Jun on 10/31/24.
//

import Foundation
import RxSwift
import Alamofire

class MainViewModel {
    
    private let disposeBag = DisposeBag()
    
    let headerData = BehaviorSubject<WeatherHeaderData?>(value: nil)
    let hourlyForecast = BehaviorSubject<[HourlyWeatherData]>(value: [])
    let dailyForecast = BehaviorSubject<[DailyWeatherData]>(value: [])
    
    let humidity = BehaviorSubject<Int?>(value: nil)
    let cloudiness = BehaviorSubject<Int?>(value: nil)
    let windSpeed = BehaviorSubject<Double?>(value: nil)
    
    let mapCoordinate = BehaviorSubject<(Double, Double)?>(value: nil)
    
    func fetchWeather(city: String = "Asan") {
        let url = "https://api.openweathermap.org/data/2.5/forecast"
        let parameters: [String: Any] = [
            "q": city,
            "appid": "4ec06f40de7282fd09995f10ce38b6a7",
            "units": "metric"
        ]
        
        AF.request(url, parameters: parameters).responseDecodable(of: WeatherResponse.self) { response in
            switch response.result {
            case .success(let weatherData):
                
                //WeatherHeaderView
                if let headerData = WeatherHeaderData(response: weatherData) {
                    self.headerData.onNext(headerData)
                }
                
                //MapWeatherView
                self.mapCoordinate.onNext((weatherData.city.coord.lat, weatherData.city.coord.lon))
                
                //HourlyWeatherView
                let hourlyData = weatherData.list.prefix(16).map { data in
                    
                    HourlyWeatherData(time: data.dtTxt.toAmPmTime() ?? "", temperature: data.main.temp, iconName: data.weather.first?.main ?? "")
                }
                self.hourlyForecast.onNext(hourlyData)
                
                var uniqueDays = Set<String>()
                var dailyData: [DailyWeatherData] = []
                
                for data in weatherData.list {
                    let dateString = String(data.dtTxt.prefix(10)) // "YYYY-MM-DD" 형식만 추출
                    if !uniqueDays.contains(dateString) {
                        uniqueDays.insert(dateString)
                        
                        if let icon = data.weather.first?.main {
                            dailyData.append(DailyWeatherData(day: data.dtTxt.toDayOfWeek() ?? "", iconName: icon, minTemperature: data.main.tempMin, maxTemperature: data.main.tempMax))
                        }
                        if dailyData.count == 5 {
                            break
                        }
                    }
                }
                self.dailyForecast.onNext(dailyData)
                
                //WeatherInfoView
                let averageCloudiness = weatherData.list.map { $0.clouds.all }.reduce(0, +) / weatherData.list.count
                let averageWindSpeed = weatherData.list.map { $0.wind.speed }.reduce(0, +) / Double(weatherData.list.count)
                let averageHumidity = weatherData.list.map { $0.main.humidity }.reduce(0, +) / weatherData.list.count
                
                self.cloudiness.onNext(averageCloudiness)
                self.windSpeed.onNext(averageWindSpeed)
                self.humidity.onNext(averageHumidity)
                
            case .failure(let error):
                print("Error fetching weather: \(error)")
            }
        }
    }
}
