//
//  Result.swift
//  ShoppingCart
//
//  Created by 여성은 on 6/17/24.
//

import Foundation

struct Result: Decodable {
    let total: Int
    let start: Int
    let display: Int
    var items: [Item]
    var totalString: String {
        let totalFormat = total.formatted()
        return "\(totalFormat)개의 검색 결과"
    }
}

struct Item: Decodable {
    let title: String
    let link: String
    let image: String
    let lprice: String
    let mallName: String
    let productId: String
    
    var linkURL: URL {
        let url = URL(string: link) ?? URL(string: "https://www.naver.com")!
        return url
    }
    var lpriceformat: String {
        let string = "\(Int(lprice)!.formatted())원"
        return string
    }
    var imageURL: URL? {
        let url = URL(string: image)
        return url
    }
}

