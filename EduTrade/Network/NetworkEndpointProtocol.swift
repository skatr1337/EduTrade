//
//  NetworkEndpointProtocol.swift
//  EduTrade
//
//  Created by Filip Biegaj on 28/11/2024.
//
import Foundation

protocol NetworkEndpointProtocol {
    var url: String { get }
    var headers: [String: String] { get }
    var query: [String: String] { get }
    var method: Method { get }
}

enum Method: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

extension NetworkEndpointProtocol {
    var method: Method {
        .get
    }
}

protocol URLSessionProtocol {
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol { }

extension NetworkEndpointProtocol {
    func fetch<T: Codable>(session: URLSessionProtocol = URLSession.shared) async throws -> T {
        let (data, reponse) = try await session.data(for: request, delegate: nil)
        guard
            let reponse = reponse as? HTTPURLResponse,
            reponse.statusCode == 200
        else {
            throw NetworkError.responseError
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(T.self, from: data)
    }

    private var request: URLRequest {
        var urlComponents = URLComponents(string: url)
        var queryItems = [URLQueryItem]()
        for (key, value) in query {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        urlComponents?.queryItems = queryItems
        var request = URLRequest(url: (urlComponents?.url)!)
        request.httpMethod = method.rawValue
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        return request
    }
}

enum NetworkError: Error {
    case responseError

    func localizeddDscription(error: Error) -> String {
        switch self {
        case .responseError:
            "Network response error"
        }
    }
}
