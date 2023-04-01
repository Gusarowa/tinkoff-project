//
//  MockMyPlantsService.swift
//  TinkoffProject
//
//  Created by Лена Гусарова on 01.04.2023.
//

import Foundation

class MockMyPlantsService: MyPlantsService {
    static let shared: MockMyPlantsService = MockMyPlantsService()

    var plantsList: [Plant] = [
        Plant(name: "Rose" ),
        Plant(name: "Aloe"),
        Plant(name: "Violet"),
        Plant(name: "Cactus"),
        Plant(name: "Anthurium"),
        Plant(name: "Pigmyweeds"),
        Plant(name: "Orchid"),
        Plant(name: "Ficus"),
    ]
    
    func getAll() -> [Plant] {
        return plantsList
    }
    
    func add(plant: Plant) {
        plantsList.append(plant)
        
    }
}
