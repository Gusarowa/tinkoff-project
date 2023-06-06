//
//  DetailViewController.swift
//  WaterMyPlantsBackup
//  
//  Created by Лена Гусарова on 01.06.2023.


import UIKit
import AVFoundation

class DetailViewController: UIViewController {
    // MARK: - Subviews
    lazy var nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Leaf Erikson"
        textField.isUserInteractionEnabled = true
        textField.font = .systemFont(ofSize: 25, weight: .heavy)
        textField.backgroundColor = .clear
        textField.tintColor = .white
        textField.adjustsFontSizeToFitWidth = true
        textField.autocorrectionType = .no
        textField.borderStyle = .none
        textField.delegate = self
        textField.attributedPlaceholder = NSAttributedString(
            string: .nicknameLocalizedString,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        return textField
    }()

    lazy var speciesTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Rugosa Rose"
        textField.isUserInteractionEnabled = true
        textField.font = .systemFont(ofSize: 18)
        textField.adjustsFontSizeToFitWidth = true
        textField.backgroundColor = .clear
        textField.tintColor = .white
        textField.autocorrectionType = .no
        textField.borderStyle = .none
        textField.delegate = self
        textField.returnKeyType = .search
        textField.attributedPlaceholder = NSAttributedString(
            string: .typeOfPlantLocalizedString,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        return textField
    }()

    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .wheels
        picker.datePickerMode = .time
        picker.minuteInterval = 1
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    lazy var plantButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.text = "Add plant"
        button.backgroundColor = UIColor.colorsArray[0]
        button.tintColor = .white
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(plantButtonTapped), for: .touchUpInside)
        return button
    }()

   
    
    

    lazy var waterPlantButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.text = "Add plant"
        button.backgroundColor = UIColor.colorsArray[0]
        button.tintColor = .white
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(waterPlantButtonTapped), for: .touchUpInside)
        return button
    }()

    lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "RemindewDefaultImage"))
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    
    lazy var dayProgressView: UIProgressView = {
        let progress = UIProgressView()
        progress.progressViewStyle = .default
        progress.progress = 0
        progress.tintColor = .darkBackgroundGray
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress

    }()

    lazy var daySelectionView: DaySelectionView = {
        let day = DaySelectionView()
        day.translatesAutoresizingMaskIntoConstraints = false
        return day
    }()

    lazy var resultsTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = .zero
        tableView.layoutMargins = .zero
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .customDetailBackgroundColor
        return tableView
    }()
    
    private lazy var dateLabel = UIBarButtonItem(
        title: "Date",
        style: .plain,
        target: self,
        action: nil
    )

    
    private lazy var notesButtonLabel = UIBarButtonItem(
        image: UIImage(systemName: "note.text"),
        style: .plain,
        target: self,
        action: #selector(notesButtonTapped)
    )

    
    

    private lazy var reminderButtonLabel = UIBarButtonItem(
        image: UIImage(systemName: "bell.circle"),
        style: .plain,
        target: self,
        action: #selector(reminderButtonTapped)
    )

    private lazy var spacerButton = UIBarButtonItem(
        image: UIImage(systemName: "photo"),
        style: .bordered,
        target: self,
        action: nil
    )

    let spinner = UIActivityIndicatorView(style: .large)

    // MARK: - Properties

    var plantController: PlantController?

    var plant: Plant? {
        didSet {
            updateViews()
        }
    }

    var notePad: NotePad?
    var appearanceOptions: AppearanceOptions?
    var plantSearchResult: PlantSearchResult?
    var plantSearchResults: [PlantSearchResult] = [] {
        didSet {
            resultsTableView.reloadData()
        }
    }

    var reminders: [Reminder] {


        if let plant = plant {
            var resultsArray = plant.reminders?.allObjects as! Array<Reminder>
            resultsArray.sort() { $0.alarmDate! < $1.alarmDate! }
            return resultsArray
        }
        return []
    }

    private var gradientAlreadyAppliedToImageView = false

    // MARK: - Actions
    @objc private func notesButtonTapped(_ sender: UIBarButtonItem) {


        let notepadVC = NotepadViewController()
        notepadVC.modalPresentationStyle = .automatic
        notepadVC.plantController = plantController
        notepadVC.plant = plant
        notepadVC.notepadDelegate = self
        notepadVC.passedInNickname = nicknameTextField.text
        present(notepadVC, animated: true, completion: nil)
    }

    @objc private func waterPlantButtonTapped(_ sender: UIButton) {
        if let existingPlant = plant {
            if existingPlant.needsWatering {
                plantController?.updatePlantWithWatering(plant: existingPlant, needsWatering: false)
            }
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func reminderButtonTapped(_ sender: UIBarButtonItem) {

        if reminders.count >= 7 {
            UIAlertController.makeAlert(title: .reminderLimitTitleLocalizedString,
                                        message: .reminderLimitMessageLocalizedString,
                                        vc: self)
        }

       
    }
    


    @objc private func plantButtonTapped(_ sender: UIButton) {

       
        UNUserNotificationCenter.current().getNotificationSettings { settings in

           
            if settings.alertSetting == .enabled  && settings.badgeSetting == .enabled && settings.soundSetting == .enabled {
                print("Permission Granted (.alert, .badge, .sound)")
                DispatchQueue.main.async {
                    self.addOrEditPlant()                }
            }
       
            else {
                print("Push Notifications disabled")
                DispatchQueue.main.async {
                    self.addOrEditPlant()
                }
            }
        }
    }

   
    @objc private func tappedOnImageView() {
        AudioServicesPlaySystemSound(SystemSoundID(1104))
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()


        let appearanceVC =  AppearanceViewController()
        appearanceVC.modalPresentationStyle = .automatic
        appearanceVC.mainImage = imageView.image
        appearanceVC.appearanceDelegate = self
        appearanceVC.plant = plant
        present(appearanceVC, animated: true, completion: nil)
    }

    // MARK: - View Life Cycle

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        
        if !gradientAlreadyAppliedToImageView {
            UIImage.applyLowerPortionGradient(imageView: imageView)
            gradientAlreadyAppliedToImageView = true
        }
    }

    override func viewDidLoad() {

        super.viewDidLoad()
        setupView()
        setupNavigationBar()

        view.backgroundColor = .customDetailBackgroundColor

        spacerButton.tintColor = .clear
        spacerButton.isEnabled = false

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshReminders),
                                               name: .checkWateringStatus,
                                               object: nil)

        let backButton = UIBarButtonItem(title: NSLocalizedString("Back", comment: "back button"))
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton

        resultsTableView.backgroundView = spinner
        spinner.color = .leafGreen
        addTouchGestures()

        updateViews()
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)

        if nicknameTextField.text == "" {
            nicknameTextField.becomeFirstResponder()
        }

        UIView.animate(withDuration: 0.4) {
            self.dayProgressView.setProgress(1.0, animated: true)
        }
    }

    // MARK: - Helpers
    private func setupView() {
        view.addSubview(imageView)
        view.addSubview(dayProgressView)
        view.addSubview(daySelectionView)
        view.addSubview(datePicker)
        view.addSubview(resultsTableView)

        let textFieldsStackView = UIStackView(arrangedSubviews: [
            nicknameTextField,
            speciesTextField
        ])
        textFieldsStackView.spacing = 10
        textFieldsStackView.axis = .vertical
        textFieldsStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textFieldsStackView)

        let buttonsStackView = UIStackView(arrangedSubviews: [
            plantButton,
            waterPlantButton
        ])
        buttonsStackView.spacing = 10
        buttonsStackView.axis = .horizontal
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsStackView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 239),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            textFieldsStackView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 26),
            textFieldsStackView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -26),
            textFieldsStackView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -6),

            dayProgressView.heightAnchor.constraint(equalToConstant: 2),
            dayProgressView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            dayProgressView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            dayProgressView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),

            daySelectionView.topAnchor.constraint(equalTo: dayProgressView.bottomAnchor, constant: 6),
            daySelectionView.trailingAnchor.constraint(equalTo: dayProgressView.trailingAnchor),
            daySelectionView.leadingAnchor.constraint(equalTo: dayProgressView.leadingAnchor),

            datePicker.topAnchor.constraint(equalTo: daySelectionView.bottomAnchor, constant: 6),
            datePicker.trailingAnchor.constraint(equalTo: dayProgressView.trailingAnchor),
            datePicker.leadingAnchor.constraint(equalTo: dayProgressView.leadingAnchor),

            buttonsStackView.topAnchor.constraint(equalTo: datePicker.bottomAnchor),
            buttonsStackView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            buttonsStackView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),

            resultsTableView.topAnchor.constraint(equalTo: buttonsStackView.bottomAnchor),
            resultsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            resultsTableView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            resultsTableView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
        ])
    }

    private func setupNavigationBar() {
        navigationItem.title = "Remindew"
        navigationItem.largeTitleDisplayMode = .automatic
        if #available(iOS 16.0, *) {
            navigationItem.style = .navigator
        }
        navigationItem.rightBarButtonItems = [
            notesButtonLabel,
            spacerButton,
            dateLabel,
            reminderButtonLabel
        ]
    }

    func updateViews() {

        
        dateLabel.title = DateFormatter.navBarDateFormatter.string(from: Date())

       
        dateLabel.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.mainThemeColor], for: .disabled)

      
        guard isViewLoaded else {return}

        
        if let plant = plant {

            notePad = NotePad(notes: plant.notes!, mainTitle: plant.mainTitle!, mainMessage: plant.mainMessage!, mainAction: plant.mainAction!, location: plant.location!, scientificName: plant.scientificName!)

           
            if let image = UIImage.loadImageFromDiskWith(fileName: "userPlant\(plant.identifier!)") {
                imageView.image = image
            }

            plantButton.setTitle(NSLocalizedString("Save", comment: "Done button"), for: .normal)

           
            if plant.location != "" {
                title = plant.location!
            } else {
                if plant.frequency!.count == 7 {
                    title = NSLocalizedString("Every day", comment: "7 times a week")
                }
                else if plant.frequency!.count == 1 {
                    title = NSLocalizedString("Once a week", comment: "1 time a week")
                }
                else {
                    title = "\(plant.frequency!.count)" + NSLocalizedString(" times a week", comment: "Water (X) times a week")
                }
            }

            nicknameTextField.text = plant.nickname
            speciesTextField.text = plant.species
            datePicker.date = plant.water_schedule!
            daySelectionView.selectDays((plant.frequency)!)
            waterPlantButton.isHidden = false

            reminderButtonLabel.isEnabled = true

            plantButton.backgroundColor = UIColor.colorsArray[Int(plant.plantColorIndex)]
            waterPlantButton.backgroundColor = UIColor.colorsArray[Int(plant.actionColorIndex)]

            
            if plant.needsWatering {
                waterPlantButton.setTitle(plant.mainAction, for: .normal)
                waterPlantButton.isEnabled = true
                waterPlantButton.performFlare()
            }

           
            else {
                waterPlantButton.isHidden = true
                waterPlantButton.isEnabled = false
            }
        }

      
        else {
            plantButton.setTitle(NSLocalizedString("Add Plant", comment: "Add a plant to your collection"), for: .normal)
            title = NSLocalizedString("Add New Plant", comment: "Title for Add Plant screen")
            nicknameTextField.text = ""
            speciesTextField.text = ""
            waterPlantButton.isHidden = true

        
            reminderButtonLabel.isEnabled = false

            plantButton.performFlare()
        }
    }

  
    private func addOrEditPlant() {

       
        var nickname = ""
        if let possibleNickname = nicknameTextField.text, !possibleNickname.isEmpty {
            nickname = possibleNickname
        } else {
            nickname = String.returnRandomNickname()
        }

       
        guard let species = speciesTextField.text, !species.isEmpty else {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            UIAlertController.makeSpeciesAlert(textField: speciesTextField, vc: self)
            return
        }

     
        let daysAreSelected: Bool = daySelectionView.returnDaysSelected().count > 0

       
        if !daysAreSelected {
            UIAlertController.makeDaysAlert(progressView: dayProgressView, vc: self)
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            return
        }

        
        var imageToSave: UIImage?

    
        
        if imageView.image.hashValue != UIImage(named: "plantslogoclear1024x1024").hashValue {
            imageToSave = imageView.image ?? .logoImage
        }

       
        if let existingPlant = plant {

            var emptyNotepad = NotePad()
            emptyNotepad.mainTitle = String.defaultTitleString()
            emptyNotepad.mainMessage = String.defaultMessageString(name: nickname.capitalized, action: .waterNounLocalizedString)
            if let fullNotepad = notePad {
                emptyNotepad = fullNotepad
            }

            var selectedAppearanceOptions = AppearanceOptions(plantIconIndex: existingPlant.plantIconIndex,
                                                              plantColorIndex: existingPlant.plantColorIndex,
                                                              actionIconIndex: existingPlant.actionIconIndex,
                                                              actionColorIndex: existingPlant.actionColorIndex)

           
            if let fullAppearanceOptions = appearanceOptions {
                selectedAppearanceOptions = fullAppearanceOptions
            }

            plantController?.update(nickname: nickname.capitalized,
                                   species: species.capitalized,
                                   water_schedule: datePicker.date,
                                   frequency: daySelectionView.returnDaysSelected(),
                                   scientificName: plantSearchResult?.scientificName ?? emptyNotepad.scientificName,
                                   notepad: emptyNotepad,
                                   appearanceOptions: selectedAppearanceOptions,
                                   plant: existingPlant)
           
            let imageName = "userPlant\(existingPlant.identifier!)"

            
            if let image = imageToSave {
                UIImage.saveImage(imageName: imageName, image: image)
            }
        }

    
        else {

            var emptyNotepad = NotePad(scientificName: plantSearchResult?.scientificName ?? "")
            emptyNotepad.mainTitle = String.defaultTitleString()
            emptyNotepad.mainMessage = String.defaultMessageString(name: nickname.capitalized, action: .waterNounLocalizedString)
            if let fullNotepad = notePad {
                emptyNotepad = fullNotepad
            }

            var emptyAppearanceOptions = AppearanceOptions()
            if let fullAppearanceOptions = appearanceOptions {
                emptyAppearanceOptions = fullAppearanceOptions
            }

            let plant = plantController?.createPlant(nickname: nickname.capitalized,
                                        species: species.capitalized,
                                        date: datePicker.date,
                                        frequency: daySelectionView.returnDaysSelected(),
                                        scientificName: emptyNotepad.scientificName,
                                        notepad: emptyNotepad,
                                        appearanceOptions: emptyAppearanceOptions)
            
            let imageName = "userPlant\(plant!.identifier!)"

          
            if let image = imageToSave {
                UIImage.saveImage(imageName: imageName, image: image)
            }
        }

        AudioServicesPlaySystemSound(SystemSoundID(1105))

        UINotificationFeedbackGenerator().notificationOccurred(.success)

       
        navigationController?.popViewController(animated: true)
    }

   
    @objc func refreshReminders() {
        resultsTableView.reloadData()
    }

   
    private func addTouchGestures() {

        
        let swipe = UISwipeGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        swipe.cancelsTouchesInView = false
        swipe.direction = .up
        view.addGestureRecognizer(swipe)

       
        let downSwipe = UISwipeGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        downSwipe.cancelsTouchesInView = false
        downSwipe.direction = .down
        view.addGestureRecognizer(downSwipe)

      
        let tapOnImageView = UITapGestureRecognizer(target: self, action: #selector(tappedOnImageView))
        imageView.addGestureRecognizer(tapOnImageView)
        imageView.isUserInteractionEnabled = true
    }

    
    private func presentReminderViewController() {
        guard let plant = plant else { return }

        let reminderVC = ReminderViewController()
        reminderVC.modalPresentationStyle = .automatic
        reminderVC.plantController = plantController
        reminderVC.plant = plant
        reminderVC.reminderDelegate = self
        present(reminderVC, animated: true, completion: nil)

    }



    // MARK: - Networking

    
    func handleNetworkErrors(_ error: NetworkError) {
        switch error {
        case .badAuth:
            print("badAuth in signToken")
        case .noToken:
            print("no token in searchPlants")
        case .invalidURL:
            UIAlertController.makeAlert(title: NSLocalizedString("Invalid Species", comment: ".invalidURL"),
                      message: NSLocalizedString("Please enter a valid species name", comment: "invalid URL"),
                      vc: self)
            return
        case .otherError:
            print("other error in searchPlants")
        case .noData:
            print("No data received or data corrupted")
        case .noDecode:
            print("JSON could not be decoded")
        case .invalidToken:
            print("personal token invalid when sending to get temp token url")
        case .serverDown:
            UIAlertController.makeAlert(title: NSLocalizedString("Server Maintenance", comment: "Title for Servers down temporarily"),
                      message: NSLocalizedString("Servers down for maintenance. Please try again later.", comment: "Servers down"),
                      vc: self)
            return
        default:
            print("default error in searchPlants")
        }

       
        UIAlertController.makeAlert(title: NSLocalizedString("Network Error", comment: "any network error"),
                  message: NSLocalizedString("Search feature temporarily unavailable", comment: "any network error"),
                  vc: self)
    }

    
    func performPlantSearch(_ term: String) {
        self.plantController?.searchPlantSpecies(term, completion: { (result) in

            do {
                let plantResults = try result.get()
                DispatchQueue.main.async {
                    self.plantSearchResults = plantResults
                    self.spinner.stopAnimating()
                    if plantResults.count == 0 {
                        UIAlertController.makeAlert(title: NSLocalizedString("No Results Found",
                                                                comment: "no search resutls"),
                                       message: NSLocalizedString("Please search for another species",
                                                                  comment: "try another species"),
                                       vc: self)
                    }
                }
            } catch {
                if let error = error as? NetworkError {
                    DispatchQueue.main.async {
                        print("Error searching for plants in performPlantSearch")
                        self.spinner.stopAnimating()
                        self.handleNetworkErrors(error)
                    }
                }
            }
        })
    }
}

