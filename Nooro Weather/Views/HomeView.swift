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
        ZStack {
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

                if let weatherResponse = viewModel.weatherResponse {
                    HStack {
                        VStack(spacing: 13) {
                            Text(weatherResponse.location.name)
                                .font(.poppins(20, weight: .bold))
                                .foregroundStyle(.primary)
                            
                            Text("\(Int(weatherResponse.current.temp_f))\u{00B0}")
                                .font(.poppins(60, weight: .medium))
                                .foregroundStyle(.primary)
                        }
                        
                        Spacer()
                        
                        AsyncImage(url: URL(string: "https:\(weatherResponse.current.condition.icon)")) { phase in
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
                Spacer()
            }
            
            if viewModel.isSearching {
                ProgressView()
            } else if viewModel.searchText.isEmpty && !viewModel.isSearching && viewModel.weatherResponse == nil {
                VStack(spacing: 16) {
                    Text("No City Selected")
                        .font(.poppins(30, weight: .bold))
                    
                    Text("Please Search For A City")
                        .font(.poppins(15, weight: .medium))
                }
                .padding()
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 44)
    }
}

#Preview {
    HomeView()
}
