//
//  APIServiceTests.swift
//  ListViewAppTests
//
//  Created by Gundars Kokins on 08/09/2025.
//

import Testing
import Foundation
@testable import ListViewApp

struct APIServiceTests {
    var mockSession: MockURLSession!
    var apiService: APIService!
    
    init() async throws {
        mockSession = MockURLSession()
        apiService = APIService(baseURL: URL(string: "https://api.thedogapi.com/v1/")!,
                                urlSession: mockSession)
    }
    
    @Test
    func fetchData_Success() async throws {
        let json = """
                [
                  {
                    "id": 1,
                    "name": "Corgi",
                    "bred_for": "Driving stock to market in northern Wales",
                    "breed_group": "Herding",
                    "temperament": "Friendly",
                    "life_span": "12 years",
                    "reference_image_id": "abc123"
                  }
                ]
                """
        mockSession.dataToReturn = json.data(using: .utf8)!
        
        let result = try await apiService.fetchData()
        
        #expect(result.count == 1)
        #expect(result.first?.name == "Corgi")
    }
    
    @Test
    func fetchImage_Success() async throws {
        let json = """
        {
            "id": "1",
            "url": "https://example.com/corgi.jpg"
        }
        """
        mockSession.dataToReturn = json.data(using: .utf8)!
        
        let image = try await apiService.fetchImage(for: "abc123")
        #expect(image.url == "https://example.com/corgi.jpg")
    }
    
    @Test
    func fetchData_DecodingError() async throws {
        mockSession.dataToReturn = "{ invalid json }".data(using: .utf8)!
        do {
            _ = try await apiService.fetchData()
            Issue.record("Expected decoding error")
        } catch let error as APIError {
            switch error {
            case .decodingError: break
            default: Issue.record("Expected decodingError, got \(error)")
            }
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }
}
