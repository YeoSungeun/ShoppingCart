//
//  UIButton+Extension.swift
//  ShoppingCart
//
//  Created by 여성은 on 6/17/24.
//

import UIKit

extension UIButton.Configuration {
    static func unselectedStyle(title: String) -> UIButton.Configuration {
        var configuration = UIButton.Configuration.filled()
        configuration.title = title
        configuration.attributedTitle?.font = Font.bold13
        configuration.titleAlignment = .center
        configuration.baseBackgroundColor = Color.white
        configuration.baseForegroundColor = Color.darkgray
        configuration.background.strokeColor = Color.darkgray
        configuration.cornerStyle = .capsule

        return configuration
    }
    
    static func selectedStyle(title: String) -> UIButton.Configuration {
        var configuration = UIButton.Configuration.filled()
        configuration.title = title
        configuration.attributedTitle?.font = Font.bold13
        configuration.titleAlignment = .center
        configuration.baseBackgroundColor = Color.darkgray
        configuration.baseForegroundColor = Color.white
        configuration.cornerStyle = .capsule

        return configuration
    }
    static func cellSelectedStyle() -> UIButton.Configuration {
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage.likeSelected
        configuration.baseBackgroundColor = .white
        configuration.baseForegroundColor = .black
        
        return configuration
    }
    static func cellUnselectedStyle() -> UIButton.Configuration {
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage.likeUnselected
        configuration.baseBackgroundColor = .black.withAlphaComponent(0.5)
        configuration.baseForegroundColor = .white
        
        return configuration
    }

}

