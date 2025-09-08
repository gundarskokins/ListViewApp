//
//  MockCacheService.swift
//  ListViewApp
//
//  Created by Gundars Kokins on 05/09/2025.
//

import Foundation

struct MockCacheService: CacheServiceProtocol {
    var store: [Item] = []
    
    func save(_ items: [Item]) async throws {}
    
    func loadItems() async throws -> [Item] {
        return store
    }
    
    func clear() async throws {}
}
