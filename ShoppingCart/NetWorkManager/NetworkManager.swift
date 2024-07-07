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
    
    func callRequest(query: String, sort: Sort, start: Int, completionHandler: @escaping (Result?, APIError?) -> Void) {
        
        var component = URLComponents()
        component.scheme = "https"
        component.host = "openapi.naver.com"
        component.path = "/v1/search/shop.json"
        component.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "display", value: "30"),
            URLQueryItem(name: "sort", value: "\(sort)"),
            URLQueryItem(name: "start", value: "\(start)")
        ]
        guard let url = component.url else { return }
        var request = URLRequest(url: url)
        request.addValue(APIKey.naverID, forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue(APIKey.naverSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async { // 안에 일이 크지 않으면 애초에 main으로 내부 일을 돌려버리기
                guard error == nil else {
                    // 에러 있는 경우
                    print("Failed Request")
                    completionHandler(nil, .failedRequest)
                    return // 실행이 끝나야 아래쪽으로 실행이 안되기 때문
                }
                guard let data = data else {
                    // 에러 nil, data 없는 경우
                    print("No Data Returned")
                    completionHandler(nil, .noData)
                    return
                }
                // error가  nil인 상황, data가 있는 상황
                guard let response = response as? HTTPURLResponse else {
                    // response가 HTTPURLResponse에 맞지 않는 경우
                    print("Unable Response")
                    completionHandler(nil, .invalidResponse)
                    return
                }
                // 코드가 200이 아니라 400,500일 수 있기 때무에 ~
                guard response.statusCode == 200 else {
                    // error nil, data != nil, HTTPURLResponse인 response의 statuCode가 200아닌경우
                    print("failed Response")
                    completionHandler(nil, .failedRequest)
                    return
                }
                print("이제 식판에 담으면 됨!")
                // error nil, data o , response status 200
                // string -> json -> struct () decode
                
                do {
                    let result = try JSONDecoder().decode(Result.self, from: data)
                    print("Success")
                    print(result)
                    completionHandler(result, nil)
                } catch {
                    print("Error")
                    print(error)
                    completionHandler(nil, .invalidData)
                }
            }
        }.resume()
    }
}

enum APIError: Error {
    case failedRequest
    case noData
    case invalidResponse
    case invalidData
}


