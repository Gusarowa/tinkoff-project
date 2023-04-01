//
//  MainTabBarCoordinator.swift
//  TinkoffProject
//
//  Created by Лена Гусарова on 01.04.2023.
//

import UIKit

class MainTabBarCoordinator {
    weak var tabBarController: UITabBarController?
    
    func start() -> UIViewController {
        let tabBarController = UITabBarController()
        self.tabBarController = tabBarController
        tabBarController.viewControllers = [
            care(),
        ]
        return tabBarController
    }
    
    private func care() -> UIViewController {
        let plantCareFlowCoordinator = PlantCareFlowCoordinator.shared
        let controller = plantCareFlowCoordinator.start()
        
        controller.tabBarItem = .init(
            title: "My Plants!",
            image: setCareTabBarImage(),
            selectedImage: setCareTabBarSelectedImage())
        
        return controller
    }
    
    private func setCareTabBarImage() -> UIImage {
        let image = UIImage(systemName: "leaf")
        guard let image else {return UIImage()}
        return image
    }
    
    private func setCareTabBarSelectedImage() -> UIImage {
        let image = UIImage(systemName: "leaf.fill")
        guard let image else {return UIImage()}
        return image
    }
}

