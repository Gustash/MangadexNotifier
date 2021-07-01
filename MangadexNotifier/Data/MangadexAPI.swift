//
//  MangadexAPI.swift
//  MangadexNotifier
//
//  Created by Gustavo Parreira on 15/06/2021.
//

import Foundation

let BASE_URL = "https://api.mangadex.org"

enum MangadexRequestError: Error {
    case unauthenticated
    case badResponse
    case badURL(_ url: String)
    case badURLQuery(_ url: String, queryItems: [URLQueryItem])
}

struct MangadexURLRequest {
    var request: URLRequest
    var auth: AuthToken?
}

@MainActor protocol RefreshTokenDelegate {
    func did(refresh token: AuthToken)
}

class MangadexAPI: ObservableObject {
    var refreshTokenDelegate: RefreshTokenDelegate?
    
    private let urlSession = URLSession(configuration: .default)
    
    private func apiUrl(path: String, queryItems: [URLQueryItem]? = nil) throws -> URL {
        let urlStr = "\(BASE_URL)/\(path)"
        
        guard let queryItems = queryItems else {
            guard let url = URL(string: urlStr) else {
                throw MangadexRequestError.badURL(urlStr)
            }
            
            return url
        }

        
        guard var urlComponents = URLComponents(string: urlStr) else {
            throw MangadexRequestError.badURL(urlStr)
        }
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            throw MangadexRequestError.badURLQuery(urlStr, queryItems: queryItems)
        }
        
        return url
    }
    
    private func generateAuthRequest(auth: AuthToken?, url: URL) throws -> MangadexURLRequest {
        guard let auth = auth else {
            throw MangadexRequestError.unauthenticated
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(auth.session)", forHTTPHeaderField: "Authorization")
        
        return MangadexURLRequest(request: request, auth: auth)
    }
    
    private func apiPost<T: Decodable, Body: Encodable>(_ request: MangadexURLRequest, data: Body) async throws -> T {
        let data = try JSONEncoder().encode(data)
        
        var postRequest = request.request
        postRequest.httpMethod = "POST"
        postRequest.httpBody = data
        
        return try await apiRequest(MangadexURLRequest(request: postRequest, auth: request.auth))
    }
    
    private func apiRequest<T: Decodable>(_ request: MangadexURLRequest) async throws -> T {
        let (data, response) = try await urlSession.data(for: request.request)
        
        guard let response = response as? HTTPURLResponse else {
            throw MangadexRequestError.badResponse
        }
        
        // Unathenticated
        guard response.statusCode != 401 else {
            guard let refreshToken = request.auth?.refresh else {
                throw MangadexRequestError.unauthenticated
            }
            let response: AuthResponse = try await refresh(RefreshData(token: refreshToken))
            
            guard let newToken = response.token else {
                throw MangadexRequestError.unauthenticated
            }
            await refreshTokenDelegate?.did(refresh: newToken)
            
            var newRequest = request.request
            newRequest.setValue("Bearer \(newToken.session)", forHTTPHeaderField: "Authorization")
            return try await apiRequest(MangadexURLRequest(request: newRequest, auth: newToken))
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return try decoder.decode(T.self, from: data)
    }
    
    func userDetails(auth: AuthToken?) async throws -> User {
        let req = try generateAuthRequest(auth: auth, url: try apiUrl(path: "user/me"))
        let res: UserResponse = try await apiRequest(req)
        return res.data
    }
    
    func refresh(_ data: RefreshData) async throws -> AuthResponse {
        let request = MangadexURLRequest(request: URLRequest(url: try apiUrl(path: "auth/refresh")))
        return try await apiPost(request, data: data)
    }
    
    func login(for data: LoginData) async throws -> AuthResponse {
        let request = MangadexURLRequest(request: URLRequest(url: try apiUrl(path: "auth/login")))
        return try await apiPost(request, data: data)
    }
    
    func mangaFeed(auth: AuthToken?, limit: Int = 30, offset: Int = 0) async throws -> FeedResponse {
        let url = try apiUrl(path: "user/follows/manga/feed",
                             queryItems: [URLQueryItem(name: "limit", value: String(limit)),
                                          URLQueryItem(name: "offset", value: String(offset)),
                                          URLQueryItem(name: "order[publishAt]", value: "desc")])
        
        let req = try generateAuthRequest(auth: auth, url: url)
        return try await apiRequest(req)
    }
    
    func mangas(ids: [String], auth: AuthToken?) async throws -> MangaList {
        let url = try apiUrl(path: "manga",
                             queryItems: ids.map { URLQueryItem(name: "ids[]", value: $0) })
        
        let req = try generateAuthRequest(auth: auth, url: url)
        return try await apiRequest(req)
    }
    
    func covers(ids: [String], auth: AuthToken?) async throws -> CoverArtList {
        let url = try apiUrl(path: "cover",
                             queryItems: ids.map { URLQueryItem(name: "ids[]", value: $0) })
        
        let req = try generateAuthRequest(auth: auth, url: url)
        return try await apiRequest(req)
    }
}
