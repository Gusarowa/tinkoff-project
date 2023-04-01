//
//  PlantsViewControllerIO.swift
//  TinkoffProject
//
//  Created by a.akhmadiev on 01.04.2023.
//

import Foundation

protocol PlantsViewControllerOutput: AnyObject {

    var itemCount: Int { get }

    func getItem(for index: Int) -> Plant
    func viewDidLoad()
    func viewDidSelectRow(index: Int)
}

protocol PlantsViewControllerInput: AnyObject {
    func reloadData()
}
