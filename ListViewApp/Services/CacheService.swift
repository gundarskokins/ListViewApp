//
//  CacheService.swift
//  ListViewApp
//
//  Created by Gundars Kokins on 02/09/2025.
//

import Foundation

public protocol CacheServiceProtocol {
    func save(_ items: [Item]) async throws
    func loadItems() async throws -> [Item]
    func clear() async throws
}

public enum CacheError: Error, LocalizedError {
    case cachesDirectoryUnavailable
    case saveFailed(Error)
    case loadFailed(Error)
    case clearFailed(Error)
    
    public var errorDescription: String? {
        switch self {
        case .cachesDirectoryUnavailable:
            return "Could not access caches directory."
        case .saveFailed(let err):
            return "Failed to save items: \(err.localizedDescription)"
        case .loadFailed(let err):
            return "Failed to load items: \(err.localizedDescription)"
        case .clearFailed(let err):
            return "Failed to clear cache: \(err.localizedDescription)"
        }
    }
}

public actor CacheService: CacheServiceProtocol {
    private let cacheFile: String
    private let fileManager: FileManager
    private let cacheDirectory: URL
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    init(cacheFile: String = "items.json",
         fileManager: FileManager = .default,
         cacheDirectory: URL? = nil,
         encoder: JSONEncoder = JSONEncoder(),
         decoder: JSONDecoder = JSONDecoder())
    throws {
        self.cacheFile = cacheFile
        self.fileManager = fileManager
        self.encoder = encoder
        self.decoder = decoder
        
        if let directory = cacheDirectory {
            self.cacheDirectory = directory
        } else if let directory = fileManager.urls(for: .cachesDirectory,
                                                   in: .userDomainMask).first {
            self.cacheDirectory = directory
        } else {
            throw CacheError.cachesDirectoryUnavailable
        }
    }
    
    public func save(_ items: [Item]) async throws {
        do {
            let data = try encoder.encode(items)
            let url = getFileURL()
            try data.write(to: url, options: [.atomic])
        } catch {
            throw CacheError.saveFailed(error)
        }
    }
    
    public func loadItems() async throws -> [Item] {
        do {
            let url = getFileURL()
            guard fileManager.fileExists(atPath: url.path) else { return [] }
            let data = try Data(contentsOf: url)
            return try decoder.decode([Item].self, from: data)
        } catch {
            throw CacheError.loadFailed(error)
        }
    }
    
    public func clear() async throws {
        do {
            let url = getFileURL()
            if fileManager.fileExists(atPath: url.path) {
                try fileManager.removeItem(at: url)
            }
        } catch {
            throw CacheError.clearFailed(error)
        }
    }
    
    func getFileURL() -> URL {
        return cacheDirectory.appendingPathComponent(cacheFile)
    }
}
