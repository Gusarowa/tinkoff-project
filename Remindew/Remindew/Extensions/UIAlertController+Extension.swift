//
//  UIAlertController+Extension.swift
//  Remindew
//
//  Created by Лена Гусарова on 01.06.2023.
//

import Foundation
import UIKit

extension UIAlertController {
    
    
    static func makeAlert(title: String, message: String, vc: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(alertAction)
        vc.present(alertController, animated: true, completion: nil)
    }
    
  
    static func makeCameraUsagePermissionAlert(vc: UIViewController) {
    
        let title = NSLocalizedString("Camera Access Denied",
                                      comment: "Title for camera usage not allowed")
        let message = NSLocalizedString("Please allow camera usage by going to Settings and turning Camera access on", comment: "Error message for when camera access is not allowed")
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let alertAction = UIAlertAction(title: "OK", style: .default) { _ in
            print("selected OK option")
        }
        let settingsString = NSLocalizedString("Settings", comment: "String for Settings option")
        let settingsAction = UIAlertAction(title: settingsString, style: .default) { _ in
           
            print("selected Settings option")
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }
        alertController.addAction(alertAction)
        alertController.addAction(settingsAction)
        vc.present(alertController, animated: true, completion: nil)
    }
    
 
    static func makeDaysAlert(progressView: UIProgressView, vc: UIViewController) {
        
        let title = NSLocalizedString("Missing Watering Days",
                                      comment: "Title for when watering days are missing")
        let message = NSLocalizedString("Please select which days you would like to receive reminders",
                                        comment: "Message for when watering days are missing")
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        progressView.progress = 0.0
        
        let alertAction = UIAlertAction(title: "OK", style: .default) { _ in

            UIView.animate(withDuration: 0.275) {
                progressView.setProgress(1.0, animated: true)
            }
        }
        
        alertController.addAction(alertAction)
        vc.present(alertController, animated: true, completion: nil)
    }
    

    
   
    static func makeReminderDeletionWarningAlert(reminder: Reminder, plant: Plant, indexPath: IndexPath, vc: DetailViewController) {
        
        guard let reminderName = reminder.actionName else { return }
        let title = NSLocalizedString("Delete Reminder",
                                      comment: "Title Reminder Deletion Alert")
        let message = NSLocalizedString("Would you like to delete ",
                                        comment: "Message for when nickname is missing in textfield") + "\(reminderName)?" + "\n" + NSLocalizedString("This can not be undone.", comment: "Deletion can't be undone")
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
       
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel Plant Deletion Option"), style: .default)
        
       
        let deleteAction = UIAlertAction(title: NSLocalizedString("Delete", comment: "Delete Plant Option"), style: .destructive) { _ in
            vc.plantController?.deleteReminderFromPlant(reminder: reminder, plant: plant)
            vc.resultsTableView.deleteRows(at: [indexPath], with: .fade)
            vc.resultsTableView.reloadData()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        vc.present(alertController, animated: true, completion: nil)
    }
    
    
    static func makeSpeciesAlert(textField: UITextField, vc: UIViewController) {
        
        let title = NSLocalizedString("Missing Plant Type",
                                      comment: "Title for when species name is missing in textfield")
        let message = NSLocalizedString("Please enter the type of plant you have.",
                                        comment: "Message for when plant type name is missing in textfield")

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let alertAction = UIAlertAction(title: "OK", style: .default) { _ in
            textField.becomeFirstResponder()
        }
        
        alertController.addAction(alertAction)
        vc.present(alertController, animated: true, completion: nil)
    }
}
