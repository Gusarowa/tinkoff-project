//
//  ReminderViewController.swift
//  Remindew
//
//  Created by Лена Гусарова on 01.06.2023.
import UIKit

protocol ReminderDelegate {
    
    
    func didAddOrUpdateReminder()
}

class ReminderViewController: UIViewController {

    // MARK: - Properties
    
    
    let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.layer.cornerRadius = 15
        contentView.backgroundColor = .customDetailBackgroundColor
        return contentView
    }()
    
   
    let lastDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("Add New Reminder", comment: "title for add reminder screen")
        label.textColor = .mixedBlueGreen
        label.backgroundColor = .customDetailBackgroundColor
        label.textAlignment = .left
        label.numberOfLines = 1
        label.contentMode = .bottom
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    
    let saveButton: UIButton = {
        let tempButton = UIButton(type: .system) // .system
        tempButton.translatesAutoresizingMaskIntoConstraints = false
        tempButton.backgroundColor = .clear
        tempButton.tintColor = .mixedBlueGreen
        tempButton.setTitle(NSLocalizedString("Save", comment: "Done button"), for: .normal)
        tempButton.titleLabel?.font = .systemFont(ofSize: 18)
        tempButton.contentHorizontalAlignment = .right
        tempButton.layer.cornerRadius = 0
        return tempButton
    }()
    
   
    let actionCustomizationView: CustomizationView = {
        let view = CustomizationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.plantNameLabel.isEnabled = true
        view.plantNameLabel.text = NSLocalizedString("Reminder", comment: "Name of reminder type")
        view.localIconCount = 1
        return view
    }()
    
   
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.preferredDatePickerStyle = .compact
        picker.tintColor = .mixedBlueGreen
        picker.backgroundColor = .clear
        return picker
    }()
    
   
    let frequencySelectorView: FrequencySelectionView = {
        let view = FrequencySelectionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let notificationBubble: NotificationView = {
        let view = NotificationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
   
    let notesTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = NSLocalizedString("Notes", comment: "placeholder for notesTextView")
        textView.font = .systemFont(ofSize: 14)
        textView.layer.cornerRadius = 15
        textView.tintColor = .mixedBlueGreen
        textView.backgroundColor = .customComponentColor
        textView.contentMode = .left
        return textView
    }()
    
   
    let standardMargin: CGFloat = 20.0
    
    var plantController: PlantController?
    
   
    var plant: Plant? {
        didSet {
            updateViews()
        }
    }
    
   
    var reminder: Reminder? {
        didSet {
            updateViews()
        }
    }
    
   
    var reminderDelegate: ReminderDelegate?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        
        actionCustomizationView.datePicker = datePicker
        actionCustomizationView.frequencySelectorView = frequencySelectorView
        updateViews()
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if reminder != nil {
            notesTextView.becomeFirstResponder()
        } else {
            actionCustomizationView.plantNameLabel.becomeFirstResponder()
        }
    }
        
   
    @objc func saveButtonTapped() {
            
        if let plant = plant {
            
            
            guard let actionName = actionCustomizationView.plantNameLabel.text, !actionName.isEmpty else {
                return
            }
            
            guard let frequencyString = frequencySelectorView.textField.text, !frequencyString.isEmpty, let frequency = Int16(frequencyString), frequency > 0 else {
                return
            }
            
        
            if let existingReminder = reminder {
                
                plantController?.editReminder(reminder: existingReminder,
                                              actionName: actionName,
                                              alarmDate: datePicker.date,
                                              frequency: frequency,
                                              actionTitle: notificationBubble.reminderTitleTextfield.text ?? "",
                                              actionMessage: notificationBubble.reminderMessageTextfield.text ?? "",
                                              notes: notesTextView.text,
                                              isEnabled: true,
                                              colorIndex: Int16(actionCustomizationView.localColorsCount),
                                              iconIndex: Int16(actionCustomizationView.localIconCount))
            }
           
            else {
                plantController?.addNewReminderToPlant(plant: plant,
                                                       actionName: actionName,
                                                       alarmDate: datePicker.date,
                                                       frequency: frequency,
                                                       actionTitle: notificationBubble.reminderTitleTextfield.text ?? "",
                                                       actionMessage: notificationBubble.reminderMessageTextfield.text ?? "",
                                                       notes: notesTextView.text,
                                                       isEnabled: true,
                                                       colorIndex: Int16(actionCustomizationView.localColorsCount),
                                                       iconIndex: Int16(actionCustomizationView.localIconCount))
            }
        }
        
      
        reminderDelegate?.didAddOrUpdateReminder()
        dismiss(animated: true, completion: nil)
    }
    
    
    private func setupSubviews() {
                
        view.backgroundColor = .customDetailBackgroundColor
        
       
        view.addSubview(contentView)
        contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: standardMargin).isActive = true
        contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: standardMargin).isActive = true
        contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -standardMargin).isActive = true
        contentView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: CGFloat(0.55)).isActive = true
        
       
        contentView.addSubview(saveButton)
        saveButton.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        saveButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: CGFloat(0.2)).isActive = true
        saveButton.heightAnchor.constraint(equalTo: saveButton.widthAnchor, multiplier: 0.5).isActive = true
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
       
        contentView.addSubview(lastDateLabel)
        lastDateLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        lastDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        lastDateLabel.trailingAnchor.constraint(equalTo: saveButton.leadingAnchor).isActive = true
        lastDateLabel.heightAnchor.constraint(equalTo: saveButton.heightAnchor).isActive = true
        
       
        contentView.addSubview(actionCustomizationView)
        actionCustomizationView.topAnchor.constraint(equalTo: lastDateLabel.bottomAnchor).isActive = true
        actionCustomizationView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        actionCustomizationView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        actionCustomizationView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        
        contentView.addSubview(datePicker)
        datePicker.topAnchor.constraint(equalTo: actionCustomizationView.bottomAnchor, constant: 4).isActive = true
        datePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        datePicker.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6).isActive = true
        
      
        contentView.addSubview(frequencySelectorView)
        frequencySelectorView.topAnchor.constraint(equalTo: actionCustomizationView.bottomAnchor, constant: 4).isActive = true
        frequencySelectorView.leadingAnchor.constraint(equalTo: datePicker.trailingAnchor, constant: 3).isActive = true
        frequencySelectorView.trailingAnchor.constraint(equalTo: actionCustomizationView.trailingAnchor).isActive = true
        frequencySelectorView.centerYAnchor.constraint(equalTo: datePicker.centerYAnchor).isActive = true
        frequencySelectorView.heightAnchor.constraint(equalToConstant: 30).isActive = true
                
       
        contentView.addSubview(notificationBubble)
        notificationBubble.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 8).isActive = true
        notificationBubble.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        notificationBubble.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        notificationBubble.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        
        contentView.addSubview(notesTextView)
        notesTextView.topAnchor.constraint(equalTo: notificationBubble.bottomAnchor, constant: 8).isActive = true
        notesTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        notesTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        notesTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    private func updateViews() {
        
        guard isViewLoaded, let plant = plant else { return }
                        
        
        if let reminder = reminder {
            actionCustomizationView.plantNameLabel.text = reminder.actionName
            notificationBubble.reminderTitleTextfield.text = reminder.actionTitle
            notificationBubble.reminderMessageTextfield.text = reminder.actionMessage
            datePicker.date = reminder.alarmDate!// ?? Date()
            frequencySelectorView.textField.text = "\(reminder.frequency)"
            notesTextView.text = reminder.notes
            
            let reminderColor = UIColor.colorsArray[Int(reminder.colorIndex)]
            actionCustomizationView.localColorsCount = Int(reminder.colorIndex)
            actionCustomizationView.localIconCount = Int(reminder.iconIndex)
            frequencySelectorView.mainColor = reminderColor
            datePicker.tintColor = reminderColor

           
            if let lastDate = reminder.lastDate {
                lastDateLabel.text = NSLocalizedString("Last: ", comment: "last time watered") + "\(DateFormatter.lastWateredDateFormatter.string(from: lastDate))"
            } else {
                lastDateLabel.text = NSLocalizedString("Made: ", comment: "date created label") +
                    "\(DateFormatter.lastWateredDateFormatter.string(from: reminder.dateCreated!))"
            }
        }
        
       
        else {
            notificationBubble.reminderMessageTextfield.text = .defaultMessageString(name: plant.nickname!,
                                                                                     action: NSLocalizedString("Reminder", comment: ""))
        }
    }
}
