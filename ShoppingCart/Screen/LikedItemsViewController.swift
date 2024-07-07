//
//  LikedItemsViewController.swift
//  ShoppingCart
//
//  Created by 여성은 on 7/8/24.
//

import UIKit
import RealmSwift

class LikedItemsViewController: UIViewController {
    let repository = LikedItemRepository()
    var likedItemList: Results<LikedItem>!

    override func viewDidLoad() {
        super.viewDidLoad()
        repository.getFileURL()
        likedItemList = repository.fetchAll()
    }


}
