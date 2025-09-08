//
//  Item.swift
//  ListViewApp
//
//  Created by Gundars Kokins on 02/09/2025.
//

public struct Item: Codable, Identifiable, Sendable {
    public let id: Int
    public let name: String
    public let temperament: String?
    public let lifeSpan: String?
    public let bredFor: String?
    public let breedGroup: String?
    public let weight: MeasurementValue?
    public let height: MeasurementValue?
    public let referenceImageId: String?

    enum CodingKeys: String, CodingKey {
        case id, name, temperament, weight, height
        case lifeSpan = "life_span"
        case bredFor = "bred_for"
        case breedGroup = "breed_group"
        case referenceImageId = "reference_image_id"
    }

    public struct MeasurementValue: Codable, Sendable {
        public let imperial: String?
        public let metric: String?
    }
}
