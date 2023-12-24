//
//  NetworkManager.swift
//  AvitoTestProject
//
//  Created by Матвей Федышин on 21.12.2023.
//

import Foundation

class NetworkManager {
    func getIconImage(with url: String, completion: @escaping (Result<Data, ErrorMessage>) -> Void) {
        guard let url = URL(string: url) else { return }
        let request = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            completion(.success(data))
        }
        dataTask.resume()
    }
}
