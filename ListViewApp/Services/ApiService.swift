//
//  ApiService.swift
//  ListViewApp
//
//  Created by Gundars Kokins on 02/09/2025.
//
import Foundation

protocol APIServiceProtocol {
    func fetchData() async throws -> [Item]
    func fetchImage(for referenceId: String) async throws -> ItemImage
}

protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

enum APIError: Error, LocalizedError {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The API URL is invalid."
        case .networkError(let err):
            return "Network error: \(err.localizedDescription)"
        case .decodingError(let err):
            return "Decoding error: \(err.localizedDescription)"
        }
    }
}

final class APIService: APIServiceProtocol {
    private let baseURL: URL
    private let urlSession: URLSessionProtocol
    
    init(baseURL: URL = URL(string: "https://api.thedogapi.com/v1/")!,
         urlSession: URLSessionProtocol = URLSession.shared) {
        self.baseURL = baseURL
        self.urlSession = urlSession
    }
    
    func fetchData() async throws -> [Item] {
        guard let url = URL(string: "breeds", relativeTo: baseURL) else {
            throw APIError.invalidURL
        }
        do {
            let (data, _) = try await urlSession.data(from: url)
            return try JSONDecoder().decode([Item].self, from: data)
        } catch let error as DecodingError {
            throw APIError.decodingError(error)
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    func fetchImage(for referenceId: String) async throws -> ItemImage {
        guard let url = URL(string: "images/\(referenceId)", relativeTo: baseURL) else {
            throw APIError.invalidURL
        }
        
        do {
            let (data, _) = try await urlSession.data(from: url)
            return try JSONDecoder().decode(ItemImage.self, from: data)
        } catch let error as DecodingError {
            throw APIError.decodingError(error)
        } catch {
            throw APIError.networkError(error)
        }
    }
}
