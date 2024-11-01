//
//  WeatherHeaderView.swift
//  Weather
//
//  Created by Daesik Jun on 10/30/24.
//

import UIKit
import SnapKit
import Then

///WeatherHeaderView의 맞춤형 데이터
struct WeatherHeaderData {
    let city:String
    let temperature:Double
    let weatherDescription:String
    let highLowTemperature:(Double, Double)
    
    init?(response: WeatherResponse) {
        self.city = response.city.name
        if let currentWeather = response.list.first,
           let description = currentWeather.weather.first?.description{
            self.temperature = currentWeather.main.temp
            self.weatherDescription = description
            self.highLowTemperature = (currentWeather.main.tempMin, currentWeather.main.tempMax)
        } else {
            return nil
        }
    }
}

final class WeatherHeaderView: UIView {
    
    private let cityLabel = UILabel().then {
        $0.font = .pretendard(size: 36, weight: .bold)
        $0.textColor = .white
        $0.textAlignment = .center
    }
    
    private let temperatureLabel = UILabel().then {
        $0.font = .pretendard(size: 72, weight: .light)
        $0.textColor = .white
        $0.textAlignment = .center
    }
    
    private let descriptionLabel = UILabel().then {
        $0.font = .pretendard(size: 20, weight: .medium)
        $0.textColor = .white
        $0.textAlignment = .center
    }
    
    private let highLowLabel = UILabel().then {
        $0.font = .pretendard(size: 16)
        $0.textColor = .white
        $0.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        self.backgroundColor = UIColor.clear
        
        self.addSubview(cityLabel)
        self.addSubview(temperatureLabel)
        self.addSubview(descriptionLabel)
        self.addSubview(highLowLabel)
        
        cityLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        temperatureLabel.snp.makeConstraints {
            $0.top.equalTo(cityLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(temperatureLabel.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
        }
        
        highLowLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    ///WeatherHeaderData 데이터 설정 함수
    func configure(data: WeatherHeaderData) {
        cityLabel.text = data.city
        temperatureLabel.text = "\(Int(data.temperature))°"
        descriptionLabel.text = data.weatherDescription.capitalized
        highLowLabel.text = "최고: \(Int(data.highLowTemperature.1))° | 최저: \(Int(data.highLowTemperature.0))°"
    }
}
