//
//  Network.swift
//  SwiftUICombineMVVMSample
//
//  Created by NohEunTae on 2021/01/12.
//

import Foundation
import Combine

final class Meta {
    let next_page: Int
    
    init(next_page: Int = 0) {
        self.next_page = next_page
    }
}

final class Response {
    let data: [Data]
    let meta: Meta
    
    init(data: [Data] = [], meta: Meta = Meta()) {
        self.data = data
        self.meta = meta
    }
}

func request(url: String, parameters: [String: Any]?) -> AnyPublisher<NetworkResult<Response>, Never> {
    return Deferred {
        Future { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.2) {
                var response = Response()
                /* ---------------------------- for test ---------------------------- */
                if let page = parameters?["page"] as? Int,
                    let orderBy = parameters?["order_by"] as? String,
                    let filter = Filter(rawValue: orderBy) {

                    var data: [Data] = []
                    
                    let name = filter.rawValue
                    print("\(name) called page: \(page)")
                    
                    for i in 1..<21 {
                        data.append(Data(value: (page - 1) * 20 + i, name: name, age: Int.random(in: 20..<40)))
                    }
                    
                    response = Response(data: data, meta: Meta(next_page: page + 1))
                }
                /* ------------------------------------------------------------------- */

                DispatchQueue.main.async {
                    promise(.success(.success(response)))
                }
            }
        }
    }.eraseToAnyPublisher()

}

final class NetworkManager {
    static let shared = NetworkManager()
    
    func fetchItems(page: Int, filter: Filter) -> AnyPublisher<NetworkResult<Response>, Never> {
        let url = ""
        let params: [String: Any] = [
            "page" : page,
            "per_page" : 20,
            "order_by" : filter.rawValue,
        ]

        return request(url: url, parameters: params)
    }
    
    func purchaseItem() -> AnyPublisher<NetworkResult<Response>, Never> {
        return request(url: "", parameters: nil)
    }
    
    func like() -> AnyPublisher<NetworkResult<Response>, Never> {
        return request(url: "", parameters: nil)
    }
}

enum NetworkResult<T> {
    case success(T)
    case failure(Error)
}
