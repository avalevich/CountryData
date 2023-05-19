//
//  APICaller.swift
//  CountryData
//
//  Created by Alex on 19/05/2023.
//

import Foundation

enum APICallerErrors {
    case internalAPIError
    case serverError
}

protocol GraphQLCountriesCaller {
    func getCountries(for continentCode: String, completion: @escaping () -> ())
}

protocol RESTCountriesCaller {
    func getDetailedInfo(for countryName: String, completion: @escaping () -> ())
}

final class APICaller {
    
    static let shared = APICaller()
    
    private init() {}
    
}

//MARK: - GraphQLCountriesCaller
extension APICaller: GraphQLCountriesCaller {
    func getCountries(for continentCode: String, completion: @escaping () -> ()) {
        
    }
}

//MARK: - RESTCountriesCaller
extension APICaller: RESTCountriesCaller {
    func getDetailedInfo(for countryName: String, completion: @escaping () -> ()) {
        
    }
}
