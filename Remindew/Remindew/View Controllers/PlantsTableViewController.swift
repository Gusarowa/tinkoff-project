//
//  PlantsTableViewController.swift
//  WaterMyPlantsBackup
//
//  Created by Лена Гусарова on 01.06.2023.

import UIKit
import CoreData
import UserNotifications
import AVFoundation

class PlantsTableViewController: UITableViewController {
    // MARK: - Subviews
    
    private lazy var settingsBarButtonLabel = UIBarButtonItem(
        image: UIImage(systemName: "ellipsis.circle"),
        style: .plain,
        target: self,
        action: #selector(settingsBarButtonTapped)
    )
    
    private lazy var addPlantIcon = UIBarButtonItem(
        barButtonSystemItem: .add,
        target: self,
        action: #selector(addPlantButtonTapped)
    )
    
    private lazy var dateLabel = UIBarButtonItem(
        title: "Date",
        style: .plain,
        target: self,
        action: nil
    )
    
    private lazy var completeAllLabel = UIBarButtonItem(
        image: UIImage(systemName: "ellipsis.circle"),
        style: .plain,
        target: self,
        action: #selector(settingsBarButtonTapped)
    )
    
    // MARK: - Actions
    
    @objc private func settingsBarButtonTapped(_ sender: UIBarButtonItem) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        let settingsVC = SettingsPageViewController()
        settingsVC.totalPlantCount = fetchedResultsController
            .fetchedObjects?.count ?? 0
        settingsVC.totalLocationsCount = fetchedResultsController.sectionIndexTitles.count
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    @objc private func completeAllTapped(_ sender: UIBarButtonItem) {
        if plantsThatCurrentlyNeedWater > 0 {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            waterAllAlert()
        }
    }
    
    @objc private func addPlantButtonTapped(_ sender: UIBarButtonItem) {
        if fetchedResultsController.fetchedObjects?.count ?? 0 > 151 {
            UIAlertController.makeAlert(
                title: .plantLimitTitleLocalizedString,
                message: .plantLimitMessageLocalizedString,
                vc: self
            )
            return
        }
        
        AudioServicesPlaySystemSound(SystemSoundID(1104))
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        let detailVC = DetailViewController()
        detailVC.plantController = self.plantController
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    // MARK: - Properties
    
    lazy var fetchedResultsController: NSFetchedResultsController<Plant> = {
        let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
                
        var sortKey = "nickname"
        var secondaryKey = "species"
        
        if UserDefaults.standard.bool(forKey: .sortPlantsBySpecies) {
            print("Sorting by species instead")
            sortKey = "species"
            secondaryKey = "nickname"
        }
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "location", ascending: true),
                                        NSSortDescriptor(key: sortKey, ascending: true),
                                        NSSortDescriptor(key: secondaryKey, ascending: true)]


