//
//  UIColor+Extension.swift
//  Remindew
//
//  Created by Лена Гусарова on 01.06.2023.
//

import UIKit
import Foundation

extension UIColor {
    
    static let creamPink: UIColor = UIColor(red: 253.0 / 255.0, green: 168.0 / 255.0, blue: 149.0 / 255.0, alpha: 1.0)
    static let mintGreen: UIColor = UIColor(red: 120.0 / 255.0, green: 190.0 / 255.0, blue: 170.0 / 255.0, alpha: 1.0)
    static let butterYellow: UIColor = UIColor(red: 241.0 / 255.0, green: 195.0 / 255.0, blue: 116.0 / 255.0, alpha: 1.0)
    static let eggshellWhite: UIColor = UIColor(red: 220.0 / 255.0, green: 220.0 / 255.0, blue: 200.0 / 255.0, alpha: 1.0)
    
    
    static let lightLeafGreen = UIColor(red: 104.0 / 255.0, green: 174.0 / 255.0, blue: 120.0 / 255.0, alpha: 1.0)
    
   
    static let leafGreen = UIColor(red: 104.0 / 255.0, green: 154.0 / 255.0, blue: 100.0 / 255.0, alpha: 1.0)
    
   
    static let darkLeafGreen = UIColor(red: 104.0 / 255.0, green: 144.0 / 255.0, blue: 90.0 / 255.0, alpha: 1.0)
    
   
    static let darkWaterBlue = UIColor(red: 101.0 / 255.0, green: 129.0 / 255.0, blue: 144.0 / 255.0, alpha: 1.0)

    
    static let waterBlue = UIColor(red: 101.0 / 255.0, green: 139.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0)
    
 
    static let lightWaterBlue = UIColor(red: 101.0 / 255.0, green: 159.0 / 255.0, blue: 174.0 / 255.0, alpha: 1.0)
    
  
    static let lightBlueGreen = UIColor(red: 39.0 / 255.0, green: 118.0 / 255.0, blue: 112.0 / 255.0, alpha: 1.0)
    
   
    static let mixedBlueGreen = UIColor(red: 39.0 / 255.0, green: 98.0 / 255.0, blue: 92.0 / 255.0, alpha: 1.0)
    
   
    static let darkBlueGreen = UIColor(red: 39.0 / 255.0, green: 78.0 / 255.0, blue: 72.0 / 255.0, alpha: 1.0)
    
   
    static let lightBackgroundGray = UIColor(red: 242.0 / 255.0, green: 242.0 / 255.0, blue: 247.0 / 255.0, alpha: 1.0)
    
    
    static let darkBackgroundGray = UIColor(red: 36.0 / 255.0, green: 36.0 / 255.0, blue: 40.0 / 255.0, alpha: 1.0)
    
   
    static let disabledGray = UIColor(red: 28.0 / 255.0, green: 28.0 / 255.0, blue: 30.0 / 255.0, alpha: 1.0)
    
    
    static let lightModeBackgroundGray = UIColor(red: 242.0 / 255.0, green: 242.0 / 255.0, blue: 247.0 / 255.0, alpha: 1.0)
    
    
    static let customBackgroundColor = UIColor.init(named: "customBackgroundColor")
    
    
    static let customCellColor = UIColor.init(named: "customCellColor")
    
   
    static let customTimeLabelColor = UIColor.init(named: "customTimeLabelColor")
    
    
    static let customDisabledGrayColor = UIColor.init(named: "customDisabledGrayColor")
    
    static let customSelectedDayColor = UIColor.init(named: "customSelectedDayColor")
    

    static let customComponentColor = UIColor.init(named: "customComponentColor")
    
   
    static let customDetailBackgroundColor = UIColor.init(named: "customDetailBackgroundColor")
  
    static let customAppearanceComponentColor = UIColor.init(named: "customAppearanceComponentColor")
    
   
    func updateToDarkOrLightTheme() {
        if UserDefaults.standard.bool(forKey: .darkThemeOn) {
            print("Dark Theme On in Switch")
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .dark
        }
   
        else {
            print("Light Theme On in Switch")
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
        }
    }
    
 
    static var mainThemeColor: UIColor {
        return UIColor.colorsArray[UserDefaults.standard.integer(forKey: .mainNavThemeColor)]
    }

   
    static let colorsArray = [.mixedBlueGreen, .waterBlue, UIColor.systemRed, UIColor.systemOrange, UIColor.systemYellow, UIColor.systemGreen, UIColor.systemBlue, UIColor.systemIndigo, UIColor.systemPurple, UIColor.systemPink, UIColor.systemTeal, UIColor.darkGray, UIColor.brown, .creamPink, .butterYellow, .mintGreen, .eggshellWhite, .leafGreen]
}
