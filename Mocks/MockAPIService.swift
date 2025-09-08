//
//  MockAPIService.swift
//  ListViewApp
//
//  Created by Gundars Kokins on 05/09/2025.
//

import Foundation

struct MockAPIService: APIServiceProtocol {
    var mockItems: [Item] = []
    var mockImage: ItemImage?
    var shouldThrow: Error?
    
    func fetchData() async throws -> [Item] {
        if let error = shouldThrow {
            throw error
        }
        return mockItems
    }
    
    func fetchImage(for referenceId: String) async throws -> ItemImage {
        if let error = shouldThrow {
            throw error
        }

        return mockImage ?? ItemImage(
            id: referenceId,
            url: "https://example.com/\(referenceId).jpg",
            width: 800,
            height: 600
        )
    }
}
