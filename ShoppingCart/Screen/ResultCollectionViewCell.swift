//
//  ResultCollectionViewCell.swift
//  ShoppingCart
//
//  Created by 여성은 on 6/18/24.
//

import UIKit

class ResultCollectionViewCell: UICollectionViewCell {
    
    let itemImageView = UIImageView()
    let likeButton = UIButton()
    let itemInfoView = UIView()
    let mallNameLabel = UILabel()
    let titleLabel = UILabel()
    let lpriceLabel = UILabel()
    
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
        contentView.addSubview(itemImageView)
        contentView.addSubview(itemInfoView)
        contentView.addSubview(likeButton)
        itemInfoView.addSubview(mallNameLabel)
        itemInfoView.addSubview(titleLabel)
        itemInfoView.addSubview(lpriceLabel)
    }
    func configureLayout() {
        itemImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(contentView.snp.height).multipliedBy(0.65)
        }
        likeButton.snp.makeConstraints { make in
            make.trailing.equalTo(itemImageView.snp.trailing).inset(12)
            make.bottom.equalTo(itemImageView.snp.bottom).inset(12)
            make.size.equalTo(28)
        }
        itemInfoView.snp.makeConstraints { make in
            make.top.equalTo(itemImageView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(contentView.safeAreaLayoutGuide)
        }
        mallNameLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().offset(4)
            make.height.equalTo(20)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mallNameLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview()
            make.height.lessThanOrEqualTo(44)
        }
        lpriceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(20)
        }
    }
    func configureUI() {
        itemImageView.clipsToBounds = true
        itemImageView.contentMode = .scaleAspectFill
        itemImageView.layer.cornerRadius = 10
        mallNameLabel.font = Font.regular13
        mallNameLabel.textColor = Color.lightgray
        titleLabel.font = Font.regular13
        titleLabel.numberOfLines = 2
        lpriceLabel.font = Font.bold15
    }
    func configureCell(data: Item) {
        guard let url = data.imageURL else { return }
        
        DispatchQueue.global().async {
            do {
                let image = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    self.itemImageView.image = UIImage(data: image)
                }
            } catch {
                self.itemImageView.image = UIImage(systemName: "star")
            }
        }
        
        mallNameLabel.text = data.mallName
        titleLabel.attributedText = data.title.htmlToAttributedString
        lpriceLabel.text = data.lpriceformat
        
        let likeList = UserDefaults.standard.array(forKey: UserDefaultsKey.likeList) as? [String] ?? []
        
        if likeList.contains(data.productId) {
            likeButton.configuration = .cellSelectedStyle()
        } else {
            likeButton.configuration = .cellUnselectedStyle()
        }

    }
}
