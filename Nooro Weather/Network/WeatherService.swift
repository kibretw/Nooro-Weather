//
//  WeatherService.swift
//  Nooro Weather
//
//  Created by Kibret Woldemichael on 1/26/25.
//

protocol WeatherServiceable {
    func getWeather(for city: String) async -> Result<WeatherResponse, RequestError>
}

struct WeatherService: HTTPClient, WeatherServiceable {
    func getWeather(for city: String) async -> Result<WeatherResponse, RequestError> {
        return await getWeatherData(city: city, responseModel: WeatherResponse.self)
    }
    
}
