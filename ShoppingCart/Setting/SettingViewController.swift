//
//  SettingViewController.swift
//  ShoppingCart
//
//  Created by 여성은 on 6/14/24.
//

import UIKit
import SnapKit

enum SettingList: String, CaseIterable {
    case myCart = "나의 장바구니 목록"
    case FAQ = "자주 묻는 질문"
    case OneonOne = "1:1 문의"
    case alertSetting = "알림 설정"
    case leave = "탈퇴하기"
}

class SettingViewController: UIViewController {
    
    let settingTableVeiw = UITableView()
    let settingList = SettingList.allCases

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureUI()
        configureView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingTableVeiw.reloadData()
    }
    func configureHierarchy() {
        view.addSubview(settingTableVeiw)
    }
    func configureLayout() {
        settingTableVeiw.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = ViewType.setting.rawValue
        settingTableVeiw.separatorInset = UIEdgeInsets(top: .zero, left: 20.0, bottom: .zero, right: 20.0)
        settingTableVeiw.separatorColor = Color.black
    }
    func configureView() {
        settingTableVeiw.delegate = self
        settingTableVeiw.dataSource = self
        settingTableVeiw.register(SettingProfileTableViewCell.self, forCellReuseIdentifier: SettingProfileTableViewCell.id)
        settingTableVeiw.register(SettingListTableViewCell.self, forCellReuseIdentifier: SettingListTableViewCell.id)
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return settingList.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let profileCell = tableView.dequeueReusableCell(withIdentifier: SettingProfileTableViewCell.id) as! SettingProfileTableViewCell
        let settingCell = tableView.dequeueReusableCell(withIdentifier: SettingListTableViewCell.id) as! SettingListTableViewCell
        
        if indexPath.section == 0 {
            let profileImageName = UserDefaults.standard.string(forKey: UserDefaultsKey.profileName) ?? ""
            profileCell.profileImageView.configureUI(profile: profileImageName)
            let nickname = UserDefaults.standard.string(forKey: UserDefaultsKey.UserNickname) ?? ""
            profileCell.nicknameLabel.text = nickname
            return profileCell
        } else if indexPath.section == 1 {
            settingCell.configureCell(data: settingList[indexPath.row])
            return settingCell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        } else if indexPath.section == 1 {
            return 44
        }
        return 0
    }
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 && indexPath.row != settingList.count-1 {
            return nil
        }
        return indexPath
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            let vc = ProfileNicknameSettingViewController()
            vc.viewType = .edit
            navigationController?.pushViewController(vc, animated: true)
        } else {
            // 탈퇴 alert
            let alert = UIAlertController(
                title: "탈퇴하기",
                message: "탈퇴를 하면 데이터가 모두 초기화됩니다. 탈퇴 하시겠습니까?",
                preferredStyle: .alert)
            
            let okay = UIAlertAction(title: "확인", style: .destructive) { action in
                
                for key in UserDefaults.standard.dictionaryRepresentation().keys {
                    UserDefaults.standard.removeObject(forKey: key.description)
                }
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let sceneDelgate = windowScene?.delegate as? SceneDelegate
                let vc = OnBoardingViewController()
                let rootViewController = UINavigationController(rootViewController: vc)
                sceneDelgate?.window?.rootViewController = rootViewController
                sceneDelgate?.window?.makeKeyAndVisible()
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            
            // 3. 합치기 (순서에 따라 달라짐)
            alert.addAction(cancel) // style이 cancel 이라 위치가 지정
            alert.addAction(okay)
            
            // 4. 화면 보여주기
            present(alert, animated: true)
        }
        tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: indexPath.section)], with: .automatic)
    }
}
