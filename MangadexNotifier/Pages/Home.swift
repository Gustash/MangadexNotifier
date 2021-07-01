//
//  Home.swift
//  MangadexNotifier
//
//  Created by Gustavo Parreira on 15/06/2021.
//

import SwiftUI

struct Home: View {
    @ObservedObject var dataStore: DataStore
    
    var body: some View {
        TabView {
            Feed(dataStore: dataStore)
                .tabItem {
                    Image(systemName: "text.book.closed")
                    Text("Feed")
                }

            Profile(dataStore: dataStore)
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Home(dataStore: DataStore.preview)
        }
    }
}
