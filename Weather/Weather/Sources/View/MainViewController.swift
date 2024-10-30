//
//  MainViewController.swift
//  Weather
//
//  Created by Daesik Jun on 10/29/24.
//

import UIKit
import RxSwift
import RxCocoa

final class MainViewController: UIViewController {
    
    private let viewModel = MainViewModel()
    private let disposeBag = DisposeBag()
    
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let contentView = UIView()
    
    private let searchButton = UIButton(type: .system).then {
        $0.setTitle("Search", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .pretendard(size: 16)
        
        let image = UIImage(systemName: "magnifyingglass")
        $0.setImage(image, for: .normal)
        $0.tintColor = .white
        $0.imageView?.contentMode = .scaleAspectFit
        
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        
        $0.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
        $0.layer.cornerRadius = 10
        $0.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        
        $0.contentHorizontalAlignment = .left
    }
    
    private let weatherHeaderView = WeatherHeaderView()
    private let hourlyWeatherComponent = HourlyWeatherComponent()
    private let dailyWeatherComponent = DailyWeatherComponent()
    private let mapWeatherView = MapWeatherView()
    private let humidityView = WeatherInfoView()
    private let cloudinessView = WeatherInfoView()
    private let windSpeedView = WeatherInfoView()
    private let emptyView = UIView()
    
    private lazy var rowStackView1 = UIStackView(arrangedSubviews: [humidityView, cloudinessView]).then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 10
    }
    
    private lazy var rowStackView2 = UIStackView(arrangedSubviews: [windSpeedView, emptyView]).then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 10
    }
    
    private lazy var outerStackView = UIStackView(arrangedSubviews: [rowStackView1, rowStackView2]).then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 10
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bindViewModel()
        viewModel.fetchWeather(city: "Asan")
    }
    
    private func setUI() {
        view.backgroundColor = UIColor(red: 114, green: 145, blue: 192)
        safeArea.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(searchButton)
        contentView.addSubview(weatherHeaderView)
        contentView.addSubview(hourlyWeatherComponent)
        contentView.addSubview(dailyWeatherComponent)
        contentView.addSubview(mapWeatherView)
        contentView.addSubview(outerStackView)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView)
        }
        
        searchButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(30)
        }
        
        weatherHeaderView.snp.makeConstraints {
            $0.top.equalTo(searchButton.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        hourlyWeatherComponent.snp.makeConstraints {
            $0.top.equalTo(weatherHeaderView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(130)
        }
        
        dailyWeatherComponent.snp.makeConstraints {
            $0.top.equalTo(hourlyWeatherComponent.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        mapWeatherView.snp.makeConstraints {
            $0.top.equalTo(dailyWeatherComponent.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            
        }
        
        outerStackView.snp.makeConstraints {
            $0.top.equalTo(mapWeatherView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(250)
            $0.bottom.equalToSuperview()
        }
        
        
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        
    }
    
    private func bindViewModel() {
        
        viewModel.headerData
            .bind { [weak self] headerData in
                guard let self = self, let headerData = headerData else { return }
                self.weatherHeaderView.configure(data: headerData)
            }
            .disposed(by: disposeBag)
        
        viewModel.mapCoordinate
            .bind { [weak self] coordinate in
                guard let self = self, let coordinate = coordinate else { return }
                self.mapWeatherView.setLocation(latitude: coordinate.0, longitude: coordinate.1)
            }
            .disposed(by: disposeBag)
        
        viewModel.humidity
            .bind { [weak self] humidity in
                guard let self = self, let humidity = humidity else { return }
                self.humidityView.configure(title: "습도", value: "\(humidity)%")
            }
            .disposed(by: disposeBag)
        
        viewModel.cloudiness
            .bind { [weak self] cloudiness in
                guard let self = self, let cloudiness = cloudiness else { return }
                self.cloudinessView.configure(title: "구름", value: "\(cloudiness)%")
            }
            .disposed(by: disposeBag)
        
        viewModel.windSpeed
            .bind { [weak self] windSpeed in
                guard let self = self, let windSpeed = windSpeed else { return }
                let speed = String(format: "%.2f", windSpeed)
                self.windSpeedView.configure(title: "바람 속도", value: "\(speed)m/s")
            }
            .disposed(by: disposeBag)
        
        viewModel.hourlyForecast
            .bind { [weak self] hourlyData in
                guard let self = self else { return }
                
                self.hourlyWeatherComponent.configure(hourlyData: hourlyData)
            }
            .disposed(by: disposeBag)
       
        viewModel.dailyForecast
            .bind { [weak self] dailyData in
                guard let self = self else { return }
                
                dailyWeatherComponent.configure(dailyData: dailyData)
            }
            .disposed(by: disposeBag)
    }
    
    //TODO: 검색 버튼 구현
    @objc private func searchButtonTapped() {
        print("버튼 클릭")
    }
    
}
