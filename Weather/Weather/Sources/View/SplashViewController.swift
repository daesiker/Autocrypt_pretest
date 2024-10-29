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


final class SplashViewController: UIViewController {

    private let imageView = UIImageView(image: UIImage(named: "SplashLogo")).then {
        $0.contentMode = .scaleAspectFit
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        
        view.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(40)
            $0.trailing.equalToSuperview().offset(-40)
            $0.height.equalTo(150)
        }
        
    }
    
    private func switchToMainViewController() {
        let vc = MainViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.isNavigationBarHidden = true
        nav.modalPresentationStyle = .fullScreen
        nav.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
    }
    
    
}



