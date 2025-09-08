//
//  ItemViewModelTests.swift
//  ListViewApp
//
//  Created by Gundars Kokins on 08/09/2025.
//
import Testing
import Foundation
@testable import ListViewApp

@MainActor
struct ItemViewModelTests {
    
    @Test
    func loadItems_successFromAPI() async throws {
        let api = MockAPIService(mockItems: [MockItems.corgi, MockItems.shibaInu])
        let cache = MockCacheService()
        let vm = ItemListViewModel(apiService: api, cacheService: cache)
        
        await vm.loadItems()
        
        #expect(vm.items.count == 2)
        #expect(vm.items.first?.name == "Pembroke Welsh Corgi")
        #expect(vm.errorMessage == nil)
        #expect(vm.isLoading == false)
    }
    
    @Test
    func loadItems_fallbackToCacheWhenAPIFails() async throws {
        var api = MockAPIService()
        api.shouldThrow = APIError.networkError(NSError(domain: "test", code: 1))
        
        var cache = MockCacheService()
        cache.store = [MockItems.corgi]
        
        let vm = ItemListViewModel(apiService: api, cacheService: cache)
        
        await vm.loadItems()
        
        #expect(vm.items.count == 1)
        #expect(vm.items.first?.name == "Pembroke Welsh Corgi")
        #expect(vm.errorMessage == nil)
    }
    
    @Test
    func loadItems_errorWhenNoData() async throws {
        var api = MockAPIService()
        api.shouldThrow = APIError.networkError(NSError(domain: "test", code: 1))
        let cache = MockCacheService()
        let vm = ItemListViewModel(apiService: api, cacheService: cache)
        
        await vm.loadItems()
        
        #expect(vm.items.isEmpty)
        #expect(vm.errorMessage == "No data available")
    }
    
    @Test
    func refresh_updatesItemsAndClearsError() async throws {
        let api = MockAPIService(mockItems: [MockItems.pekingese])
        let cache = MockCacheService()
        let vm = ItemListViewModel(apiService: api, cacheService: cache)
        
        vm.items = [MockItems.corgi]
        vm.errorMessage = "Old error"
        
        await vm.refresh()
        
        #expect(vm.items.count == 1)
        #expect(vm.items.first?.name == "Pekingese")
        #expect(vm.errorMessage == nil)
    }
    
    @Test
    func refresh_doesNotDuplicateCalls() async throws {
        let api = MockAPIService(mockItems: [MockItems.pekingese])
        let cache = MockCacheService()
        let vm = ItemListViewModel(apiService: api, cacheService: cache)
        
        vm.isRefreshing = true
        
        await vm.refresh()
        
        #expect(vm.items.isEmpty)
    }
    
    @Test
    func filteredItems_searchWorks() async throws {
        let api = MockAPIService(mockItems: [MockItems.corgi, MockItems.shibaInu])
        let cache = MockCacheService()
        let vm = ItemListViewModel(apiService: api, cacheService: cache)
        
        await vm.loadItems()
        
        vm.searchText = "corgi"
        #expect(vm.filteredItems.count == 1)
        #expect(vm.filteredItems.first?.name == "Pembroke Welsh Corgi")
        
        vm.searchText = "shiba"
        #expect(vm.filteredItems.count == 1)
        #expect(vm.filteredItems.first?.name == "Shiba Inu")
        
        vm.searchText = "xyz"
        #expect(vm.filteredItems.isEmpty)
    }
    
    @Test
    func filterItems_byBreedGroup() async throws {
        let api = MockAPIService(mockItems: [
            Item(
                id: 1,
                name: "Corgi",
                temperament: nil,
                lifeSpan: nil,
                bredFor: nil,
                breedGroup: "Herding",
                weight: nil,
                height: nil,
                referenceImageId: nil
            ),
            Item(
                id: 2,
                name: "Pekingese",
                temperament: nil,
                lifeSpan: nil,
                bredFor: nil,
                breedGroup: "Toy",
                weight: nil,
                height: nil,
                referenceImageId: nil
            ),
            Item(
                id: 3,
                name: "Unknown Dog",
                temperament: nil,
                lifeSpan: nil,
                bredFor: nil,
                breedGroup: nil,
                weight: nil,
                height: nil,
                referenceImageId: nil
            )
        ])
        
        let cache = MockCacheService()
        let vm = ItemListViewModel(apiService: api, cacheService: cache)
        
        await vm.loadItems()
        
        vm.selectedFilter = .herding
        let herdingFiltered = vm.filteredItems
        
        vm.selectedFilter = .toy
        let toyFiltered = vm.filteredItems
        
        vm.selectedFilter = .other
        let otherFiltered = vm.filteredItems
        
        #expect(herdingFiltered.count == 1)
        #expect(herdingFiltered.first?.name == "Corgi")
        
        #expect(toyFiltered.count == 1)
        #expect(toyFiltered.first?.name == "Pekingese")
        
        #expect(otherFiltered.count == 1)
        #expect(otherFiltered.first?.name == "Unknown Dog")
    }
}
