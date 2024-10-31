//
//  City.swift
//  Weather
//
//  Created by Daesik Jun on 10/31/24.
//

import Foundation

// 도시 정보 모델
struct City: Codable {
    static var cityList:[City] = []
    
    let id: Int
    let name: String
    let coord: Coordinate
    let country: String
    let population: Int?
    let timezone: Int?
    let sunrise: Int?
    let sunset: Int?
}

// 위도, 경도 정보 모델
struct Coordinate: Codable {
    let lat: Double
    let lon: Double
}
