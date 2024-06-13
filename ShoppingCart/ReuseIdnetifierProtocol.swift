//
//  ReuseIdnetifierProtocol.swift
//  ShoppingCart
//
//  Created by 여성은 on 6/13/24.
//

import UIKit

protocol ReuseIdnetifierProtocol {
    static var id: String { get }
}

extension UIViewController: ReuseIdnetifierProtocol {
    static var id: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReuseIdnetifierProtocol {
    static var id: String {
        return String(describing: self)
    }

}

extension UICollectionViewCell: ReuseIdnetifierProtocol {
    static var id: String {
        return String(describing: self)
    }
}
