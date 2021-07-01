//
//  DataStore.swift
//  MangadexNotifier
//
//  Created by Gustavo Parreira on 15/06/2021.
//

import Foundation

class DataStore: ObservableObject {
    static var preview: DataStore {
        get {
            DataStore()
        }
    }
    
    init() {
        if let session = UserDefaults.standard.string(forKey: UserDefaultKeys.session),
           let refresh = UserDefaults.standard.string(forKey: UserDefaultKeys.refresh) {
            auth = AuthToken(session: session, refresh: refresh)
        }
    }
    
    @Published var auth: AuthToken? {
        didSet {
            if let auth = auth {
                UserDefaults.standard.set(auth.session, forKey: UserDefaultKeys.session)
                UserDefaults.standard.set(auth.refresh, forKey: UserDefaultKeys.refresh)
            }
        }
    }
    var authenticated: Bool {
        get {
            auth != nil
        }
    }
}

extension DataStore: RefreshTokenDelegate {
    func did(refresh token: AuthToken) {
        auth = token
    }
}
