//
//  PlantsPresenter.swift
//  TinkoffProject
//
//  Created by Лена Гусарова on 01.04.2023.
//

import UIKit

class PlantsPresenter {
    var myPlantsService: MyPlantsService = MockMyPlantsService.shared
    var showDetails: (Plant) -> Void = { _ in }
    
    weak var view: PlantsViewController?
    
    func showPlants() {
        view?.list = myPlantsService.getAll()
    }
    
    func showDetails(for plant: Plant) {
        showDetails(plant)
    }
}
