//
//  DBServise.swift
//  AvitoTestProject
//
//  Created by Матвей Федышин on 10.12.2023.
//

import Foundation

class DBServise {
    private let decoder = JSONDecoder()
    
    func fetchData(completion: @escaping (Result<ServerResponce, Error>) -> Void) {
        
        guard let url = Bundle.main.url(forResource: "Result", withExtension: "json") else {
            print("bad url")
            return
        }
        guard let data = try? Data(contentsOf: url) else {
            print("bad data")
            return
        }
        
        do {
            let jsonData = try decoder.decode(ServerResponce.self, from: data)
            completion(.success(jsonData))
            return
        } catch let error {
            completion(.failure(error))
            return
        }
    }
}
