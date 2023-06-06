//
//  PlantController.swift
//  Remindew
//
//  Created by Лена Гусарова on 01.06.2023.

import Foundation
import CoreData
import UserNotifications
import UIKit

class PlantController {
    
    // MARK: - Properties
        
    let calendar = Calendar.current
    
    /// "https://trefle.io/api/v1/plants/search?token="
    let baseUrl = URL(string: "https://trefle.io/api/v1/species/search?token=")!
    
    private var loadedImages = [URL: UIImage]() {
        didSet {
            // clear cache after 100 images are stored
            if loadedImages.count > 100 {
                loadedImages.removeAll()
            }
        }
    }
    
    
    private var runningRequests = [UUID: URLSessionDataTask]()
    
  
    var currentDayComps: DateComponents {
        let currentDateComps = calendar.dateComponents([.year, .month, .day, .hour, .minute, .weekday],
        from: Date())
        return currentDateComps
    }
    
    var plantSearchResults: [PlantSearchResult] = []
    var tempToken: TempToken?
    
    // MARK: - Plant CRUD
    
    func createPlant(nickname: String, species: String, date: Date, frequency: [Int16], scientificName: String, notepad: NotePad, appearanceOptions: AppearanceOptions) -> Plant {
        
        let plant = Plant(nickname: nickname,
                          species: species,
                          water_schedule: date,
                          frequency: frequency,
                          scientificName: scientificName,
                          notes: notepad.notes,
                          mainTitle: notepad.mainTitle,
                          mainMessage: notepad.mainMessage,
                          mainAction: notepad.mainAction,
                          location: notepad.location,
                          plantIconIndex: appearanceOptions.plantIconIndex,
                          plantColorIndex: appearanceOptions.plantColorIndex,
                          actionIconIndex: appearanceOptions.actionIconIndex,
                          actionColorIndex: appearanceOptions.actionColorIndex)
     
        addRequestsForPlant(plant: plant)
        
      
        savePlant()
        return plant
    }
    
    func update(nickname: String,
                species: String,
                water_schedule: Date,
                frequency: [Int16],
                scientificName: String,
                notepad: NotePad,
                appearanceOptions: AppearanceOptions,
                plant: Plant) {
        
        plant.nickname = nickname
        plant.species = species
        plant.water_schedule = water_schedule
        plant.frequency = frequency
        plant.scientificName = scientificName
        
        plant.notes = notepad.notes
        plant.mainTitle = notepad.mainTitle
        plant.mainMessage = notepad.mainMessage
        plant.mainAction = notepad.mainAction
        plant.location = notepad.location
        
        plant.plantIconIndex = appearanceOptions.plantIconIndex
        plant.plantColorIndex = appearanceOptions.plantColorIndex
        plant.actionIconIndex = appearanceOptions.actionIconIndex
        plant.actionColorIndex = appearanceOptions.actionColorIndex
        
        
        removeAllRequestsForPlant(plant: plant)
        
        
        addRequestsForPlant(plant: plant)
        
        savePlant()
    }
    
    
    func updateInNotepad(notepad: NotePad,
                         plant: Plant) {
        
        var remakeNotifications = true
        if plant.mainTitle == notepad.mainTitle && plant.mainMessage == notepad.mainMessage {
            remakeNotifications = false
        }
        
        plant.scientificName = notepad.scientificName
        plant.notes = notepad.notes
        plant.mainTitle = notepad.mainTitle
        plant.mainMessage = notepad.mainMessage
        plant.mainAction = notepad.mainAction
        plant.location = notepad.location
        
       
        if remakeNotifications {
            removeAllRequestsForPlant(plant: plant)
            addRequestsForPlant(plant: plant)
        }
        
        savePlant()
    }

    func updatePlantWithWatering(plant: Plant, needsWatering: Bool) {
        
        plant.needsWatering = needsWatering
        
        if needsWatering == false {
            plant.lastDateWatered = Date()
        }
        
        
        savePlant()
    }
    
