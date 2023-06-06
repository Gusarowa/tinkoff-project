//
//  Plant+Convenience.swift
//  WaterMyPlantsBackup
//
//  Created by Лена Гусарова on 01.06.2023.
//

import Foundation
import CoreData

extension Plant {
    @discardableResult convenience init(nickname: String,
                                        species: String,
                                        water_schedule: Date,
                                        frequency: [Int16],
                                        needsWatering: Bool = false,
                                        lastDateWatered: Date? = nil,
                                        scientificName: String = "",
                                        notes: String = "",
                                        mainTitle: String = "",
                                        mainMessage: String = "",
                                        mainAction: String = "",
                                        location: String = "",
                                        identifier: UUID = UUID(),
                                        plantIconIndex: Int16 = 8,
                                        plantColorIndex: Int16 = 0,
                                        actionIconIndex: Int16 = 0,
                                        actionColorIndex: Int16 = 1,
                                        isEnabled: Bool = true,
                                        wasWateredToday: Bool = false,
                                        lastDatesWatered: [Date] = [],
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.nickname = nickname
        self.species = species
        self.water_schedule = water_schedule
        self.frequency = frequency
        self.needsWatering = needsWatering
        self.lastDateWatered = lastDateWatered
        self.scientificName = scientificName
        self.notes = notes
        self.mainTitle = mainTitle
        self.mainMessage = mainMessage
        self.mainAction = mainAction
        self.location = location
        self.identifier = identifier
        self.plantIconIndex = plantIconIndex
        self.plantColorIndex = plantColorIndex
        self.actionIconIndex = actionIconIndex
        self.actionColorIndex = actionColorIndex
        self.isEnabled = isEnabled
        self.wasWateredToday = wasWateredToday
        self.lastDatesWatered = lastDatesWatered
    }
    
    func checkPlantsReminders() -> Reminder? {
        
        let remindersArray = self.reminders?.allObjects as! Array<Reminder>
        
        for reminder in remindersArray {
            if reminder.alarmDate! <= Date() {
                return reminder
            }
        }
        return nil
    }
}
