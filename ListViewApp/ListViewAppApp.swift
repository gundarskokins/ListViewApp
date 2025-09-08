//
//  ListViewAppApp.swift
//  ListViewApp
//
//  Created by Gundars Kokins on 02/09/2025.
//

import SwiftUI

@main
struct ListViewAppApp: App {
    @StateObject var viewModel: ItemListViewModel = .init(apiService: APIService(),
                                                          cacheService: try! CacheService())
    var body: some Scene {
        WindowGroup {
            ItemListView()
                .environmentObject(viewModel)
        }
    }
}
