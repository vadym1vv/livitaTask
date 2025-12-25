//
//  APIEndpoint.swift
//  ChatApp
//
//  Created by Vadym Vasylaki on 25.12.2025.
//

import Foundation
import Combine

enum APIEndpoint {
    case users
    case posts
    case postsByUser(userId: Int)
    case commentsForPost(postId: Int)
    
    var baseURL: String {
        return "https://jsonplaceholder.typicode.com"
    }
    
    var path: String {
        switch self {
        case .users: return "/users"
        case .posts, .postsByUser: return "/posts"
        case .commentsForPost: return "/comments"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .postsByUser(let userId):
            return [URLQueryItem(name: "userId", value: String(userId))]
        case .commentsForPost(let postId):
            return [URLQueryItem(name: "postId", value: String(postId))]
        default:
            return nil
        }
    }
    
    var url: URL? {
        var components = URLComponents(string: baseURL)
        components?.path = path
        components?.queryItems = queryItems
        return components?.url
    }
}

enum NetworkError: Error {
    case invalidURL
    case responseError
    case unknown
}

protocol NetworkService {
    func fetch<T: Decodable>(endpoint: APIEndpoint, type: T.Type) -> AnyPublisher<T, Error>
}

class NetworkManager: NetworkService {
    static let shared = NetworkManager()
    private var cancellables = Set<AnyCancellable>()
    
    func fetch<T: Decodable>(endpoint: APIEndpoint, type: T.Type) -> AnyPublisher<T, Error> {
        guard let url = endpoint.url else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      200...299 ~= httpResponse.statusCode else {
                    throw NetworkError.responseError
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
