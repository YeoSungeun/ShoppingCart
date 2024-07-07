//
//  ProfileView.swift
//  ShoppingCart
//
//  Created by 여성은 on 6/14/24.
//

import UIKit
import SnapKit



class SettingProfileView: UIView {
    
    let profileSettingButton = UIButton()
    let cameraBackView = UIView()
    let cameraImageView = UIImageView()
    
    init(profile: String) {
        super.init(frame: .zero)
        
        configureHierarchy()
        configureLayout()
        configureUI(profile: profile)

    }
    
    init(profile: String, type: ProfileImageType) {
        super.init(frame: .zero)
        
        configureHierarchy()
        configureLayout()
        configureUI(profile: profile)
        configureType(type: type)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        self.addSubview(profileSettingButton)
    }
    func configureLayout() {
        self.snp.makeConstraints { make in
            make.height.equalTo(self.snp.width)
        }
        profileSettingButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            
        }
    }
    func configureUI(profile: String) {
        profileSettingButton.setImage(UIImage(named: profile), for: .normal)
        profileSettingButton.contentMode = .scaleAspectFill
        profileSettingButton.clipsToBounds = true
    }
    func configureType(type: ProfileImageType) {
        switch type {
        case .setting:
            setCameraImgaeView()
        case .selected:
            setSelectedView()
        case .unselected:
            setUnselectedView()
        }
    }
    func setCameraImgaeView() {
        self.addSubview(cameraBackView)
        cameraBackView.addSubview(cameraImageView)
        
        cameraBackView.snp.makeConstraints { make in
            make.trailing.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalTo(self.safeAreaLayoutGuide)
            make.size.equalTo(32)
        }
        cameraImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
        
        cameraImageView.image = UIImage(systemName: "camera.fill")
        cameraImageView.tintColor = Color.white
        cameraImageView.contentMode = .scaleAspectFit
        cameraBackView.backgroundColor = Color.mainColor
        cameraBackView.clipsToBounds = true
        cameraBackView.layer.cornerRadius = 16
        
        profileSettingButton.layer.borderWidth = 3
        profileSettingButton.layer.borderColor = Color.mainColor.cgColor
        profileSettingButton.layer.cornerRadius = 50
     
    }
    func setUnselectedView() {
        profileSettingButton.layer.borderWidth = 1
        self.alpha = 0.5
        profileSettingButton.layer.borderColor = Color.darkgray.cgColor
        profileSettingButton.isEnabled = false
        profileSettingButton.adjustsImageWhenDisabled = false
    }
    func setSelectedView() {
        profileSettingButton.layer.borderWidth = 3
        self.alpha = 1
        profileSettingButton.layer.borderColor = Color.mainColor.cgColor
        profileSettingButton.isEnabled = false
        profileSettingButton.adjustsImageWhenDisabled = false
    }
}

enum ProfileImage: String, CaseIterable {
    case profile_0
    case profile_1
    case profile_2
    case profile_3
    case profile_4
    case profile_5
    case profile_6
    case profile_7
    case profile_8
    case profile_9
    case profile_10
    case profile_11

}

enum ProfileImageType {
    case setting
    case unselected
    case selected
}
