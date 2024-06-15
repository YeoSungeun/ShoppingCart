//
//  Constant.swift
//  ShoppingCart
//
//  Created by 여성은 on 6/13/24.
//

import UIKit

enum Color {
    static let mainColor = UIColor(rgb: 0xEF8947)
    static let black = UIColor(rgb: 0x000000)
    static let darkgray = UIColor(rgb: 0x4C4C4C)
    static let gray = UIColor(rgb: 828282)
    static let lightgray = UIColor(rgb: 0xCDCDCD)
    static let white = UIColor(rgb: 0xFFFFFF)
}

enum Font {
    static let bold16 = UIFont.boldSystemFont(ofSize: 16)
    static let bold15 = UIFont.boldSystemFont(ofSize: 15)
    static let bold14 = UIFont.boldSystemFont(ofSize: 14)
    static let bold13 = UIFont.boldSystemFont(ofSize: 13)
    
    static let regular15 = UIFont.systemFont(ofSize: 15)
    static let regular14 = UIFont.systemFont(ofSize: 14)
    static let regular13 = UIFont.systemFont(ofSize: 13)
    
    static let logo = UIFont(name: "Rockwell Bold", size: 40)

}

enum Image {
    static let empty = UIImage(named: "empty")
    static let launch = UIImage(named: "launch")
}

enum UserDefaultsKey {
    static let profileName = "profileName"
}

