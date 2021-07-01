//
//  Profile.swift
//  MangadexNotifier
//
//  Created by Gustavo Parreira on 15/06/2021.
//

import SwiftUI

struct Profile: View {
    @ObservedObject var dataStore: DataStore
    @EnvironmentObject var API: MangadexAPI
    @State private var user: User?
    
    var body: some View {
        if let user = user {
            Text("Hello, \(user.attributes.username)")
        } else {
            ProgressView()
                .task {
                    await loadUser()
                }
        }
    }
    
    private func loadUser() async {
        do {
            user = try await API.userDetails(auth: dataStore.auth)
        } catch {
            print("Error fetching user: \(error)")
        }
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile(dataStore: DataStore.preview)
            .environmentObject(MangadexAPI())
    }
}