        let context = CoreDataStack.shared.mainContext

        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: context,
                                             sectionNameKeyPath: "location",
                                             cacheName: nil)
        frc.delegate = self
        try! frc.performFetch()
        return frc
    }()
    
    let plantController = PlantController()
    
    let calendar = Calendar.current
    
    private var observer: NSObjectProtocol?
    
    let refreshWheel = UIRefreshControl()
    
    var plantsThatCurrentlyNeedWater = 0 {
        didSet {
            completeAllLabel.tintColor = plantsThatCurrentlyNeedWater > 0 ? UIColor.mainThemeColor : .clear
        }
    }
    
    var plantsThatNeedAttentionCount = 0 {
        didSet {
            title = plantsThatNeedAttentionCount > 0 ? "Remindew - \(plantsThatNeedAttentionCount)" : "Remindew"
            
            UIApplication.shared.applicationIconBadgeNumber = plantsThatNeedAttentionCount
        }
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateNavColors()
        setupNavigationBar()
        setupTavleView()
        
        addPlantIcon.accessibilityIdentifier = "Add Plant"
        
        UIColor().updateToDarkOrLightTheme()
        
        tableView.refreshControl = refreshWheel
        refreshWheel.addTarget(self, action: #selector(checkIfPlantsNeedWatering), for: .valueChanged)
        
       
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(checkIfPlantsNeedWatering),
                                               name: .checkWateringStatus,
                                               object: nil)
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateSorting),
                                               name: .updateSortDescriptors,
                                               object: nil)
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateNavColors),
                                               name: .updateMainColor,
                                               object: nil)
        
       
        dateLabel.title = DateFormatter.navBarDateFormatter.string(from: Date())
        
       
        observer = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [unowned self] notification in
            
            self.checkIfPlantsNeedWatering()
        }
    }
    
    deinit {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkIfPlantsNeedWatering()
        tableView.reloadData()
    }
    
    // MARK: - Helpers
    
    private func setupTavleView() {
        tableView.backgroundColor = UIColor.customBackgroundColor
        tableView.register(
            PlantsTableViewCell.self,
            forCellReuseIdentifier: "PlantCell"
        )
    }
    
   
    private func setupNavigationBar() {
        navigationItem.title = "Remindew"
        navigationItem.largeTitleDisplayMode = .automatic
        if #available(iOS 16.0, *) {
            navigationItem.style = .navigator
        }
        navigationItem.leftBarButtonItems = [
            settingsBarButtonLabel,
            dateLabel
        ]
        navigationItem.rightBarButtonItems = [
            addPlantIcon,
            completeAllLabel
        ]
    }
    
    private func deletionWarningAlert(plant: Plant) {
        
        guard let plantNickname = plant.nickname else { return }
        let title = NSLocalizedString("Delete Plant",
                                      comment: "Title Plant Deletion Alert")
        let message = NSLocalizedString("Would you like to delete ",
                                        comment: "Message for when nickname is missing in textfield") + "\(plantNickname)?" + "\n" + NSLocalizedString("This can not be undone.", comment: "Deletion can't be undone")
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
      
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel Plant Deletion Option"), style: .default)
        
       
        let deleteAction = UIAlertAction(title: NSLocalizedString("Delete", comment: "Delete Plant Option"), style: .destructive) { _ in
            self.plantController.deletePlant(plant: plant)
            self.checkIfPlantsNeedWatering()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func updateSorting() {
        
        var sortKey = "nickname"
        var secondaryKey = "species"
        
        if UserDefaults.standard.bool(forKey: .sortPlantsBySpecies) {
            print("Sorting by species instead")
            sortKey = "species"
            secondaryKey = "nickname"
        }

        fetchedResultsController.fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "location", ascending: true),
            NSSortDescriptor(key: sortKey, ascending: true),
            NSSortDescriptor(key: secondaryKey, ascending: true)
        ]
        
       
        do {
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch {
            print("fetch failed in updateSorting")
        }
    }
    
    @objc private func checkIfPlantsNeedWatering() {
        
        var attentionCount = 0
        var waterOnlyCount = 0
        
        let currentDayComps = calendar.dateComponents([.day, .weekday], from: Date())
        let currentDay = currentDayComps.day!
        let currentWeekday = Int16(currentDayComps.weekday!)
        
        for plant in fetchedResultsController.fetchedObjects! {
            
            if plantController.plantRemindersNeedAttention(plant: plant) || plant.needsWatering {
                attentionCount += 1
                if plant.needsWatering {
                    waterOnlyCount += 1
                }
            }
            
          
            guard !plant.needsWatering else { continue }
            
            guard plant.frequency!.firstIndex(of: currentWeekday) != nil else { continue }
            
            var lastDay = 0
            if let lastWatered = plant.lastDateWatered {
                
                lastDay = calendar.dateComponents([.day], from: lastWatered).day!
            } else {
             
                lastDay = 100
            }
            
           
            guard lastDay != currentDay else { continue }
                        
           
            let plantComps = calendar.dateComponents([.hour, .minute], from: plant.water_schedule!)
            let plantHour = plantComps.hour!
            let plantMinute = plantComps.minute!
            
            
            let dateThatNeedsWatering = DateFormatter.returnDateFromHourAndMinute(hour: plantHour, minute: plantMinute)
                        
            
            if dateThatNeedsWatering <= Date() {
               
                plantController.updatePlantWithWatering(plant: plant, needsWatering: true)
                attentionCount += 1
                waterOnlyCount += 1
            }
        }
        
        plantsThatNeedAttentionCount = attentionCount
        plantsThatCurrentlyNeedWater = waterOnlyCount
        
        
        dateLabel.title = DateFormatter.navBarDateFormatter.string(from: Date())
        
        
        tableView.reloadData()
        
        
        refreshWheel.endRefreshing()
    }
    
    @objc private func updateNavColors() {
                    
        
        let navBarColor = UIColor.mainThemeColor
        
        
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: navBarColor]
        
       
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: navBarColor]
        
      
        navigationController?.navigationBar.tintColor = navBarColor
        
      
        dateLabel.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: navBarColor], for: .disabled)
                
        
        refreshWheel.tintColor = navBarColor
        
        
        completeAllLabel.tintColor = plantsThatCurrentlyNeedWater > 0 ? navBarColor : .clear

      
    }
    
    private func waterAllAlert() {
        
        let title = String.returnWaterAllPlantsLocalizedString(count: plantsThatCurrentlyNeedWater)
        let message = NSLocalizedString("Would you like to water all plants that currently need water?", comment: "water all message")
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
                
       
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel Alert"), style: .default)
        
        
        let waterAction = UIAlertAction(title: NSLocalizedString("Water", comment: "Ok water all plants"), style: .default) { _ in
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            self.waterAllPlants()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(waterAction)
        present(alertController, animated: true, completion: nil)
    }
    

    func waterAllPlants() {
        
     
        for plant in fetchedResultsController.fetchedObjects! {
            if plant.needsWatering {
                
                
                plantController.updatePlantWithWatering(plant: plant, needsWatering: false)
                
                if !plantController.plantRemindersNeedAttention(plant: plant) {
                    plantsThatNeedAttentionCount -= 1
                }
            }
        }
        
       
        plantsThatCurrentlyNeedWater = 0
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionInfo = fetchedResultsController.sections?[section] else {
            return nil
        }
        return sectionInfo.name.capitalized
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = .customBackgroundColor
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .darkGray
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlantCell", for: indexPath) as? PlantsTableViewCell else {
            return UITableViewCell()
        }
        cell.plant = fetchedResultsController.object(at: indexPath)
        cell.awakeFromNib()
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let plant = fetchedResultsController.object(at: indexPath)
        
        
        let completeTask = UIContextualAction(style: .normal, title: "") { (action, view, completion) in
            if plant.needsWatering {
                self.plantController.updatePlantWithWatering(plant: plant, needsWatering: false)
                self.plantsThatCurrentlyNeedWater -= 1
                
                if !self.plantController.plantRemindersNeedAttention(plant: plant) {
                    self.plantsThatNeedAttentionCount -= 1
                }
            }
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            completion(true)
        }
        
        var lastCompletedString = DateFormatter.lastWateredDateFormatter.string(from: plant.lastDateWatered ?? Date())
        if plant.lastDateWatered == nil {
            lastCompletedString = NSLocalizedString("Brand New Plant", comment: "plant that hasn't been watered yet")
        }
        
        completeTask.image = plant.needsWatering ? UIImage.iconArray[Int(plant.actionIconIndex)] : UIImage(systemName: "clock.arrow.circlepath")
        completeTask.title = plant.needsWatering ? "\(plant.mainAction ?? "Water")" : lastCompletedString
        completeTask.backgroundColor = UIColor.colorsArray[Int(plant.actionColorIndex)]
        
        let config = UISwipeActionsConfiguration(actions: [completeTask])
        config.performsFirstActionWithFullSwipe = plant.needsWatering ? true : false
                
        return config
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.plant = fetchedResultsController.object(at: indexPath)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let plant = fetchedResultsController.object(at: indexPath)
        
       
        let delete = UIContextualAction(style: .destructive, title: "") { (action, view, completion) in
            print("Deleted \(plant.nickname!)")
            self.deletionWarningAlert(plant: plant)
            completion(true)
        }
        delete.image = UIImage(systemName: "trash.fill")
        
       
        let silence = UIContextualAction(style: .normal, title: "") { (action, view, completion) in
            print("Silenced \(plant.nickname!)")
            self.plantController.togglePlantNotifications(plant: plant)
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            completion(true)
        }
        silence.image = plant.isEnabled ? UIImage(systemName: "bell.slash.fill") : UIImage(systemName: "bell.fill")
        silence.backgroundColor = .systemIndigo
        
        let config = UISwipeActionsConfiguration(actions: [delete, silence])
        config.performsFirstActionWithFullSwipe = false
        
        return config
    }
}

// MARK: - NSFetchedResultsControllerDelegate


extension PlantsTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .right)
        case .move:
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
        }
    }
}

extension PlantsTableViewController: UNUserNotificationCenterDelegate {
    
}
