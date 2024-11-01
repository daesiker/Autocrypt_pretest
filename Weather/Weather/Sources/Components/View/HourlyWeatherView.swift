//
//  HourlyWeatherView.swift
//  Weather
//
//  Created by Daesik Jun on 10/30/24.
//

import UIKit
import SnapKit
import Then

/// 시간별 날씨 데이터 모델
struct HourlyWeatherData {
    let time: String
    let temperature: Double
    let iconName: String
}

final class HourlyWeatherComponent: UIView {
    
    private let titleLabel = UILabel().then {
        $0.font = .pretendard(size: 14, weight: .medium)
        $0.textColor = .white
        $0.textAlignment = .left
        $0.text = "2일간의 날씨정보"
    }
    
    private let splitView = UIView().then {
        $0.backgroundColor = .white
    }
    
    
    private let scrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
        $0.alwaysBounceHorizontal = true
    }
    
    // 시간별 날씨 데이터를 담을 스택 뷰
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 16
        $0.alignment = .center
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
        self.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
        self.layer.cornerRadius = 10
        
        addSubview(titleLabel)
        addSubview(splitView)
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        splitView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(0.5)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(splitView.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(60)
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
        }
    }
    
    // 시간별 날씨 데이터를 추가하는 메서드
    func configure(hourlyData: [HourlyWeatherData]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }  // 기존 뷰 삭제
        for data in hourlyData {
            let hourView = HourlyWeatherView()
            hourView.configure(data: data)
            stackView.addArrangedSubview(hourView)
        }
    }
}

final class HourlyWeatherView: UIView {
    
    private let timeLabel = UILabel().then {
        $0.font = .pretendard(size: 14, weight: .medium)
        $0.textColor = .white
        $0.textAlignment = .center
    }
    private let iconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .white
        $0.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
    }
    private let temperatureLabel = UILabel().then {
        $0.font = .pretendard(size: 14)
        $0.textColor = .white
        $0.textAlignment = .center
    }
    
    private lazy var stackView = UIStackView(arrangedSubviews: [timeLabel, iconImageView, temperatureLabel]).then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .center
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
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // 데이터를 설정하는 메서드
    func configure(data: HourlyWeatherData) {
        timeLabel.text = data.time
        temperatureLabel.text = "\(Int(data.temperature))°"
        let iconName = data.iconName.getWeatherIcon()
        iconImageView.image = UIImage(named: iconName)
    }
}
