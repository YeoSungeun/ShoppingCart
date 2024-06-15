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
    
    var randomProfileName = ProfileImage.allCases.randomElement()!.rawValue
//    lazy var udProfileName = UserDefaults.standard.string(forKey: "profileName")
    lazy var profileView = SettingProfileView(profile: randomProfileName, type: .setting)
    
    let nicknameTextField = UITextField()
    let devider = UIView()
    let conditionLabel = UILabel()
    let doneButton = PointButton(title: "완료")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var udProfileName = UserDefaults.standard.string(forKey: UserDefaultsKey.profileName)
        print(#function,randomProfileName,udProfileName)
        
        configurHierachy()
        configureLayout()
        configureUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        var udProfileName = UserDefaults.standard.string(forKey: UserDefaultsKey.profileName)
        print(#function,udProfileName)
        if let udProfileName {
            profileView.configureUI(profile: udProfileName)
        }
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
            make.top.equalTo(view.snp.top).offset(120)
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
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonClicked))
        backButton.tintColor = Color.darkgray
        navigationItem.leftBarButtonItem = backButton
        navigationItem.title = viewType.rawValue
        
        view.backgroundColor = .white
        var udProfileName = UserDefaults.standard.string(forKey: UserDefaultsKey.profileName)
        if let udProfileName {
            profileView.configureUI(profile: udProfileName)
        } else {
            profileView.configureUI(profile: randomProfileName)
        }
        
        nicknameTextField.textColor = Color.lightgray
        nicknameTextField.placeholder = "닉네임을 입력해주세요 :)"
        nicknameTextField.font = Font.bold14
        devider.backgroundColor = Color.lightgray
        conditionLabel.textColor = Color.mainColor
        conditionLabel.font = Font.bold13
        
        profileView.profileSettingButton.addTarget(self, action: #selector(profileSettingButtonClicked), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(doneButtonClicked), for: .touchUpInside)
        
        
    }
    @objc func backButtonClicked() {
        var udProfileName = UserDefaults.standard.string(forKey: UserDefaultsKey.profileName)
        if udProfileName != nil {
            UserDefaults.standard.removeObject(forKey: "profileName")
            print(#function)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @objc func profileSettingButtonClicked() {
        let vc = ProfileImageSettingViewController()
        vc.viewtype = .setting
        
        var udProfileName = UserDefaults.standard.string(forKey: UserDefaultsKey.profileName)
        if udProfileName != nil {
            print("profileButton ud",udProfileName)
            vc.profileName = udProfileName!
            navigationController?.pushViewController(vc, animated: true)
        } else {
            UserDefaults.standard.set(randomProfileName, forKey: UserDefaultsKey.profileName)
            vc.profileName = randomProfileName
            print("profileButtone rand",randomProfileName, udProfileName)
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    @objc func doneButtonClicked() {
        let nickname = nicknameTextField.text
        UserDefaults.standard.set(nickname, forKey: "UserNickname")
        print("\(UserDefaults.standard.string(forKey: "UserNickname"))")
        UserDefaults.standard.set(true, forKey: "isUser")
        print("\(UserDefaults.standard.bool(forKey: "isUser"))")
        
        var udProfileName = UserDefaults.standard.string(forKey: UserDefaultsKey.profileName)
        if let udProfileName {
            
        } else {
            UserDefaults.standard.set(randomProfileName, forKey: UserDefaultsKey.profileName)
            print("\(UserDefaults.standard.string(forKey: UserDefaultsKey.profileName))")
        }
        
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene // first: 보여지는 화면 개수 (어차피 아이폰은 하나!)
        
        let sceneDelgate = windowScene?.delegate as? SceneDelegate // SceneDelegate 파일에 접근할 수 있음
        
        let vc = MainTabBarViewController()
        let rootViewController = UINavigationController(rootViewController: vc)
        
        sceneDelgate?.window?.rootViewController = rootViewController // sb entrypoint
        sceneDelgate?.window?.makeKeyAndVisible() // show
        
    }
    
    
}

#if DEBUG
@available (iOS 17, *)
#Preview {
    ProfileNicknameSettingViewController()
}
#endif