    func togglePlantNotifications(plant: Plant) {
        
        
        plant.isEnabled.toggle()
        
        
        removeAllRequestsForPlant(plant: plant)
        
        
        addRequestsForPlant(plant: plant)
    
    
        savePlant()
    }
    
   
    func deletePlant(plant: Plant) {
        
        
        UIImage.deleteImage("userPlant\(plant.identifier!)")
        
        
        removeAllRequestsForPlant(plant: plant)
        
        
        deleteAllReminderNotificationsForPlant(plant: plant)
        
        CoreDataStack.shared.mainContext.delete(plant)
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            CoreDataStack.shared.mainContext.reset()
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    func savePlant() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    // MARK: - Reminders CRUD
    
    func addNewReminderToPlant(plant: Plant, actionName: String, alarmDate: Date, frequency: Int16, actionTitle: String, actionMessage: String, notes: String, isEnabled: Bool, colorIndex: Int16, iconIndex: Int16) {
        
        let reminderToAdd = Reminder(actionName: actionName,
                                     alarmDate: alarmDate,
                                     frequency: frequency,
                                     actionTitle: actionTitle,
                                     actionMessage: actionMessage,
                                     colorIndex: colorIndex,
                                     iconIndex: iconIndex,
                                     isEnabled: isEnabled,
                                     notes: notes)
        
        plant.addToReminders(reminderToAdd)
        createNotificationForReminder(plant: plant, reminder: reminderToAdd)
        savePlant()
    }
    
    func editReminder(reminder: Reminder, actionName: String, alarmDate: Date, frequency: Int16, actionTitle: String, actionMessage: String, notes: String, isEnabled: Bool, colorIndex: Int16, iconIndex: Int16) {
        
        let shouldUpdateNotification = checkIfReminderNeedsNewNotification(reminder: reminder,
                                                                           newDate: alarmDate,
                                                                           newTitle: actionTitle,
                                                                           newMessage: actionMessage)
        
        reminder.actionName = actionName
        reminder.alarmDate = alarmDate
        reminder.frequency = frequency
        reminder.actionTitle = actionTitle
        reminder.actionMessage = actionMessage
        reminder.notes = notes
        reminder.isEnabled = isEnabled
        reminder.colorIndex = colorIndex
        reminder.iconIndex = iconIndex
        
    
        if shouldUpdateNotification {
            updateNotificationForReminder(reminder: reminder)
        }
        
        savePlant()
    }
    
    func updateReminderDates(reminder: Reminder) {
        
        reminder.lastDate = Date()
        reminder.alarmDate = reminder.alarmDate?.addingTimeInterval(86400 * Double(reminder.frequency))
        deleteReminderNotificationForPlant(reminder: reminder, plant: reminder.plant!)
        createNotificationForReminder(plant: reminder.plant!, reminder: reminder)
        savePlant()
    }
    
   
    func plantRemindersNeedAttention(plant: Plant) -> Bool {
                
        for reminder in plant.reminders?.allObjects as! Array<Reminder> {
            if reminder.alarmDate! <= Date() {
                return true
            }
        }
        
        return false
    }

    
    func toggleReminderNotification(plant: Plant, reminder: Reminder) {
        
        
        reminder.isEnabled.toggle()
        
        
        deleteReminderNotificationForPlant(reminder: reminder, plant: plant)
        
        
        createNotificationForReminder(plant: plant, reminder: reminder)
        
        savePlant()
    }
    
    
    func deleteReminderFromPlant(reminder: Reminder, plant: Plant) {
        
    
        plant.removeFromReminders(reminder)
        
        
        deleteReminderNotificationForPlant(reminder: reminder, plant: plant)
        
        CoreDataStack.shared.mainContext.delete(reminder)
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            CoreDataStack.shared.mainContext.reset() // UN-deletes
            NSLog("Error saving managed object context (reminder): \(error)")
        }
    }
    
    // MARK: - Helpers
    
    
    func newTempTokenIsNeeded() -> Bool {
        if let lastDate = UserDefaults.standard.object(forKey: .lastDateTokenGrabbed) as? Date {
            if Date().timeIntervalSince(lastDate) < 85000 {
                return false
            }
        }
        return true
    }
    
