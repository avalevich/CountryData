//
//  APICaller.swift
//  CountryData
//
//  Created by Alex on 19/05/2023.
//

import Foundation

enum APICallerErrors: Error {
    case badURL
    case serverError
    case unexpectedDataReturned
    case decodingError
    case badCountryName
    
    var description: String {
        get {
            switch self {
            case .badURL, .unexpectedDataReturned, .decodingError, .badCountryName:
                return "Internal API error occurred."
            case .serverError:
                return "Remote server error occurred."
            }
        }
    }
}

protocol GraphQLCountriesCaller {
    func getCountries(for continentCode: String, completion: @escaping (Result<[Country], APICallerErrors>) -> ())
}

protocol RESTCountriesCaller {
    func getDetailedInfo(for countryName: String, completion: @escaping (Result<CountryInfo?, APICallerErrors>) -> ())
}

final class APICaller {
    
    static let shared = APICaller()
    
    private init() {}
    
    private enum HTTPMethod: String {
        case POST
    }
}

//MARK: - GraphQLCountriesCaller
extension APICaller: GraphQLCountriesCaller {
    func getCountries(for continentCode: String, completion: @escaping (Result<[Country], APICallerErrors>) -> ()) {
        let baseURL = Constants.GQCountriesBaseURL
        guard let url = URL(string: baseURL) else {
            completion(.failure(.badURL))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.POST.rawValue
        let query = """
                query {
                  continents(filter: {code: {eq: "\(continentCode)"}}) {
                    countries {
                      name
                      emoji
                    }
                  }
                }
                """
        request.httpBody = try? JSONSerialization.data(withJSONObject: [
            "query" : query
        ])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(.serverError))
                return
            }
            do {
                let result = try JSONDecoder().decode(CountryList.self, from: data)
                guard let countries = result.data.continents.first?.countries else {
                    completion(.failure(.unexpectedDataReturned))
                    return
                }
                completion(.success(countries))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}

//MARK: - RESTCountriesCaller
extension APICaller: RESTCountriesCaller {
    func getDetailedInfo(for countryName: String, completion: @escaping (Result<CountryInfo?, APICallerErrors>) -> ()) {
        guard let countryName = countryName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            // will never happen
            completion(.failure(.badCountryName))
            return
        }
        let baseURL = Constants.RESTCountriesBaseURL + countryName
        guard let url = URL(string: baseURL) else {
            completion(.failure(.badURL))
            return
        }
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.serverError))
                return
            }
            do {
                let result = try JSONDecoder().decode([CountryInfo].self, from: data)
                guard let info = result.first else {
                    completion(.failure(.unexpectedDataReturned))
                    return
                }
                completion(.success(info))
            } catch {
                completion(.success(.nil))
            }
        }.resume()
    }
}
