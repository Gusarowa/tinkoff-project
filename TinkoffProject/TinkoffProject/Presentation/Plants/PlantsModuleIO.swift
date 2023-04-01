//
//  PlantsModuleIO.swift
//  TinkoffProject
//
//  Created by a.akhmadiev on 01.04.2023.
//

import Foundation

protocol PlantsModuleOutput: AnyObject {
    func showDetails(plant: Plant)
}
