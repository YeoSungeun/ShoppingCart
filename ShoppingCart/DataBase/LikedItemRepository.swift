//
//  LikedItemRepository.swift
//  ShoppingCart
//
//  Created by 여성은 on 7/8/24.
//

import UIKit
import RealmSwift

final class LikedItemRepository {
    private let realm = try! Realm()
    
    func getFileURL() {
        guard let fileURL = realm.configuration.fileURL else { return }
        print(fileURL)
    }
    
    
    func createItem(_ data: LikedItem) {
        try! realm.write {
            realm.add(data)
        }
    }
    
    func updateItem(value: [String: Any]) {
        try! realm.write {
            realm.create(LikedItem.self, value: value, update: .modified)
        }
    }
    func updateItems(table: Results<LikedItem>!, value: Any?, forKey: String) {
        try! realm.write {
            table.setValue(value, forKey: forKey)
        }
    }
    
    func deleteItem(_ data: LikedItem, id: String) {
//        try! realm.write {
//            realm.delete(data)
//        }
        try! realm.write {
            realm.delete(realm.objects(LikedItem.self).filter("id=%@", id))
        }
    }
    
    func fetchAll() -> Results<LikedItem>! {
        let value = realm.objects(LikedItem.self)
        return value
    }
    func fetchData(id: String) -> LikedItem? {
        guard let value = realm.object(ofType: LikedItem.self, forPrimaryKey: id) else { return nil }
        return value
    }
   

}
