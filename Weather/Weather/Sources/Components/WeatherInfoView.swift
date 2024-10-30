//
//  WeatherInfoView.swift
//  Weather
//
//  Created by Daesik Jun on 10/30/24.
//

import UIKit
import SnapKit
import Then

// 날씨 정보를 나타내는 뷰
final class WeatherInfoView: UIView {
    
    private let titleLabel = UILabel().then {
        $0.font = .pretendard(size: 14, weight: .medium)
        $0.textColor = .white
    }
    
    
    private let valueLabel = UILabel().then {
        $0.font = .pretendard(size: 28, weight: .bold)
        $0.textColor = .white
    }
    
    
    private lazy var stackView = UIStackView(arrangedSubviews: [titleLabel, valueLabel]).then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 4
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
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    // 데이터를 설정하는 메서드
    func configure(title: String, value: String) {
        titleLabel.text = title
        valueLabel.text = value
    }
}
