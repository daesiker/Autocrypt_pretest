//
//  Weather.swift
//  Weather
//
//  Created by Daesik Jun on 10/30/24.
//

import Foundation

//  응답 모델
struct WeatherResponse: Decodable {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [WeatherData]
    let city: City
}

// 도시 정보 모델
struct City: Decodable {
    let id: Int
    let name: String
    let coord: Coordinate
    let country: String
    let population: Int
    let timezone: Int
    let sunrise: Int
    let sunset: Int
}

// 위도, 경도 정보 모델
struct Coordinate: Decodable {
    let lat: Double
    let lon: Double
}

// 시간별 날씨 데이터 모델
struct WeatherData: Decodable {
    let dt: Int
    let main: MainWeather
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let pop: Double
    let sys: Sys
    let dtTxt: String

    // JSON 키와 Swift 변수 이름이 다를 경우 CodingKeys 사용
    private enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, sys
        case dtTxt = "dt_txt"
    }
}

// 주요 날씨 정보 모델
struct MainWeather: Decodable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let seaLevel: Int
    let grndLevel: Int
    let humidity: Int
    let tempKf: Double

    private enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

// 날씨 설명 정보 모델
struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

// 구름량 정보 모델
struct Clouds: Decodable {
    let all: Int
}

// 바람 속도 정보 모델
struct Wind: Decodable {
    let speed: Double
    let deg: Int
    let gust: Double
}

// 기타 시스템 정보 모델
struct Sys: Decodable {
    let pod: String
}
