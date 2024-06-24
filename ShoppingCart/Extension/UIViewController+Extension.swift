//
//  UIViewController+Extension.swift
//  ShoppingCart
//
//  Created by 여성은 on 6/24/24.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String, okady: String, completionHandler: @escaping (UIAlertAction) -> Void) {
        // 탈퇴 alert
        let alert = UIAlertController(
            title: "탈퇴하기",
            message: "탈퇴를 하면 데이터가 모두 초기화됩니다. 탈퇴 하시겠습니까?",
            preferredStyle: .alert)
        
        let okay = UIAlertAction(title: "확인", style: .destructive, handler: completionHandler)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        // 3. 합치기 (순서에 따라 달라짐)
        alert.addAction(cancel) // style이 cancel 이라 위치가 지정
        alert.addAction(okay)
        
        // 4. 화면 보여주기
        present(alert, animated: true)
    }
}

