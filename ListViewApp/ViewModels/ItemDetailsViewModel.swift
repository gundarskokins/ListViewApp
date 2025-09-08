//
//  ItemDetailsViewModel.swift
//  ListViewApp
//
//  Created by Gundars Kokins on 07/09/2025.
//

import Foundation

@MainActor
public final class ItemDetailsViewModel: ObservableObject {
    @Published var image: ItemImage?
    @Published var isLoading: Bool = false
    @Published var error: String?
    
    private let api: APIServiceProtocol
    private let item: Item
    
    init(item: Item, api: APIServiceProtocol = APIService()) {
        self.item = item
        self.api = api
    }
    
    var name: String { item.name }
    var temperament: String? { item.temperament }
    var lifeSpan: String? { item.lifeSpan }
    var bredFor: String? { item.bredFor }
    var breedGroup: String? { item.breedGroup }
    var weight: String? { item.weight?.metric }
    var height: String? { item.height?.metric }
    var referenceImageId: String? { item.referenceImageId }
    
    func loadImage() async {
        guard let refId = item.referenceImageId else { return }
        isLoading = true
        defer { isLoading = false }
        
        do {
            image = try await api.fetchImage(for: refId)
        } catch {
            self.error = error.localizedDescription
        }
    }
}
