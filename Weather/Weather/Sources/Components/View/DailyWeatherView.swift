//
//  DailyWeatherView.swift
//  Weather
//
//  Created by Daesik Jun on 10/30/24.
//

import Foundation
import UIKit
import SnapKit
import Then

/// 일별 날씨 데이터 모델
struct DailyWeatherData {
    let day: String
    let iconName: String
    let minTemperature: Double
    let maxTemperature: Double
}

final class DailyWeatherComponent: UIView {
    private let titleLabel = UILabel().then {
        $0.text = "5일간의 일기예보"
        $0.font = .pretendard(size: 14, weight: .medium)
        $0.textColor = .white
    }
    
    // 데이터 표시를 위한 스택 뷰
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
        $0.alignment = .fill
        $0.distribution = .equalSpacing
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
        addSubview(stackView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
    }
    
    // 일별 날씨 데이터를 추가하는 메서드
    func configure(dailyData: [DailyWeatherData]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }  // 기존 뷰 삭제
        
        for data in dailyData {
            let dayView = DailyWeatherView()
            dayView.configure(data: data)
            stackView.addArrangedSubview(dayView)
        }
    }
}

// 일별 날씨 표시용 뷰
final class DailyWeatherView: UIView {
    
    private let splitView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let dayLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .white
    }
    
    private let iconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .white
        $0.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
    }
    
    private let tempLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .white
        $0.textAlignment = .right
    }
    
    
    private lazy var stackView = UIStackView(arrangedSubviews: [dayLabel, iconImageView, tempLabel]).then {
        $0.axis = .horizontal
        $0.spacing = 30
        $0.alignment = .leading
        $0.distribution = .equalCentering
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
        
        addSubview(splitView)
        
        splitView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalTo(splitView.snp.bottom).offset(6)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // 데이터를 설정하는 메서드
    func configure(data: DailyWeatherData) {
        dayLabel.text = data.day
        let iconName = data.iconName.getWeatherIcon()
        iconImageView.image = UIImage(named: iconName)
        
        let minTemperature = "최소: \(Int(data.minTemperature))° "
        let maxTemperature = " 최대: \(Int(data.maxTemperature))°"
        let attributedString = NSMutableAttributedString(string: minTemperature + maxTemperature)
        
        // 최소 온도에 적용할 폰트와 색상
        let minFont:UIFont = .pretendard(size: 12, weight: .medium)
        let minColor:UIColor = UIColor(white: 1.0, alpha: 0.8)
        
        // 최대 온도에 적용할 폰트와 색상
        let maxFont:UIFont = .pretendard(size: 14, weight: .bold)
        let maxColor:UIColor = .white
        
        // 최소 온도 범위에 스타일 적용
        attributedString.addAttribute(.font, value: minFont, range: NSRange(location: 0, length: minTemperature.count))
        attributedString.addAttribute(.foregroundColor, value: minColor, range: NSRange(location: 0, length: minTemperature.count))
        
        // 최대 온도 범위에 스타일 적용
        attributedString.addAttribute(.font, value: maxFont, range: NSRange(location: minTemperature.count, length: maxTemperature.count))
        attributedString.addAttribute(.foregroundColor, value: maxColor, range: NSRange(location: minTemperature.count, length: maxTemperature.count))
        
        
        tempLabel.attributedText = attributedString
        
    }
}
