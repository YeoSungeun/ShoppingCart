//
//  ProfileImageSettingCollectionViewCell.swift
//  ShoppingCart
//
//  Created by 여성은 on 6/15/24.
//

import UIKit

class ProfileImageSettingCollectionViewCell: UICollectionViewCell {
    
    var profileImageView = SettingProfileView(profile: ProfileImage.profile_0.rawValue)
    
    var profileName = ""
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureHierarchy() {
        contentView.addSubview(profileImageView)
    }
    func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    func configureUI() {
        profileImageView.profileSettingButton.layer.cornerRadius = contentView.layer.frame.width / 2
    }
    
    func cofigureCell(data: ProfileImage) {
        let udProfileName = UserDefaults.standard.string(forKey: UserDefaultsKey.profileName)
        print("cofigureCell:\(String(describing: udProfileName))")
        print("cofigureCell: \(profileName)")
        if data.rawValue == profileName {
            profileImageView.configureUI(profile: data.rawValue)
            profileImageView.configureType(type: .selected)
        } else {
            profileImageView.configureUI(profile: data.rawValue)
            profileImageView.configureType(type: .unselected)
        }
    }
    
}

#if DEBUG
@available (iOS 17, *)
#Preview {
    ProfileImageSettingCollectionViewCell()
}
#endif


