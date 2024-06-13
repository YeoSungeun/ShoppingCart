//
//  PointButton.swift
//  ShoppingCart
//
//  Created by 여성은 on 6/13/24.
//

import UIKit

class PointButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        setTitleColor(Color.white, for: .normal)
        backgroundColor = Color.mainColor
        layer.cornerRadius = 25
        titleLabel?.font = Font.bold16
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
