//
//  ServerResponce.swift
//  AvitoTestProject
//
//  Created by Матвей Федышин on 10.12.2023.
//

import Foundation

// MARK: - ServerResponce
struct ServerResponce: Decodable {
    let status: String
    let result: Results
}

// MARK: - Result
struct Results: Decodable {
    let title: String
    let actionTitle: String
    let selectedActionTitle: String
    let list: [List]
}

// MARK: - List
struct List: Decodable {
    let id: String
    let title: String
    let description: String?
    let icon: Icon
    let price: String
    let isSelected: Bool
}

// MARK: - Icon
struct Icon: Decodable {
    let the52X52: String

    enum CodingKeys: String, CodingKey {
        case the52X52 = "52x52"
    }
}
