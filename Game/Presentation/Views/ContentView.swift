//
//  ContentView.swift
//  Game
//
//  Created by Hafid Ali Mustaqim on 10/06/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            FavoriteView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorites")
                }
            
            AboutView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("About")
                }
        }
    }
}

#Preview {
    ContentView()
}
