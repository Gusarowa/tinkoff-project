//
//  APIStructs.swift
//  Remindew
//
//  Created by Лена Гусарова on 01.06.2023.

import Foundation

struct PlantData: Decodable {
    let data: [PlantSearchResult]
}


struct PlantSearchResult: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case commonName = "common_name"
        case scientificName = "scientific_name"
        case imageUrl = "image_url"
    }
    
    let commonName: String?
    let scientificName: String?
    
    /// "https://bs.floristic.org/image/o/4b5d9bab278879892ab945b84b7f5b24c8edca6f"
    let imageUrl: URL?
}


struct TempToken: Decodable {
    let token: String?
    let expiration: String?
}


enum NetworkError: Error {
    case noAuth
    case badAuth
    case otherError
    case badData
    case noDecode
    case noEncode
    case noToken
    case invalidURL
    case noData
    case invalidToken
    case serverDown
}
