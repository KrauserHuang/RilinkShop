//
//  NetworkManager.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/11/22.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    
    private func fetchData<T: Decodable>(endpoint: String, completion: @escaping (Result<T, RSError>) -> Void) {
        guard let url = URL(string: endpoint) else {
            completion(.failure(.connectionFailure))
            return
        }
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        
    }
}
