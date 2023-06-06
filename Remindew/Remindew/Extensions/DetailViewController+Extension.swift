//
//  DetailViewController+Extension.swift
//  Remindew
//
// Created by Лена Гусарова on 01.06.2023.

import Foundation
import UIKit

// MARK: - UITextFieldDelegate

extension DetailViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
       
        if let _ = plant { return }
        if textField == nicknameTextField {
        }
        
        else if textField == speciesTextField {

        }
    }

  
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    
        if textField == nicknameTextField {
            
           
            speciesTextField.becomeFirstResponder()
        }

        return true
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate


extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
     
        if let image = info[.editedImage] as? UIImage {
            imageView.image = image
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let reminderCell = resultsTableView.dequeueReusableCell(withIdentifier: "ResultsCell", for: indexPath) as? ReminderTableViewCell else { return UITableViewCell() }

        reminderCell.reminder = reminders[indexPath.row]
        reminderCell.plantController = plantController
        reminderCell.reminderDelegate = self

        return reminderCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        let reminderCell = tableView.cellForRow(at: indexPath) as? ReminderTableViewCell
        
        let reminderVC = ReminderViewController()
        reminderVC.modalPresentationStyle = .automatic
        reminderVC.plantController = plantController
        reminderVC.plant = plant
        reminderVC.reminder = reminderCell?.reminder
        reminderVC.reminderDelegate = self
        present(reminderVC, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
       
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let reminder = reminders[indexPath.row]
        
        let lastDatePanel = UIContextualAction(style: .normal, title: "") { (action, view, completion) in
            completion(true)
        }
        
        var lastCompletedString = NSLocalizedString("Last: ", comment: "last time completed") + "\n" + DateFormatter.shortTimeAndDateFormatter.string(from: reminder.lastDate ?? Date())
        if reminder.lastDate == nil {
            lastCompletedString = NSLocalizedString("Made: ", comment: "date created label") + "\n" +
                "\(DateFormatter.shortTimeAndDateFormatter.string(from: reminder.dateCreated!))"
        }
        
        lastDatePanel.title = lastCompletedString
        lastDatePanel.backgroundColor = UIColor.colorsArray[Int(reminder.colorIndex)]

        let config = UISwipeActionsConfiguration(actions: [lastDatePanel])
        config.performsFirstActionWithFullSwipe = false
                
        return config
    }
    
   
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let reminder = reminders[indexPath.row]
        
       
        let delete = UIContextualAction(style: .destructive, title: "") { (action, view, completion) in
            if let plant = self.plant {
                UIAlertController.makeReminderDeletionWarningAlert(reminder: reminder, plant: plant, indexPath: indexPath, vc: self)
            }
            completion(true)
        }
        delete.image = UIImage(systemName: "trash.fill")
            
       
        let silence = UIContextualAction(style: .normal, title: "\(reminder.actionName!)") { (action, view, completion) in
            if let plant = self.plant {
                self.plantController?.toggleReminderNotification(plant: plant, reminder: reminder)
                self.resultsTableView.reloadRows(at: [indexPath], with: .right)
            }
            completion(true)
        }
        silence.image = reminder.isEnabled ? UIImage(systemName: "bell.slash.fill") : UIImage(systemName: "bell.fill")
        silence.backgroundColor = .systemIndigo
        
        let config = UISwipeActionsConfiguration(actions: [delete, silence])
        config.performsFirstActionWithFullSwipe = false
        
        return config
        }
}

// MARK: - NotepadDelegate

extension DetailViewController: NotepadDelegate {
    func didMakeNotepad(notepad: NotePad) {
        self.notePad = notepad
    }
    
    func didMakeNotepadWithPlant(notepad: NotePad, plant: Plant) {
        self.notePad = notepad
        self.plant = plant
    }
}


// MARK: - AppearanceDelegate

extension DetailViewController: AppearanceDelegate {
    
    func didSelectAppearanceObjects(image: UIImage?) {
        imageView.image = image
    }
    
    func didSelectColorsAndIcons(appearanceOptions: AppearanceOptions) {
        self.appearanceOptions = appearanceOptions
        plantButton.backgroundColor = UIColor.colorsArray[Int(appearanceOptions.plantColorIndex)]
        waterPlantButton.backgroundColor = UIColor.colorsArray[Int(appearanceOptions.actionColorIndex)]
    }
}

// MARK: - ReminderDelegate

extension DetailViewController: ReminderDelegate {
    
    func didAddOrUpdateReminder() {
        resultsTableView.reloadData()
    }
}
