//
//  WeatherModel.swift
//  Nooro Weather
//
//  Created by Kibret Woldemichael on 1/26/25.
//

struct WeatherResponse: Codable {
    var location: LocationModel
    var current: WeatherModel
}

struct LocationModel: Codable {
    var name: String
}

struct WeatherModel: Codable {
    var condition: WeatherCondition
    var humidity: Int
    var temp_f: Double
    var feelslike_f: Double
    var uv: Double
}

struct WeatherCondition: Codable {
    var text: String
    var icon: String
}
