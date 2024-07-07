//
//  SettingListTableViewCell.swift
//  ShoppingCart
//
//  Created by 여성은 on 6/17/24.
//

import UIKit


class SettingListTableViewCell: UITableViewCell {
    
    let settingLabel = UILabel()
    
    let myItemCountView = UIView()
    let likeImageView = UIImageView()
    let myItemCountLabel = UILabel()

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
        contentView.addSubview(settingLabel)
        contentView.addSubview(myItemCountView)
        myItemCountView.addSubview(likeImageView)
        myItemCountView.addSubview(myItemCountLabel)
    }
    func configureLayout() {
        settingLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(20)
            make.centerY.equalToSuperview()
        }
        myItemCountView.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(20)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(contentView.snp.width).multipliedBy(0.4)
        }
        myItemCountLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(15)
        }
        likeImageView.snp.makeConstraints { make in
            make.trailing.equalTo(myItemCountLabel.snp.leading).offset(-4)
            make.centerY.equalToSuperview()
            make.height.equalTo(myItemCountLabel)
        }
        

    }
    func configureUI() {
        settingLabel.font = Font.regular14
        settingLabel.textColor = Color.black
        myItemCountLabel.font = Font.bold14
        myItemCountLabel.textColor = Color.black
    }
    func configureCell(data: SettingList) {
        settingLabel.text = data.rawValue
        if data == .myCart {
            let userLikeList = UserDefaults.standard.array(forKey: UserDefaultsKey.likeList)
            let count = userLikeList?.count ?? 0
            likeImageView.image = UIImage.likeSelected
            myItemCountLabel.text = "\(String(describing: count))개의 상품"
        } else {
            likeImageView.image = nil
            myItemCountLabel.text = ""
        }
    }

}
