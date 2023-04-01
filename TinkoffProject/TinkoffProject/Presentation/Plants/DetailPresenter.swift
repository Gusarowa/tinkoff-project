//
//  Detail.swift
//  TinkoffProject
//
//  Created by Лена Гусарова on 01.04.2023.
//

import UIKit

class DetailPresenter {
    weak var view: DetailViewController?
    
    func showPlant(plant: Plant) {
        view?.set(name: plant.name)
    }
}
