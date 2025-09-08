//
//  ItemDetailsViewModelTests.swift
//  ListViewApp
//
//  Created by Gundars Kokins on 08/09/2025.
//

import Testing
import Foundation
@testable import ListViewApp

@MainActor
struct ItemDetailsViewModelTests {
    var api: MockAPIService!
    var item: Item!
    
    init() {
        api = MockAPIService()
        item = MockItems.corgi
    }
    
    @Test
    func initializesWithCorrectItemData() {
        let vm = ItemDetailsViewModel(item: item, api: api)
        
        #expect(vm.name == item.name)
        #expect(vm.temperament == item.temperament)
        #expect(vm.lifeSpan == item.lifeSpan)
        #expect(vm.bredFor == item.bredFor)
        #expect(vm.breedGroup == item.breedGroup)
        #expect(vm.weight == item.weight?.metric)
        #expect(vm.height == item.height?.metric)
        #expect(vm.referenceImageId == item.referenceImageId)
    }
    
    @Test
    mutating func loadImage_successUpdatesImage() async throws {
        let expectedImage = ItemImage(
            id: "abc123",
            url: "https://example.com/corgi.jpg",
            width: 800,
            height: 600
        )
        api.mockImage = expectedImage
        let vm = ItemDetailsViewModel(item: item, api: api)
        
        await vm.loadImage()
        
        #expect(vm.image?.url == expectedImage.url)
        #expect(vm.isLoading == false)
        #expect(vm.error == nil)
    }
    
    @Test
    func loadImage_withNoReferenceIdDoesNothing() async {
        let noImageItem = Item(id: 1,
                               name: "Pembroke Welsh Corgi",
                               temperament: "Frendly",
                               lifeSpan: "12 years",
                               bredFor: "Driving stock to market in northern Wales",
                               breedGroup: "Herding",
                               weight: Item.MeasurementValue.init(imperial: "25 - 30",
                                                                  metric: "11 - 14"),
                               height: Item.MeasurementValue.init(imperial: "10 - 12",
                                                                  metric: "25 - 30"),
                               referenceImageId: nil)
        
        let vm = ItemDetailsViewModel(item: noImageItem, api: api)
        
        await vm.loadImage()
        
        #expect(vm.image == nil)
        #expect(vm.error == nil)
        #expect(vm.isLoading == false)
    }
    
    @Test
    mutating func loadImage_failureSetsError() async {
        api.shouldThrow = APIError.networkError(NSError(domain: "test", code: 1))
        let vm = ItemDetailsViewModel(item: item, api: api)
        
        await vm.loadImage()
        
        #expect(vm.image == nil)
        #expect(vm.error?.contains("Network error") == true)
        #expect(vm.isLoading == false)
    }
}
