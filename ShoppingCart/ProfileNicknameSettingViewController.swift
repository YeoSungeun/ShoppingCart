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
    
//    let profileName = ProfileImage.allCases.randomElement()
    lazy var profileView = SettingProfileView(profile: ProfileImage.profile_0, type: .setting)
    
    let nicknameTextField = UITextField()
    let devider = UIView()
    let conditionLabel = UILabel()
    let doneButton = PointButton(title: "완료")

    override func viewDidLoad() {
        super.viewDidLoad()
        configurHierachy()
        configureLayout()
        configureUI()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        profileView.layoutIfNeeded()
        profileView.profileSettingButton.layer.cornerRadius = profileView.frame.height / 2
        doneButton.layoutIfNeeded()
        doneButton.layer.cornerRadius = doneButton.frame.height / 2
    }
    
    func configurHierachy() {
        view.addSubview(profileView)
        view.addSubview(nicknameTextField)
        view.addSubview(conditionLabel)
        view.addSubview(devider)
        view.addSubview(doneButton)
        
    }
    func configureLayout() {
        profileView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.snp.top).offset(100)
            make.width.equalTo(100)
        }
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(60)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.height.equalTo(40)
        }
        devider.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.height.equalTo(1)
        }
        conditionLabel.snp.makeConstraints { make in
            make.top.equalTo(devider.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.height.equalTo(40)
        }
        doneButton.snp.makeConstraints { make in
            make.top.equalTo(conditionLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.height.equalTo(50)
        }
        
    }
    func configureUI() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron"), style: .plain, target: self, action: #selector(backButtonClicked))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.title = viewType.rawValue
        
        nicknameTextField.textColor = Color.lightgray
        nicknameTextField.placeholder = "닉네임을 입력해주세요 :)"
        nicknameTextField.font = Font.bold14
        devider.backgroundColor = Color.lightgray
        conditionLabel.textColor = Color.mainColor
        conditionLabel.font = Font.bold13
        doneButton.addTarget(self, action: #selector(doneButtonClicked), for: .touchUpInside)
        
        
    }
    @objc func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    @objc func doneButtonClicked() {
        let nickname = nicknameTextField.text
        UserDefaults.standard.set(nickname, forKey: "UserNickname")
        
        UserDefaults.standard.set(true, forKey: "isUser")
        
    }


}

#if DEBUG
@available (iOS 17, *)
#Preview {
    ProfileNicknameSettingViewController()
}
#endif
