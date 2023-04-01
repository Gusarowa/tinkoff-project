//
//  UserMO+CoreDataProperties.swift
//  TinkoffProject
//
//  Created by a.akhmadiev on 01.04.2023.
//
//

import Foundation
import CoreData


extension UserMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserMO> {
        return NSFetchRequest<UserMO>(entityName: "User")
    }

    @NSManaged public var password: String?
    @NSManaged public var lofin: String?
    @NSManaged public var plants: NSSet?

}

// MARK: Generated accessors for plants
extension UserMO {

    @objc(addPlantsObject:)
    @NSManaged public func addToPlants(_ value: PlantMO)

    @objc(removePlantsObject:)
    @NSManaged public func removeFromPlants(_ value: PlantMO)

    @objc(addPlants:)
    @NSManaged public func addToPlants(_ values: NSSet)

    @objc(removePlants:)
    @NSManaged public func removeFromPlants(_ values: NSSet)

}

extension UserMO : Identifiable {

}
