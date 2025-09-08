//
//  MockItems.swift
//  ListViewApp
//
//  Created by Gundars Kokins on 07/09/2025.
//

enum MockItems {
    static var corgi: Item {
        Item(id: 1,
             name: "Pembroke Welsh Corgi",
             temperament: "Frendly",
             lifeSpan: "12 years",
             bredFor: "Driving stock to market in northern Wales",
             breedGroup: "Herding",
             weight: Item.MeasurementValue.init(imperial: "25 - 30",
                                                metric: "11 - 14"),
             height: Item.MeasurementValue.init(imperial: "10 - 12",
                                                metric: "25 - 30"),
             referenceImageId: "rJ6iQeqEm")
    }
    
    static var pekingese: Item {
        Item(id: 2,
             name: "Pekingese",
             temperament: "Opinionated, Good-natured, Stubborn, Affectionate, Aggressive, Intelligent",
             lifeSpan: "14 - 18 years",
             bredFor: "Lapdog",
             breedGroup: "Toy",
             weight: Item.MeasurementValue.init(imperial: "14",
                                                metric: "6"),
             height: Item.MeasurementValue.init(imperial: "6 - 9",
                                                metric: "15 - 23"),
             referenceImageId: "ByIiml9Nm")
    }
    
    static var shibaInu: Item {
        Item(id: 3,
             name: "Shiba Inu",
             temperament: "Charming, Fearless, Keen, Alert, Confident, Faithful",
             lifeSpan: "12 - 16 years",
             bredFor: "Hunting in the mountains of Japan, Alert Watchdog",
             breedGroup: "Non-Sporting",
             weight: Item.MeasurementValue.init(imperial: "17 - 23",
                                                metric: "8 - 10"),
             height: Item.MeasurementValue.init(imperial: "13.5 - 16.5",
                                                metric: "34 - 42"),
             referenceImageId: "Zn3IjPX3f")
    }
}
