//
//  PlantCareFlowCoordinator.swift
//  TinkoffProject
//
//  Created by Лена Гусарова on 01.04.2023.
//

import UIKit

class PlantCareFlowCoordinator {
    static let shared: PlantCareFlowCoordinator = PlantCareFlowCoordinator()
   
    private weak var navController: UINavigationController?

    func start() -> UIViewController {
        let plantsViewController = PlantsViewController()
        let presenter = PlantsPresenter()
        presenter.moduleOutput = self
        plantsViewController.presenter = presenter
        presenter.view = plantsViewController
        
        let navController = UINavigationController(rootViewController: plantsViewController)
        self.navController = navController
        return navController
    }
}

extension PlantCareFlowCoordinator: PlantsModuleOutput {
    func showDetails(plant: Plant) {
        let detailViewConroller = DetailViewController()
        let detailPresenter = DetailPresenter()
        detailPresenter.view = detailViewConroller
        detailPresenter.showPlant(plant: plant)
        navController?.show(detailViewConroller, sender: .none)
    }
}


