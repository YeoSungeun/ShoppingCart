//
//  SettingProfileTableViewCell.swift
//  ShoppingCart
//
//  Created by 여성은 on 6/17/24.
//

import UIKit

class SettingProfileTableViewCell: UITableViewCell {
    
    let profileSettingView = UIView()
    lazy var profileImageView = SettingProfileView(profile: UserDefaultsKey.profileName, type: .selected)
    let nicknameLabel = UILabel()
    let membershipDateLabel = UILabel()
    let pushButton = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureHierarchy() {
        contentView.addSubview(profileSettingView)
        profileSettingView.addSubview(profileImageView)
        profileSettingView.addSubview(nicknameLabel)
        profileSettingView.addSubview(membershipDateLabel)
        profileSettingView.addSubview(pushButton)
        
    }
    func configureLayout() {
        profileSettingView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(32)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(20)
            make.verticalEdges.equalTo(contentView.snp.verticalEdges)
        }
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(60)
            make.width.equalTo(profileImageView.snp.height)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(20)
            make.bottom.equalTo(profileSettingView.snp.bottom).multipliedBy(0.5)
            make.height.equalTo(20)
        }
        membershipDateLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom)
            make.leading.equalTo(nicknameLabel.snp.leading)
            make.height.equalTo(16)
        }
        pushButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(profileSettingView.snp.trailing)
            make.height.equalTo(20)
            make.width.equalTo(pushButton.snp.height)
        }
        
    }
    func configureUI() {
        let profileImageName = UserDefaults.standard.string(forKey: UserDefaultsKey.profileName) ?? ""
        profileImageView.configureUI(profile: profileImageName)
        profileImageView.profileSettingButton.layer.cornerRadius = 30
        
        
        let nickname = UserDefaults.standard.string(forKey: UserDefaultsKey.UserNickname) ?? ""
       
        nicknameLabel.text = nickname
        nicknameLabel.font = Font.bold16
        
        let date = UserDefaults.standard.string(forKey: UserDefaultsKey.membershipDate) ?? ""
        membershipDateLabel.text = date
        membershipDateLabel.font = Font.regular13
        membershipDateLabel.textColor = Color.gray
        
        pushButton.image = UIImage(systemName: "chevron.right")
        pushButton.tintColor = Color.darkgray
        pushButton.contentMode = .scaleAspectFit
    }
}