    func printLastTokenAndDate() {
        
        if let lastToken = UserDefaults.standard.string(forKey: .lastTempToken) {
            print("lastToken = \(lastToken)")
        } else {
            print("lastToken = nil")
        }
        if let lastDate = UserDefaults.standard.object(forKey: .lastDateTokenGrabbed) as? Date {
            print("currDate = \(DateFormatter.lastWateredDateFormatter.string(from: Date()))")
            print("lastDate = \(DateFormatter.lastWateredDateFormatter.string(from: lastDate))")
        } else {
            print("lastDate = nil")
        }
    }
    
    // MARK: - Notification Center
    
    func returnPlantNotificationIdentifiers(plant: Plant) -> [String] {
        var result = [String]()
        
        for i in 1...7 {
            result.append("\(i)\(plant.identifier!)")
        }
        
        return result
    }
        
    func makeDateCompsForSchedule(weekday: Int16, time: Date) -> DateComponents {
        let day = Int(weekday)
        let timeComps = calendar.dateComponents([.hour, .minute], from: time)
        var dateComps = DateComponents()
        dateComps.hour = timeComps.hour
        dateComps.minute = timeComps.minute
        dateComps.weekday = day
        return dateComps
    }

    func makeAllRequestsForPlant(plant: Plant) {
        
        for day in plant.frequency! {

            
            let identifier = "\(day)\(plant.identifier!)"
            let content = UNMutableNotificationContent()
        
            if plant.isEnabled {
                
        
                content.sound = .default
                
            
                var title = NSLocalizedString("Time to water your plant!", comment: "Title for notification")
                if plant.mainTitle != nil && plant.mainTitle != "" {
                    title = plant.mainTitle!
                }
                content.title = "\(title)"

                
                var message = "\(plant.nickname!) " + NSLocalizedString("needs water.", comment: "plant.nickname needs water.")
                if plant.mainMessage != nil && plant.mainMessage != "" {
                    message = plant.mainMessage!
                }
                content.body = message
            }
            
            
            content.badge = 1

           
            let date = makeDateCompsForSchedule(weekday: day, time: plant.water_schedule!)
            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)

           
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error {
                    NSLog("Error adding notification: \(error)")
                }
            }
        }
    }
    
  
    func addRequestsForPlant(plant: Plant) {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            switch granted {
            case true:
                DispatchQueue.main.async {
                    self.makeAllRequestsForPlant(plant: plant)
                }
            case false:
                print("permission NOT granted, please allow notifications")
                return
            }
        }
    }
    
   
    func removeAllRequestsForPlant(plant: Plant) {
        
        let notesToRemove = returnPlantNotificationIdentifiers(plant: plant)
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: notesToRemove)
    }
    
  
    func createNotificationForReminder(plant: Plant, reminder: Reminder) {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            switch granted {
            case true:
                DispatchQueue.main.async {
                    self.makeReminderNotificationForPlant(reminder: reminder, plant: plant)
                }
            case false:
                print("permission NOT granted, please allow notifications")
                return
            }
        }
    }
    
    
    func makeReminderNotificationForPlant(reminder: Reminder, plant: Plant) {
        
        let identifier = "\(reminder.identifier!)\(plant.identifier!)"
        let content = UNMutableNotificationContent()
        if reminder.isEnabled {
            
            content.sound = .default
            
           
            var title = NSLocalizedString("Time to water your plant!", comment: "Title for notification")
            
            if reminder.actionTitle != nil && reminder.actionTitle != "" {
                title = reminder.actionTitle!
            }
            content.title = "\(title)"
            
          
            var message = "\(plant.nickname!) " + NSLocalizedString("needs water.", comment: "plant.nickname needs water.")
            if reminder.actionMessage != nil && reminder.actionMessage != "" {
                message = reminder.actionMessage!
            }
            content.body = message
        }
        
       
        content.badge = 1

       
        let dateComps = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: reminder.alarmDate!)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComps, repeats: false)

        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                NSLog("Error adding reminder notification: \(error)")
            }
        }
    }
    
  
    func checkIfReminderNeedsNewNotification(reminder: Reminder, newDate: Date, newTitle: String, newMessage: String) -> Bool {
        
        guard let oldTitle = reminder.actionTitle, let oldMessage = reminder.actionMessage, let oldDate = reminder.alarmDate else {
            return false
        }
        
      
        guard newTitle != oldTitle || newMessage != oldMessage || newDate != oldDate else { return false }
        
        return true
    }
    
   
    func updateNotificationForReminder(reminder: Reminder) {
        deleteReminderNotificationForPlant(reminder: reminder, plant: reminder.plant!)
        createNotificationForReminder(plant: reminder.plant!, reminder: reminder)
    }
    
   
    func deleteReminderNotificationForPlant(reminder: Reminder, plant: Plant) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(reminder.identifier!)\(plant.identifier!)"])
    }
    
    
    func deleteAllReminderNotificationsForPlant(plant: Plant) {
        
        let remindersArray = plant.reminders?.allObjects as! Array<Reminder>
        for reminder in remindersArray {
            deleteReminderNotificationForPlant(reminder: reminder, plant: plant)
        }
    }
    
    // MARK: - Network Calls
    
    
    func signToken(completion: @escaping (Result<String,NetworkError>) -> Void) {
        
        let baseUrl = "https://trefle.io/api/auth/claim?token="
        let websiteUrl = "https://github.com/alvare52/Remindew"
        guard let signUrl = URL(string: "\(baseUrl)\(secretToken)&origin=\(websiteUrl)") else {
            completion(.failure(.invalidToken))
            return
        }
                
        var request = URLRequest(url: signUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("otherError in signToken \(error)")
                completion(.failure(.otherError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                print("status code = \(response.statusCode)")
                completion(.failure(.serverDown))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                self.tempToken = try decoder.decode(TempToken.self, from: data)
                UserDefaults.standard.set(self.tempToken?.token, forKey: "lastTempToken")
                UserDefaults.standard.set(Date(), forKey: "lastDateTokenGrabbed")
                print("self.tempToken now = \(String(describing: self.tempToken))")
            } catch {
                print("Error decoding temp token object: \(error)")
                completion(.failure(.noDecode))
                return
            }
            
            completion(.success("New token/timestamp set to user default"))
        }.resume()
    }
    
   
    func searchPlantSpecies(_ searchTerm: String, completion: @escaping (Result<[PlantSearchResult],NetworkError>) -> Void = { _ in }) {
        
       
        guard let token = UserDefaults.standard.string(forKey: .lastTempToken) else {
            print("userdefault lastTempToken string is nil in searchPlantSpecies")
            completion(.failure(.noToken))
            return
        }
        
        
        guard let requestUrl = URL(string: "\(baseUrl)\(token)&q=\(searchTerm)") else {
            print("invalid url")
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: requestUrl)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
        URLSession.shared.dataTask(with: request) { (data, response, error) in

            if let error = error {
                print("Error fetching searched plants: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.otherError))
                }
                return
            }

            guard let data = data else {
                print("No data return by data task")
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                print("status code = \(response.statusCode)")
                completion(.failure(.serverDown))
                return
            }
        
            let jsonDecoder = JSONDecoder()

            do {
                let plantSearchResultsDataArray = try jsonDecoder.decode(PlantData.self, from: data)
                
                
                let filteredResults = plantSearchResultsDataArray.data.filter {
                    $0.imageUrl != nil && $0.imageUrl?.host != "bs.floristic.org"
                }
                
                DispatchQueue.main.async {
                    completion(.success(filteredResults))
                }
            } catch {
                print("Error decoding or storing searched plants \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.noDecode))
                }
            }
        }.resume()
    }
    
    func loadImage(_ url: URL?, _ completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
        let defaultImage = UIImage.logoImage

        guard let url = url else {
            completion(.success(defaultImage))
            return nil
        }
        
        if let image = loadedImages[url] {
            completion(.success(image))
            return nil
        }
        let uuid = UUID()
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            defer {
                self.runningRequests.removeValue(forKey: uuid)
            }
            
            if let data = data, let image = UIImage(data: data) {
                self.loadedImages[url] = image
                completion(.success(image))
                return
            }
            

            guard let error = error else {
                
                return
            }
            
            guard (error as NSError).code == NSURLErrorCancelled else {
                completion(.failure(error))
                return
            }
            
            
        }
        task.resume()
        runningRequests[uuid] = task
        
        return uuid
    }
    
    func cancelLoad(_ uuid: UUID) {
        runningRequests[uuid]?.cancel()
        runningRequests.removeValue(forKey: uuid)
    }
}
