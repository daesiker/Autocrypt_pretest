//
//  UIKit+Extension.swift
//  Weather
//
//  Created by Daesik Jun on 10/30/24.
//

import Foundation
import UIKit

extension UIViewController {
    //safeArea 영역의 view를 생성
    var safeArea:UIView {
        get {
            guard let safeArea = self.view.viewWithTag(Int(INT_MAX)) else {
                let guide = self.view.safeAreaLayoutGuide
                let view = UIView()
                view.backgroundColor = .clear
                view.tag = Int(INT_MAX)
                self.view.addSubview(view)
                view.snp.makeConstraints {
                    $0.edges.equalTo(guide)
                }
                return view
            }
            return safeArea
        }
    }
    
    
}


extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
}

extension UIFont {
    
    enum PretendardWeight: String {
        case light = "Pretendard-Light"
        case regular = "Pretendard-Regular"
        case medium = "Pretendard-Medium"
        case semiBold = "Pretendard-SemiBold"
        case bold = "Pretendard-Bold"
        case extraBold = "Pretendard-ExtraBold"
    }
    
    static func pretendard(size: CGFloat, weight: PretendardWeight = .regular) -> UIFont {
        return UIFont(name: weight.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}


