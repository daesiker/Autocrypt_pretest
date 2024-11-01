//
//  MapWeatherView.swift
//  Weather
//
//  Created by Daesik Jun on 10/30/24.
//

import Foundation
import UIKit
import MapKit
import SnapKit
import Then

final class MapWeatherView: UIView {
    
    private let titleLabel = UILabel().then {
        $0.text = "지도"
        $0.font = .pretendard(size: 14, weight: .medium)
        $0.textColor = .white
    }
    
    private let mapView = MKMapView().then {
        $0.layer.cornerRadius = 10
        $0.isZoomEnabled = true
        $0.isScrollEnabled = true
        $0.mapType = .standard
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
        addSubview(mapView)
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        mapView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(200)
        }
    }
    
    // 마커를 추가하는 메서드
    func setLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        // 기존 마커 제거
        mapView.removeAnnotations(mapView.annotations)
        
        // 새 마커 추가
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        // 지도 중심 설정
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500000, longitudinalMeters: 500000)
        mapView.setRegion(region, animated: true)
    }
}
