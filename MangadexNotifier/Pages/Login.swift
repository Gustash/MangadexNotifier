//
//  Login.swift
//  MangadexNotifier
//
//  Created by Gustavo Parreira on 15/06/2021.
//

import SwiftUI

struct Login: View {
    @ObservedObject var dataStore: DataStore
    @EnvironmentObject var API: MangadexAPI
    @State private var submitting = false
    @State private var loginData = LoginData()
    @State private var errors: [MangadexError] = []
    
    var body: some View {
        VStack {
            Form {
                Section {
                    TextField("Username", text: $loginData.username)
                        .autocapitalization(.none)
                        .textContentType(.username)
                        .disableAutocorrection(true)
                    SecureField("Password", text: $loginData.password)
                        .textContentType(.password)
                        .disableAutocorrection(true)
                } footer: {
                    ForEach(errors) {
                        Text($0.detail)
                            .foregroundColor(.red)
                    }
                }
            }
            
            Button {
                async {
                    submitting = true
                    await submit(loginData, to: dataStore)
                    submitting = false
                }
            } label: {
                RoundedRectangle(cornerRadius: 12.0)
                    .frame(height: 60.0)
                    .overlay {
                        Group {
                            if submitting {
                                ProgressView()
                            } else {
                                Text("Login")
                            }
                        }
                        .foregroundColor(.white)
                    }
            }
            .padding()
            .disabled(submitting)
            
            Spacer()
        }
        .navigationBarTitle("Login")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func submit(_ data: LoginData,
                        to dataStore: DataStore) async {
        self.errors = []
        
        do {
            let res = try await API.login(for: data)

            if let errors = res.errors {
                print("Errors: \(errors)")
                self.errors = errors
                return
            }

            if let token = res.token {
                dataStore.auth = token
            }
        } catch {
            print("Error logging in: \(error)")
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Login(dataStore: DataStore.preview)
                .environmentObject(MangadexAPI())
        }
    }
}
