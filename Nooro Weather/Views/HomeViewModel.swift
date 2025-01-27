//
//  HomeViewModel.swift
//  Nooro Weather
//
//  Created by Kibret Woldemichael on 1/26/25.
//
import Combine
import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    var weatherService: WeatherServiceable
    
    @Published var weatherResponse: WeatherResponse?
    
    @Published var searchText: String = ""
    
    @Published var debouncedSearchText: String = ""
    
    @Published var isSearching: Bool = false
        
    private var cancellables = Set<AnyCancellable>()
        
    init(_ weatherService: WeatherServiceable = WeatherService()) {
        self.weatherService = weatherService
        
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] text in
                self?.debouncedSearchText = text
                Task { await self?.performSearch(for: text) }
            }
            .store(in: &cancellables)
    }
        
    private func performSearch(for query: String) async {
        weatherResponse = nil
        guard !query.isEmpty else {
            return
        }
        
        isSearching = true
        
        let result = await weatherService.getWeather(for: query)
        
        switch result {
        case .success(let response):
            weatherResponse = response
        case .failure(let failure):
            print(failure.message)
        }
        
        isSearching = false
    }
}
