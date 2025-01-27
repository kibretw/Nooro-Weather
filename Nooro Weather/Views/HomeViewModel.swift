//
//  HomeViewModel.swift
//  Nooro Weather
//
//  Created by Kibret Woldemichael on 1/26/25.
//
import Combine
import Foundation
import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    var weatherService: WeatherServiceable
    
    @Published var savedCityWeatherResponse: WeatherResponse?
    
    @Published var searchedWeatherResponse: WeatherResponse?
    
    @Published var searchText: String = ""
    
    @Published var debouncedSearchText: String = ""
    
    @Published var isSearching: Bool = false
        
    private var cancellables = Set<AnyCancellable>()
    
    @AppStorage("savedCity") var savedCity: String?
        
    init(_ weatherService: WeatherServiceable = WeatherService()) {
        self.weatherService = weatherService
        
        if let savedCity {
            Task { await performSearch(for: savedCity) }
        }
        
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] text in
                self?.debouncedSearchText = text
                Task { await self?.performSearch(for: text) }
            }
            .store(in: &cancellables)
    }
    
    func saveCity() {
        savedCityWeatherResponse = searchedWeatherResponse
        savedCity = searchedWeatherResponse?.location.name
        searchText = ""
    }
        
    private func performSearch(for query: String) async {
        searchedWeatherResponse = nil
        guard !query.isEmpty else {
            return
        }
        
        isSearching = true
        
        let result = await weatherService.getWeather(for: query)
        
        switch result {
        case .success(let response):
            if !searchText.isEmpty {
                searchedWeatherResponse = response
            } else {
                savedCityWeatherResponse = response
            }
        case .failure(let failure):
            print(failure.message)
        }
        
        isSearching = false
    }
}
