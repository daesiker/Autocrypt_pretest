//
//  SplashViewController.swift
//  Weather
//
//  Created by Daesik Jun on 10/29/24.
//

import Foundation
import UIKit
import SnapKit
import Then
import RxSwift


final class SplashViewController: UIViewController {
    private let viewModel = MainViewModel()
    private let disposeBag = DisposeBag()
    
    
    private let imageView = UIImageView(image: UIImage(named: "SplashLogo")).then {
        $0.contentMode = .scaleAspectFit
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bindViewModel()
        fetchData()
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        
        safeArea.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(40)
            $0.trailing.equalToSuperview().offset(-40)
            $0.height.equalTo(150)
        }
        
    }
    
    private func bindViewModel() {
            // 모든 데이터가 바인딩될 때까지 기다리기 위해 Completable을 생성하여 처리
            let allDataLoaded = Observable.combineLatest(
                viewModel.headerData,
                viewModel.hourlyForecast,
                viewModel.dailyForecast,
                viewModel.humidity,
                viewModel.cloudiness,
                viewModel.windSpeed,
                viewModel.mapCoordinate
            )
            
            allDataLoaded
                .take(1) // 데이터가 한번 바인딩되면 전환
                .subscribe(onNext: { [weak self] _ in
                    self?.transitionToMainViewController()
                })
                .disposed(by: disposeBag)
        }
    
    
    private func transitionToMainViewController() {
        DispatchQueue.main.async {
            let mainViewController = MainViewController()
            mainViewController.viewModel = self.viewModel // 뷰모델 전달
            mainViewController.modalTransitionStyle = .crossDissolve
            mainViewController.modalPresentationStyle = .fullScreen
            self.present(mainViewController, animated: true, completion: nil)
        }
    }
    
    // JSON 파일에서 데이터를 로드하고 저장
    private func fetchData() {
        guard let path = Bundle.main.path(forResource: "reduced_citylist", ofType: "json") else {
            return
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            var cityData = try JSONDecoder().decode([City].self, from: data)
            cityData = cityData.filter { $0.name != "-" && !$0.name.isEmpty}
            City.cityList = cityData.sorted(by: { $0.name < $1.name})
            viewModel.fetchWeather()
        } catch {
            print("JSON 로드 에러: \(error)")
        }
    }
    
}



