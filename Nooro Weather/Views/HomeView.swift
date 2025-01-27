//
//  ContentView.swift
//  Nooro Weather
//
//  Created by Kibret Woldemichael on 1/26/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        VStack {
            VStack(spacing: 32) {
                HStack {
                    TextField("Search Location", text: $viewModel.searchText)
                        .foregroundStyle(.primary)
                        .font(.poppins(15))
                        .frame(maxWidth: .infinity)
                    
                    Spacer()
                    
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.tertiary)
                }
                .padding(.horizontal, 20)
                .frame(height: 46)
                .background(Color(uiColor: .tertiarySystemFill))
                .clipShape(.rect(cornerRadius: 16))
                
                if let searchedWeatherResponse = viewModel.searchedWeatherResponse {
                    Button {
                        viewModel.saveCity()
                    } label: {
                        HStack {
                            VStack(spacing: 13) {
                                Text(searchedWeatherResponse.location.name)
                                    .font(.poppins(20, weight: .bold))
                                    .foregroundStyle(.primary)
                                
                                Text(formatTemperature(searchedWeatherResponse.current.temp_f))
                                    .font(.poppins(60, weight: .medium))
                                    .foregroundStyle(.primary)
                            }
                            
                            Spacer()
                            
                            AsyncImage(url: URL(string: "https:\(searchedWeatherResponse.current.condition.icon)")) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 64, height: 64)
                                } else if phase.error != nil {
                                    Image(systemName: "exclamationmark.triangle")
                                        .frame(width: 64, height: 64)
                                        .foregroundStyle(.red)
                                } else {
                                    ProgressView()
                                }
                            }
                        }
                        .padding(.horizontal, 32)
                        .padding(.top, 16)
                        .background(Color(uiColor: .tertiarySystemFill))
                        .clipShape(.rect(cornerRadius: 16))
                    }
                    .buttonStyle(.plain)
                    
                }
            }
            .padding(.top, 44)

            Spacer()
            if viewModel.isSearching {
                ProgressView()
            } else if viewModel.searchText.isEmpty && !viewModel.isSearching && viewModel.searchedWeatherResponse == nil && viewModel.savedCity == nil {
                VStack(spacing: 16) {
                    Text("No City Selected")
                        .font(.poppins(30, weight: .bold))
                    
                    Text("Please Search For A City")
                        .font(.poppins(15, weight: .medium))
                }
                .padding()
            } else if !viewModel.isSearching, viewModel.searchText.isEmpty, let savedCityWeatherResponse = viewModel.savedCityWeatherResponse {
                VStack(spacing: 24) {
                    AsyncImage(url: URL(string: "https:\(savedCityWeatherResponse.current.condition.icon)")) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 123, maxHeight: 123)
                        } else if phase.error != nil {
                            Image(systemName: "exclamationmark.triangle")
                                .frame(width: 123, height: 123)
                                .foregroundStyle(.red)
                        } else {
                            ProgressView()
                        }
                    }
                    
                    HStack(spacing: 11) {
                        Text(savedCityWeatherResponse.location.name)
                            .font(.poppins(30, weight: .bold))
                            .foregroundStyle(.primary)
                        
                        Image(systemName: "location.fill")
                            .frame(width: 21, height: 21)
                    }
                    
                    Text(formatTemperature(savedCityWeatherResponse.current.temp_f))
                        .font(.poppins(70, weight: .medium))
                        .foregroundStyle(.primary)
                    
                    HStack(spacing: 56) {
                        VStack(spacing: 2) {
                            Text("Humidity")
                                .font(.poppins(12, weight: .medium))
                                .foregroundStyle(.secondary)
                            
                            Text("\(savedCityWeatherResponse.current.humidity)%")
                                .font(.poppins(15, weight: .medium))
                                .foregroundStyle(.secondary)
                        }
                        
                        VStack(spacing: 2) {
                            Text("UV")
                                .font(.poppins(12, weight: .medium))
                                .foregroundStyle(.secondary)
                            
                            Text("\(savedCityWeatherResponse.current.uv.formatted(.number.precision(.fractionLength(1))))")
                                .font(.poppins(15, weight: .medium))
                                .foregroundStyle(.secondary)
                        }
                        
                        VStack(spacing: 2) {
                            Text("Feels Like")
                                .font(.poppins(8, weight: .medium))
                                .foregroundStyle(.secondary)
                            
                            Text(formatTemperature(savedCityWeatherResponse.current.feelslike_f))
                                .font(.poppins(15, weight: .medium))
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(16)
                    .frame(height: 75)
                    .background(Color(uiColor: .tertiarySystemFill))
                    .clipShape(.rect(cornerRadius: 16))
                }
                Spacer()
            }
            Spacer()
        }
        .padding(.horizontal, 24)
    }
    
    private func formatTemperature(_ temperature: Double) -> String {
        let temp: Measurement<UnitTemperature> = .init(value: temperature, unit: .fahrenheit)
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .temperatureWithoutUnit
        formatter.numberFormatter.maximumFractionDigits = 0
        return formatter.string(from: temp)
    }
}

#Preview {
    HomeView()
}
