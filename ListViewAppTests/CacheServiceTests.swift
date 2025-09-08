//
//  CacheServiceTests.swift
//  ListViewAppTests
//
//  Created by Gundars Kokins on 05/09/2025.
//

import Testing
import Foundation
@testable import ListViewApp

struct CacheServiceTests {
    var service: CacheService!
    
    init() async throws {
        let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
        service = try CacheService(cacheDirectory: tempDir)
    }
    
    @Test
    func saveAndLoadItems() async throws {
        let items = [
            MockItems.corgi,
            MockItems.shibaInu
        ]
        
        try await service.save(items)
        let loaded = try await service.loadItems()
        
        #expect(loaded.count == 2)
        #expect(loaded.first?.name == "Pembroke Welsh Corgi")
    }
    
    @Test
    func loadItems_EmptyWhenNoFileExists() async throws {
        let loaded = try await service.loadItems()
        #expect(loaded.isEmpty)
    }
    
    @Test
    func clear_RemovesFile() async throws {
        let items = [MockItems.corgi]
        try await service.save(items)
        
        var loaded = try await service.loadItems()
        #expect(!loaded.isEmpty)
        
        try await service.clear()
        loaded = try await service.loadItems()
        #expect(loaded.isEmpty)
    }
    
    @Test
    func loadItems_ThrowsWhenCorruptedFile() async {
        // Write invalid JSON to file
        let url = await service.getFileURL()
        try! "not-json".data(using: .utf8)!.write(to: url)
        
        do {
            _ = try await service.loadItems()
            Issue.record("Expected loadFailed error")
        } catch let error as CacheError {
            switch error {
            case .loadFailed: break
            default: Issue.record("Wrong CacheError: \(error)")
            }
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }
}
