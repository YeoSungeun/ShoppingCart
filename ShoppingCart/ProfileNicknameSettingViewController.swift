//
//  ProfileNicknameSettingViewController.swift
//  ShoppingCart
//
//  Created by 여성은 on 6/13/24.
//

import UIKit

enum ViewType: String {
    case setting = "PROFILE SETTING"
    case edit = "EDIT PROFILE"
}

class ProfileNicknameSettingViewController: UIViewController {
    
    var viewType: ViewType = .setting

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    


}

#if DEBUG
@available (iOS 17, *)
#Preview {
    ProfileNicknameSettingViewController()
}
#endif
