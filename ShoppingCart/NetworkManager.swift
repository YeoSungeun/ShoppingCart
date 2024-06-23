//
//  NetworkManager.swift
//  ShoppingCart
//
//  Created by 여성은 on 6/24/24.
//

import Foundation
import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() { }
    
    func getResult(query: String, sort: Sort, start: Int, completionHandler: @escaping (Result) -> Void) {
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(query)&display=30&sort=\(sort.rawValue)&start=\(start)"
        let header: HTTPHeaders = ["X-Naver-Client-Id": APIKey.naverID,
                                   "X-Naver-Client-Secret": APIKey.naverSecret]
        
        AF.request(url, headers: header).responseDecodable(of: Result.self) { response in
            switch response.result {
            case .success(let value):
                print(value)
                completionHandler(value)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
