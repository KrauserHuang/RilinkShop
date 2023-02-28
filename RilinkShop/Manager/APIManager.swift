//
//  APIManager.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/11/22.
//

import UIKit

protocol APIManagerProtocol {
    func perform()
}

class APIManager {
    static let shared = APIManager()
    
    private func fetchData<T: Decodable>(endpoint: String, completion: @escaping (Result<T, RSError>) -> Void) {
        guard let url = URL(string: endpoint) else {
            completion(.failure(.connectionFailure))
            return
        }
        
        
    }
}
