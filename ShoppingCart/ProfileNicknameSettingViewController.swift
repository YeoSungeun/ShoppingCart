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
enum VaildationError: Error {
    case textCountCondition
    case isSpecialChar
    case isNumChar
}

class ProfileNicknameSettingViewController: UIViewController {
    
    var viewType: ViewType = .setting
    
    var randomProfileName = ProfileImage.allCases.randomElement()!.rawValue
    var backNickname = UserDefaults.standard.string(forKey: UserDefaultsKey.UserNickname)
    var backProfileImageName = UserDefaults.standard.string(forKey: UserDefaultsKey.profileName)
    
    lazy var profileView = SettingProfileView(profile: randomProfileName, type: .setting)
    
    let nicknameTextField = UITextField()
    let devider = UIView()
    let conditionLabel = UILabel()
    let doneButton = PointButton(title: "완료")
    
    var isDoneButton = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var udProfileName = UserDefaults.standard.string(forKey: UserDefaultsKey.profileName)
        
        configurHierachy()
        configureLayout()
        configureUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        var udProfileName = UserDefaults.standard.string(forKey: UserDefaultsKey.profileName)
    
        if let udProfileName {
            profileView.configureUI(profile: udProfileName)
        }
        var udnickname = UserDefaults.standard.string(forKey: UserDefaultsKey.UserNickname)
        
        if let udnickname {
            nicknameTextField.text = udnickname
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
        if viewType == .setting {
            doneButton.snp.makeConstraints { make in
                make.top.equalTo(conditionLabel.snp.bottom).offset(4)
                make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(40)
                make.height.equalTo(50)
            }
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
        
        nicknameTextField.delegate = self
        nicknameTextField.textColor = Color.black
        
        nicknameTextField.placeholder = "닉네임을 입력해주세요 :)"
        if let nickname = UserDefaults.standard.string(forKey: UserDefaultsKey.UserNickname) {
            nicknameTextField.text = nickname
        }
        nicknameTextField.font = Font.bold14
        devider.backgroundColor = Color.lightgray
        conditionLabel.textColor = Color.mainColor
        conditionLabel.font = Font.bold13
        
        profileView.profileSettingButton.addTarget(self, action: #selector(profileSettingButtonClicked), for: .touchUpInside)
        if viewType == .setting {
            doneButton.addTarget(self, action: #selector(doneButtonClicked), for: .touchUpInside)
        } else if viewType == .edit {
            let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(doneButtonClicked))
            saveButton.tintColor = Color.black
            navigationItem.rightBarButtonItem = saveButton
            
        }
        
    }
    @objc func backButtonClicked() {
        if viewType == .setting {
            let udProfileName = UserDefaults.standard.string(forKey: UserDefaultsKey.profileName)
            let udNickName = UserDefaults.standard.string(forKey: UserDefaultsKey.UserNickname)
            
            if udProfileName != nil {
                UserDefaults.standard.removeObject(forKey: UserDefaultsKey.profileName)
            }
            if udNickName != nil {
                UserDefaults.standard.removeObject(forKey: UserDefaultsKey.UserNickname)
            }
        } else if viewType == .edit {
            UserDefaults.standard.set(backNickname, forKey: UserDefaultsKey.UserNickname)
            UserDefaults.standard.set(backProfileImageName, forKey: UserDefaultsKey.profileName)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc func profileSettingButtonClicked() {
        let vc = ProfileImageSettingViewController()
        vc.viewtype = viewType
        
        
        var udProfileName = UserDefaults.standard.string(forKey: UserDefaultsKey.profileName)
        if udProfileName != nil {
           
            vc.profileName = udProfileName!
            navigationController?.pushViewController(vc, animated: true)
        } else {
            UserDefaults.standard.set(randomProfileName, forKey: UserDefaultsKey.profileName)
            vc.profileName = randomProfileName
            navigationController?.pushViewController(vc, animated: true)
        }
        UserDefaults.standard.set(nicknameTextField.text, forKey: UserDefaultsKey.UserNickname)

        
    }
    @objc func doneButtonClicked() {
        if isDoneButton {
            let nickname = nicknameTextField.text
            UserDefaults.standard.set(nickname, forKey: UserDefaultsKey.UserNickname)
            
            UserDefaults.standard.set(true, forKey: UserDefaultsKey.isUser)
            
            if viewType == .setting {
                let udProfileName = UserDefaults.standard.string(forKey: UserDefaultsKey.profileName)
                
                if udProfileName == nil {
                    UserDefaults.standard.set(randomProfileName, forKey: UserDefaultsKey.profileName)
                }
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy. MM. dd 가입"
                let membershipDate = dateFormatter.string(from: Date())
            
                UserDefaults.standard.set(membershipDate, forKey: UserDefaultsKey.membershipDate)
                
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene // first: 보여지는 화면 개수 (어차피 아이폰은 하나!)
                
                let sceneDelgate = windowScene?.delegate as? SceneDelegate // SceneDelegate 파일에 접근할 수 있음
                
                let vc = MainTabBarViewController()
                
                sceneDelgate?.window?.rootViewController = vc // sb entrypoint
                sceneDelgate?.window?.makeKeyAndVisible() // show
            } else if viewType == .edit {
                navigationController?.popViewController(animated: true)
            }
            
        }
        
    }
    
    
}

extension ProfileNicknameSettingViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        guard let nickname = nicknameTextField.text else { return }
        
        do {
            let result = try validNickname(text: nickname)
            conditionLabel.text = "사용할 수 있는 닉네임이에요"
            isDoneButton = true
        } catch  VaildationError.textCountCondition {
            conditionLabel.text = "2글자 이상 10글자 미만으로 설정해주세요"
            isDoneButton = false
        } catch  VaildationError.isSpecialChar {
            conditionLabel.text = "닉네임에 @, #, $, % 는 포함할 수 없어요"
            isDoneButton = false
        } catch  VaildationError.isNumChar {
            conditionLabel.text = "닉네임에 숫자는 포함할 수 없어요"
            isDoneButton = false
        } catch {
            print("ERROR")
        }
 
    }
    
    func validNickname(text: String) throws -> Bool {
        var numCharSet: CharacterSet = CharacterSet()
        numCharSet.insert(charactersIn: "0123456789")
        var specialCharSet: CharacterSet = CharacterSet()
        specialCharSet.insert(charactersIn: "@#$%")
        
        guard text.count > 2 && text.count <= 9 else {
            print("글자 수")
            throw VaildationError.textCountCondition
        }
        guard text.rangeOfCharacter(from: specialCharSet) == nil else {
            print("특수문자")
            throw VaildationError.isSpecialChar
        }
        guard text.rangeOfCharacter(from: numCharSet) == nil else {
            print("숫자")
            throw VaildationError.isNumChar
        }
        return true
    }
    
}

#if DEBUG
@available (iOS 17, *)
#Preview {
    ProfileNicknameSettingViewController()
}
#endif
