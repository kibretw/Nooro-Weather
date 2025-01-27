//
//  HTTPClient.swift
//  Nooro Weather
//
//  Created by Kibret Woldemichael on 1/26/25.
//

import Foundation

protocol HTTPClient {
    func getWeatherData<T: Codable>(
        city: String,
        responseModel: T.Type
    ) async -> Result<T, RequestError>
}

extension HTTPClient {
    func getWeatherData<T: Codable>(
        city: String,
        responseModel: T.Type
    ) async -> Result<T, RequestError> {
        guard let url = URL(string: "https://api.weatherapi.com/v1/current.json")?.appending(queryItems: [.init(name: "key", value: "a6be4199a22d4fea9a625028252701"), .init(name: "q", value: city), .init(name: "aqi", value: "yes")]) else {
            return .failure(.init(message: "Invalid URL"))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.init(message: "No response returned from server"))
            }
            switch response.statusCode {
            case 200...299:
                let decoder = JSONDecoder()
                do {
                    let decodedResponse = try decoder.decode(T.self, from: data)
                    return .success(decodedResponse)
                } catch let DecodingError.dataCorrupted(context) {
                    print(context)
                } catch let DecodingError.keyNotFound(key, context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.typeMismatch(type, context)  {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
                return .failure(.init(message: "Error decoding data"))
            case 401:
                return .failure(.init(message: "Unauthorized"))
            default:
                return .failure(.init(message: "Unknown error code"))
            }
        } catch {
            return .failure(.init(message: "Unknown error"))
        }
    }
}

struct RequestError: Codable, Error {
    var message: String?
}
