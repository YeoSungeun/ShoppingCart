//
//  ProfileImageSettingViewController.swift
//  ShoppingCart
//
//  Created by 여성은 on 6/13/24.
//

import UIKit
import SnapKit



class ProfileImageSettingViewController: UIViewController {
    var viewtype: ViewType = .edit
    
    // MARK: 왜 Userdefault로 받으면 lazy로 받아야하지~?
    lazy var profileName = ""
    lazy var profileImgaeView = SettingProfileView(profile: ProfileImage.profile_0.rawValue, type: .setting)
    lazy var profileCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
    lazy var profileImageList = ProfileImage.allCases

    override func viewDidLoad() {
        super.viewDidLoad()
        let udProfileName = UserDefaults.standard.string(forKey: UserDefaultsKey.profileName)
        print(#function,profileName,udProfileName)
        configureHierarchy()
        configureLayout()
        configureUI()
        configureView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //
    }
    
    func configureHierarchy() {
        view.addSubview(profileImgaeView)
        view.addSubview(profileCollectionView)
    }
    func configureLayout() {
        profileImgaeView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.snp.top).offset(120)
            make.width.equalTo(100)
        }
        profileCollectionView.snp.makeConstraints { make in
            make.top.equalTo(profileImgaeView.snp.bottom).offset(50)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    func configureUI() {
        view.backgroundColor = .white
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonClicked))
        backButton.tintColor = Color.darkgray
        navigationItem.leftBarButtonItem = backButton
        
        navigationItem.title = viewtype.rawValue
        
        profileImgaeView.profileSettingButton.isEnabled = false
        profileImgaeView.profileSettingButton.adjustsImageWhenDisabled = false
        
        profileImgaeView.configureUI(profile: profileName)
        print("ProfileImageSettingViewController_configureUI:\(profileName)")
        
    }
    func configureView() {
        
        profileCollectionView.delegate = self
        profileCollectionView.dataSource = self
        
        profileCollectionView.register(ProfileImageSettingCollectionViewCell.self, forCellWithReuseIdentifier: ProfileImageSettingCollectionViewCell.id)
        
    }
    @objc func backButtonClicked() {
        navigationController?.popViewController(animated: true)
        UserDefaults.standard.set(profileName, forKey: UserDefaultsKey.profileName)
    }
    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width - 70
        layout.itemSize = CGSize(width: width/4, height: width/4)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right:20)
        return layout
    }

}
extension ProfileImageSettingViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profileImageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = profileCollectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageSettingCollectionViewCell.id, for: indexPath) as! ProfileImageSettingCollectionViewCell
        guard let udProfileName = UserDefaults.standard.string(forKey: UserDefaultsKey.profileName) else {
            return cell
        }
        cell.profileName = profileName
        cell.cofigureCell(data: profileImageList[indexPath.item])
        collectionView.reloadInputViews()

        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function, indexPath)
        // profileName 누른 item의 이름으로 변경..~~/ cell 변경은 어떻게 반영하지 ?
        // profileView 이미지 재설정~~
        // reloadedata로..₩~
        profileName = profileImageList[indexPath.item].rawValue
        profileImgaeView.configureUI(profile: profileName)
        collectionView.reloadData()
    }
    

}

#if DEBUG
@available (iOS 17, *)
#Preview {
    ProfileImageSettingViewController()
}
#endif
