//
//  ItemDetailView.swift
//  ListViewApp
//
//  Created by Gundars Kokins on 05/09/2025.
//

import SwiftUI

struct ItemDetailView: View {
    @StateObject var viewModel: ItemDetailsViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let imageUrl = viewModel.image?.url,
                   let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.thinMaterial)
                                    .frame(height: 280)
                                ProgressView()
                            }
                        case .success(let img):
                            img.resizable()
                                .scaledToFill()
                                .frame(maxHeight: 280)
                                .clipped()
                                .cornerRadius(16)
                                .shadow(radius: 8)
                        case .failure:
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.thinMaterial)
                                    .frame(height: 280)
                                Image(systemName: "photo")
                                    .font(.largeTitle)
                                    .foregroundStyle(.secondary)
                            }
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .padding(.horizontal)
                }

                VStack(alignment: .leading,
                       spacing: 16) {
                    Text(viewModel.name)
                        .font(.largeTitle.bold())
                        .padding(.bottom, 4)

                    if let temperament = viewModel.temperament {
                        Label(temperament, systemImage: "sparkles")
                            .font(.body)
                    }

                    if let life = viewModel.lifeSpan {
                        Label("Lifespan: \(life)", systemImage: "bolt.heart")
                            .font(.body)
                    }

                    if let breedGroup = viewModel.breedGroup {
                        Label("Breed group: \(breedGroup)", systemImage: "pawprint.fill")
                            .font(.body)
                    }

                    if let bredFor = viewModel.bredFor {
                        Label("Bred for: \(bredFor)", systemImage: "volleyball")
                            .font(.body)
                    }

                    if let weight = viewModel.weight {
                        Label("Weight: \(weight) kg", systemImage: "scalemass")
                            .font(.body)
                    }

                    if let height = viewModel.height {
                        Label("Height: \(height) cm", systemImage: "ruler")
                            .font(.body)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16))
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .task {
            await viewModel.loadImage()
        }
        .navigationTitle(viewModel.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let vm = ItemDetailsViewModel(item: MockItems.corgi,
                                  api: MockAPIService())
    
    ItemDetailView(viewModel: vm)
}

