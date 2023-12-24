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
    var result: Results
}

// MARK: - Result
struct Results: Decodable {
    let title: String
    let actionTitle: String
    let selectedActionTitle: String
    var list: [List]
}

// MARK: - List
struct List: Decodable {
    let id: String
    let title: String
    let description: String?
    let icon: Icon
    let price: String
    var isSelected: Bool
}

// MARK: - Icon
struct Icon: Decodable {
    let size: String

    enum CodingKeys: String, CodingKey {
        case size = "52x52"
    }
}
