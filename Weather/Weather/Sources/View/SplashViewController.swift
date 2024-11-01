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
            .filter { headerData, hourlyForecast, dailyForecast, humidity, cloudiness, windSpeed, mapCoordinate in
                
                if headerData != nil && !hourlyForecast.isEmpty {
                    return true
                } else {
                    return false
                }
                
                //빌드가 계속 멈춰서 위에 코드로 수정
//                return headerData != nil && !hourlyForecast.isEmpty && !dailyForecast.isEmpty && humidity != nil && cloudiness != nil && windSpeed != nil && mapCoordinate != nil
            }
            .take(1) // 데이터가 한번 바인딩되면 전환
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.transitionToMainViewController()
                
            })
            .disposed(by: disposeBag)
        
        // 에러 메시지 구독하여 실패 시 알림 표시
        viewModel.errorMessage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] message in
                guard let self = self else { return }
                self.showErrorAlert(message: message)
            })
            .disposed(by: disposeBag)
        
    }
    
    
    /// MainViewController로 이동
    private func transitionToMainViewController() {
        DispatchQueue.main.async {
            let mainViewController = MainViewController()
            mainViewController.viewModel = self.viewModel // 뷰모델 전달
            mainViewController.modalTransitionStyle = .crossDissolve
            mainViewController.modalPresentationStyle = .fullScreen
            self.present(mainViewController, animated: true, completion: nil)
        }
    }
    
    /// JSON 파일에서 데이터를 로드하고 저장
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
    
    /// API 호출 실패 시 에러 메시지와 함께 '취소' 및 '다시 시도' 옵션을 표시하는 알림
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Exit", style: .destructive) { _ in
            self.exitApp()
        }
        
        let retryAction = UIAlertAction(title: "Try again", style: .default) { _ in
            self.fetchData()
        }
        alert.addAction(cancelAction)
        alert.addAction(retryAction)
        present(alert, animated: true, completion: nil)
    }
    
    /// 앱 종료 함수
    private func exitApp() {
        UIControl().sendAction(#selector(NSXPCConnection.suspend), to: UIApplication.shared, for: nil)
    }
}



