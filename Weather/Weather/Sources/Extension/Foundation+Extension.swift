//
//  Foundation+Extension.swift
//  Weather
//
//  Created by Daesik Jun on 10/31/24.
//

import Foundation

extension String {
    //시간 표시를 "오전/오후 h시"로 변경
    func toAmPmTime() -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        inputFormatter.locale = Locale(identifier: "ko_KR") // 한국어 설정
        
        guard let date = inputFormatter.date(from: self) else {
            return nil
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "a h시" // "오전/오후 h시" 형식
        outputFormatter.locale = Locale(identifier: "ko_KR") // 한국어 설정
        
        return outputFormatter.string(from: date)
    }
    
    //시간 표시를 "요일"로 변경
    func toDayOfWeek() -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        inputFormatter.locale = Locale(identifier: "ko_KR") // 한국어 설정
        
        guard let date = inputFormatter.date(from: self) else {
            return nil
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "EEEEE" // "오전/오후 h시" 형식
        outputFormatter.locale = Locale(identifier: "ko_KR") // 한국어 설정
        
        return outputFormatter.string(from: date)
    }
    
    //list.weather.main의 값을 아이콘으로 변경
    func getWeatherIcon() -> String {
        switch self {
        case "Clear" : return "01d"
        case "Clouds": return "04d"
        case "Rain", "Drizzle" : return "09d"
        case "Thunderstorm" : return "11d"
        case "Snow" : return "13d"
        case "Mist", "Haze", "Dust", "Fog", "Sand", "Ash", "Squall", "Tornado": return "50d"
        default:
            return "02d"
        }
    }
    
}


