//
//  UIKit+Extension.swift
//  Weather
//
//  Created by Daesik Jun on 10/30/24.
//

import Foundation
import UIKit

extension UIViewController {
    /// safeArea 영역의 view를 생성
    var safeArea:UIView {
        get {
            guard let safeArea = self.view.viewWithTag(Int(INT_MAX)) else {
                let guide = self.view.safeAreaLayoutGuide
                let view = UIView()
                view.backgroundColor = .clear
                //tag를 통해 유무 확인
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
    
    /// rgb를 좀 더 간단히 사용할 수 있는 init 추가
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
    
    /**
     Pretendard폰트 함수화
     - Parameters:
        - size: 폰트크기
        - weight : 폰트 옵션
    */
    static func pretendard(size: CGFloat, weight: PretendardWeight = .regular) -> UIFont {
        return UIFont(name: weight.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}


