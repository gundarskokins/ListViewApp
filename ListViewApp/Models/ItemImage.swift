//
//  ItemImage.swift
//  ListViewApp
//
//  Created by Gundars Kokins on 07/09/2025.
//

public struct ItemImage: Codable, Sendable {
    public let id: String
    public let url: String
    public let width: Int?
    public let height: Int?
}
