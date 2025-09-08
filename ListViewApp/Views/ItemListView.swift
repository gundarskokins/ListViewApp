//
//  ItemListView.swift
//  ListViewApp
//
//  Created by Gundars Kokins on 05/09/2025.
//

import SwiftUI

struct ItemListView: View {
    @EnvironmentObject var viewModel: ItemListViewModel
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    Text("Loading...")
                } else if (viewModel.errorMessage != nil) {
                    VStack {
                        Text(viewModel.errorMessage!)
                            .foregroundColor(.red)
                        if !viewModel.items.isEmpty {
                            listContent
                        }
                    }
                } else {
                    listContent
                }
            }
            .task {
                if viewModel.items.isEmpty {
                    await viewModel.loadItems()
                }
            }
            .refreshable {
                await viewModel.refresh()
            }
            .navigationTitle("Dog Breeds")
            .searchable(text: $viewModel.searchText, prompt: "Search dog breeds...")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Picker("Filter", selection: $viewModel.selectedFilter) {
                            ForEach(BreedGroupFilter.allCases) { filter in
                                Text(filter.rawValue).tag(filter)
                            }
                        }
                    } label: {
                        Label("Filter", systemImage: "line.3.horizontal.decrease")
                    }
                }
            }
        }
        .tint(.black)
    }
    
    private var listContent: some View {
        List(viewModel.filteredItems) { item in
            NavigationLink(item.name) {
                ItemDetailView(viewModel: .init(item: item))
            }
        }
    }
}

#Preview {
    let vm = ItemListViewModel(
        apiService: {
            var service = MockAPIService()
            service.mockItems = [
                MockItems.corgi,
                MockItems.pekingese,
                MockItems.shibaInu
            ]
            return service
        }(),
        cacheService: MockCacheService()
    )
    
    ItemListView()
        .environmentObject(vm)
}
