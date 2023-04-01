//
//  MyPlantsService.swift
//  TinkoffProject
//
//  Created by Лена Гусарова on 01.04.2023.
//

import Foundation

protocol MyPlantsService {
    func getAll() -> [Plant]
    func add(plant: Plant)
}
