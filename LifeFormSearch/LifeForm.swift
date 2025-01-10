//
//  LifeForm.swift
//  LifeFormSearch
//
//  Created by Skyler Robbins on 12/18/24.
//

import Foundation

struct LifeForm: Codable {
    let id: Int
    let scientificName: String
    let commonName: String
    let link: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case scientificName = "title"
        case commonName = "content"
        case link
    }
    
}

struct LifeFormSearchResponse: Codable {
    let results: [LifeForm]
}
