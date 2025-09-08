//
//  ItemViewModel.swift
//  ListViewApp
//
//  Created by Gundars Kokins on 02/09/2025.
//

import Foundation

@MainActor
final class ItemListViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    @Published var selectedFilter: BreedGroupFilter = .all
    var isRefreshing: Bool = false
    
    private let apiService: APIServiceProtocol
    private let cacheService: CacheServiceProtocol
    
    init(apiService: APIServiceProtocol, cacheService: CacheServiceProtocol) {
        self.apiService = apiService
        self.cacheService = cacheService
    }
    
    var filteredItems: [Item] {
        var result = items
        
        if !searchText.isEmpty {
            result = result.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        switch selectedFilter {
        case .all:
            break
        case .other:
            result = result.filter { $0.breedGroup == nil || $0.breedGroup?.isEmpty == true }
        default:
            result = result.filter { $0.breedGroup == selectedFilter.rawValue }
        }
        
        return result
    }
    
    func loadItems() async {
        isLoading = true
        defer { isLoading = false }
        errorMessage = nil
        
        if items.isEmpty,
           let cached = try? await cacheService.loadItems(),
           !cached.isEmpty {
            items = cached
        }
        
        do {
            let fetched = try await apiService.fetchData()
            if Task.isCancelled { return }
            items = fetched
            try await cacheService.save(fetched)
        } catch {
            do {
                let cached = try await cacheService.loadItems()
                items = cached
                if !cached.isEmpty { return }
                errorMessage = "No data available"
            } catch {
                errorMessage = "Failed to load data: \(error.localizedDescription)"
            }
        }
    }
    
    func refresh() async {
        if isRefreshing { return }
        isRefreshing = true
        defer { isRefreshing = false }
        errorMessage = nil
        
        do {
            let fetched = try await apiService.fetchData()
            if Task.isCancelled { return }
            items = fetched
            try await cacheService.save(fetched)
        } catch {
            errorMessage = "Refresh failed"
        }
    }
}

enum BreedGroupFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case hound = "Hound"
    case working = "Working"
    case herding = "Herding"
    case toy = "Toy"
    case terrier = "Terrier"
    case sporting = "Sporting"
    case nonSporting = "Non-Sporting"
    case mixed = "Mixed"
    case other = "Other"
    
    var id: String { rawValue }
}
