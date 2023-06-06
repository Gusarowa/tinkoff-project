//
//  String+Extension.swift
//  Remindew
//
//  Created by Лена Гусарова on 01.06.2023.

import Foundation
import UIKit

extension String {
    
    // MARK: - User Default Keys
    
   
    static let lastTempToken = "lastTempToken"
    
  
    static let lastDateTokenGrabbed = "lastDateTokenGrabbed"
    
    
    static let sortPlantsBySpecies = "sortPlantsBySpecies"
    
 
    static let resultFillsSpeciesTextfield = "resultFillsSpeciesTextfield"
    
 
    static let darkThemeOn = "darkThemeOn"
    
   
    static let usePlantImages = "usePlantImages"
    
   
    static let usePlantColorOnLabel = "usePlantColorOnLabel"
    
   
    static let hideSilencedIcon = "hideSilencedIcon"
    
   
    static let useBiggerImages = "useBiggerImages"
    
    
    static let alreadyAskedForCameraUsage = "alreadyAskedForCameraUsage"
    
  
    static let mainNavThemeColor = "mainNavThemeColor"
    
    // MARK: - Helpers
    
    static let sunday = NSLocalizedString("Sun", comment: "Sunday abbreviated")
    static let monday = NSLocalizedString("Mon", comment: "Monday abbreviated")
    static let tuesday = NSLocalizedString("Tue", comment: "Tuesday abbreviated")
    static let wednesday = NSLocalizedString("Wed", comment: "Wednesday abbreviated")
    static let thursday = NSLocalizedString("Thu", comment: "Thursday abbreviated")
    static let friday = NSLocalizedString("Fri", comment: "Friday abbreviated")
    static let saturday = NSLocalizedString("Sat", comment: "Saturday abbreviated")
    
   
    static let dayInitials = [sunday, monday, tuesday, wednesday, thursday, friday, saturday]
    
    
    static let randomNicknames: [String] = ["Twiggy", "Leaf Erikson", "Alvina", "Thornhill", "Plant 43",
                                            "Leshy", "Greenman", "Bud Dwyer", "Treebeard",
                                            "Cilan", "Milo", "Erika", "Gardenia", "Ramos"]
        
    
    static func returnRandomNickname() -> String {
        
        let randomInt = Int.random(in: 0..<String.randomNicknames.count)
        return String.randomNicknames[randomInt]
    }
    
    // MARK: - Localized Strings
    
   
    static let reminderLimitTitleLocalizedString = NSLocalizedString("Reached Reminders Limit", comment: "reached reminder limit title")
    
  
    static let reminderLimitMessageLocalizedString = NSLocalizedString("You've reached your limit of reminders for this plant", comment: "reached reminder limit message")
    
  
    static let plantLimitTitleLocalizedString = NSLocalizedString("Reached Plant Limit", comment: "reached plant limit title")
    
   
    static let plantLimitMessageLocalizedString = NSLocalizedString("Sorry, you've reached the limit of how many plants you can make.", comment: "reached plant limit message")
    
  
    static let appearanceSectionLocalizedDescription = NSLocalizedString("Light/Dark theme are independent of phone settings. Main screen displays plant icon instead of image by default.", comment: "description for appearance section")
    
   
    static let mainLabelSectionLocalizedDescription = NSLocalizedString("Top label displays nickname by default. Label color is dark green instead of selected color by default.", comment: "description for main label section")
    
   
    static let searchesSectionLocalizedDescription = NSLocalizedString("Clicking on a search result will replace plant type name with common name of selected result. Search by tapping \"search\" on keyboard when entering plant's type", comment: "description for searches section")
    
   
    static let trefleSectionLocalizedDescription = NSLocalizedString("Trefle aims to increase awareness and understanding of living plants by gathering, generating and sharing knowledge in an open, freely accessible and trusted digital resource.", comment: "description for trefle section")
    
    
    static let defaultImageSectionLocalizedDescription = NSLocalizedString(NSLocalizedString("Default plant photo provided by Richard Alfonzo.", comment: "photo source description"), comment: "description for default image section")
    
    
    static let takePhotoLocalizedString = NSLocalizedString("  Take Photo", comment: "take photo button title")
    
  
    static let choosePhotoLocalizedString = NSLocalizedString("  Choose Photo", comment: "choose photo button title")
    
   
    static let navigationBarSettingLocalizedString = NSLocalizedString("Color for navigation bar and main screen title",
                                                                        comment: "section description for nav bar color")
    
  
    static let savePhotoLocalizedString = NSLocalizedString("  Save Photo", comment: "save photo button title")
    

    static let nicknameLocalizedString = NSLocalizedString("Nickname", comment: "plant nickname")
    
    static let typeOfPlantLocalizedString = NSLocalizedString("Type of plant", comment: "plant's type")
    
  
    static let waterLocalizedString = NSLocalizedString("Water", comment: "water, default main action")
    
  
    static let waterNounLocalizedString = NSLocalizedString("water", comment: "water, as a noun")
    
 
    static let plantLocalizedString = NSLocalizedString("Plant", comment: "plant")
    
   
    static let defaultPlantNameLocalizedString = NSLocalizedString("One of your plants", comment: "default plant name when none is given")
    
  
    static func defaultTitleString() -> String {
        return NSLocalizedString("One of your plants needs attention.", comment: "Message for notification")
    }
    
  
    static func defaultMessageString(name: String, action: String) -> String {
        return "\(name.capitalized)" + NSLocalizedString(" needs ", comment: "") + "\(action.lowercased())."
    }
    
   
    static func returnWaterAllPlantsLocalizedString(count: Int) -> String {
        
        let water = NSLocalizedString("Water", comment: "water")
        let plants = NSLocalizedString("Plants", comment: "plants")
        let plant = NSLocalizedString("Plant", comment: "plant")
        
        return count == 1 ? water + " \(count) " + plant : water + " \(count) " + plants
    }
}
