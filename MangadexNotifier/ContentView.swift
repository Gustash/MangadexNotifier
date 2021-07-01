//
//  ContentView.swift
//  MangadexNotifier
//
//  Created by Gustavo Parreira on 15/06/2021.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var API = MangadexAPI()
    @StateObject private var dataStore = DataStore()
    
    var body: some View {
        NavigationView {
            if !dataStore.authenticated {
                Login(dataStore: dataStore)
            } else {
                Home(dataStore: dataStore)
            }
        }
        .environmentObject(dataStore)
        .environmentObject(API)
        .onAppear {
            API.refreshTokenDelegate = dataStore
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(DataStore.preview)
    }
}
