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
            VStack {
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

                
                Spacer()
            }
            
            VStack(spacing: 16) {
                Text("No City Selected")
                    .font(.poppins(30, weight: .bold))
                
                Text("Please Search For A City")
                    .font(.poppins(15, weight: .medium))
            }
            .padding()
        }
        .padding(.horizontal, 24)
        .padding(.top, 44)
    }
}

#Preview {
    HomeView()
}
