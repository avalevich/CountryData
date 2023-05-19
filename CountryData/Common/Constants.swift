//
//  Constants.swift
//  CountryData
//
//  Created by Alex on 19/05/2023.
//

import Foundation

struct Constants {
    static let codeToCountries = [
        "AF": "Africa",
        "AN": "Antarctica",
        "AS": "Asia",
        "EU": "Europe",
        "NA": "North America",
        "OC": "Oceania",
        "SA": "South America"
    ]
    
    static let countriesToCode = [
        "Africa" :"AF",
        "Antarctica": "AN",
        "Asia": "AS",
        "Europe": "EU",
        "North America": "NA",
        "Oceania": "OC",
        "South America": "SA"
    ]
    
    private static let RESTCountriesBaseURLKey = "RESTCountriesBaseURL"
    private static let GQCountriesBaseURLKey = "GQCountriesBaseURL"
    
    static let RESTCountriesBaseURL = Bundle.main.object(forInfoDictionaryKey: Constants.RESTCountriesBaseURLKey) as? String ?? ""
    static let GQCountriesBaseURL = Bundle.main.object(forInfoDictionaryKey: Constants.GQCountriesBaseURLKey) as? String ?? ""
}
