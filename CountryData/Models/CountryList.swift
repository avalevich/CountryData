//
//  CountryList.swift
//  CountryData
//
//  Created by Alex on 19/05/2023.
//

import Foundation

struct Country: Codable {
    let name: String
    let emoji: String
}

struct Countries: Codable {
    let countries: [Country]
}

struct Continents: Codable {
    let continents: [Countries]
}

struct CountryList: Codable {
    let data: Continents
}
