//
//  RecentSearchTableViewCell.swift
//  ShoppingCart
//
//  Created by 여성은 on 6/16/24.
//

import UIKit
import SnapKit

class RecentSearchTableViewCell: UITableViewCell {
    let clockImgaeView = UIImageView()
    let searchWordLabel = UILabel()
    let deleteButton = UIButton()

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
        contentView.addSubview(clockImgaeView)
        contentView.addSubview(searchWordLabel)
        contentView.addSubview(deleteButton)
    }
    func configureLayout() {
        clockImgaeView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(20)
            make.verticalEdges.equalToSuperview().inset(12)
            make.width.equalTo(clockImgaeView.snp.height)
        }
        searchWordLabel.snp.makeConstraints { make in
            make.leading.equalTo(clockImgaeView.snp.trailing).offset(16)
            make.verticalEdges.equalToSuperview()
            make.trailing.equalTo(deleteButton.snp.leading)
        }
        deleteButton.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(20)
            make.verticalEdges.equalToSuperview()
            
        }
    }
    func configureUI() {
        
        clockImgaeView.image = UIImage(systemName: "clock")
        clockImgaeView.contentMode = .scaleAspectFit
        clockImgaeView.tintColor = Color.black
        
        searchWordLabel.font = Font.regular13
        
        deleteButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        deleteButton.tintColor = Color.black

    }
    func configureCell(data: String) {
        searchWordLabel.text = data
    }
    
}
