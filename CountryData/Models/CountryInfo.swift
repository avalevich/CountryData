//
//  CountryInfo.swift
//  CountryData
//
//  Created by Alex on 19/05/2023.
//

import Foundation

struct Name: Codable {
    let official: String
}

struct CurrencyInfo: Codable {
    let name: String
    let shortName: String
    
    enum CodingKeys: CodingKey {
        case name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: CodingKeys.name)
        shortName = container.codingPath.last!.stringValue
    }
}

struct Currency: Codable {
    let array: [CurrencyInfo]
    
    private struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        var intValue: Int?
        init?(intValue: Int) {
            return nil
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        
        var tempArray = [CurrencyInfo]()
        for key in container.allKeys {
            let decodedObject = try container.decode(CurrencyInfo.self, forKey: DynamicCodingKeys(stringValue: key.stringValue)!)
            tempArray.append(decodedObject)
        }
        array = tempArray
    }
}

struct CountryInfo: Codable {
    let name: Name
    let capital: [String]?
    let population: Int
    let region: String
    let subregion: String?
    let currencies: Currency?
    
}
