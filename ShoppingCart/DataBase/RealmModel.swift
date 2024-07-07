//
//  RealmModel.swift
//  ShoppingCart
//
//  Created by 여성은 on 7/8/24.
//

import Foundation
import RealmSwift

class LikedItem: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted(indexed: true) var title: String
    @Persisted var link: String
    @Persisted var image : String
    @Persisted var lprice : String
    @Persisted var mallName: String
    
    convenience init(id: String, title: String, link: String, image: String, lprice: String, mallName: String) {
        self.init()
        self.id = id
        self.title = title
        self.link = link
        self.image = image
        self.lprice = lprice
        self.mallName = mallName
    }
}
