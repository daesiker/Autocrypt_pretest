//
//  CityTableViewCell.swift
//  Weather
//
//  Created by Daesik Jun on 10/31/24.
//

import Foundation
import UIKit
import Then

class CityTableViewCell: UITableViewCell {
    
    private let nameLabel = UILabel().then {
        $0.font = .pretendard(size: 18, weight: .bold)
        $0.textColor = .white
    }
    
    private let countryLabel = UILabel().then {
        $0.font = .pretendard(size: 14)
        $0.textColor = .white
    }
    
    private lazy var stackView = UIStackView(arrangedSubviews: [nameLabel, countryLabel]).then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .leading
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = UIColor(red: 114, green: 145, blue: 192)
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview().offset(-8)
        }
        
    }
    
    func configure(city: City) {
        nameLabel.text = city.name
        countryLabel.text = city.country
    }
}
