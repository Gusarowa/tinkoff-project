//
//  PlantMO+CoreDataProperties.swift
//  TinkoffProject
//
//  Created by a.akhmadiev on 01.04.2023.
//
//

import Foundation
import CoreData


extension PlantMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlantMO> {
        return NSFetchRequest<PlantMO>(entityName: "Plant")
    }

    @NSManaged public var name: String?

}

extension PlantMO : Identifiable {

}
