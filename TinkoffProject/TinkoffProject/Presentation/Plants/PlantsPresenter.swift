//
//  PlantsPresenter.swift
//  TinkoffProject
//
//  Created by Лена Гусарова on 01.04.2023.
//

import UIKit

class PlantsPresenter {
    var myPlantsService: MyPlantsService = MockMyPlantsService.shared
    weak var moduleOutput: PlantsModuleOutput?

    private var list: [Plant] = []
    
    weak var view: PlantsViewControllerInput?
}

extension PlantsPresenter: PlantsViewControllerOutput {
    var itemCount: Int {
        list.count
    }

    func getItem(for index: Int) -> Plant {
        list[index]
    }

    func viewDidLoad() {
        list = myPlantsService.getAll()
        view?.reloadData()
    }

    func viewDidSelectRow(index: Int) {
        let plant = list[index]
        moduleOutput?.showDetails(plant: plant)
    }
}
