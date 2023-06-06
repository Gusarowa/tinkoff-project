//
//  ReminderTableViewCell.swift
//  Remindew
//
//  Created by Лена Гусарова on 01.06.2023.
//

import UIKit

class ReminderTableViewCell: UITableViewCell {
    
   
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .customDetailBackgroundColor
        return view
    }()
    
    
    let reminderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 25)
        label.textColor = .systemPurple
        return label
    }()
    
   
    let progressView: UIProgressView = {
        let progress = UIProgressView()
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.tintColor = .mintGreen
        progress.progress = 0.5
        return progress
    }()
    
    
    let alarmDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 17)
        label.textColor = .lightGray
        return label
    }()
    
    
    let timeLeftLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    
    let completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage.iconArray[0], for: .normal)
        return button
    }()
    

    var standardMargin: CGFloat = CGFloat(8.0)
    
   
    var reminder: Reminder? {
        didSet {
            updateViews()
        }
    }
    
   
    var reminderDelegate: ReminderDelegate?
    
    
    var plantController: PlantController?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpSubviews()
    }
    
    private func updateViews() {
        
        guard let reminder = reminder else { return }
        reminderLabel.text = reminder.actionName
        alarmDateLabel.text = DateFormatter.dateOnlyDateFormatter.string(from: reminder.alarmDate ?? Date())
        
        completeButton.setImage(UIImage.iconArray[Int(reminder.iconIndex)], for: .normal)
        completeButton.tintColor = UIColor.colorsArray[Int(reminder.colorIndex)]
                
        reminderLabel.textColor = reminder.isEnabled ? UIColor.colorsArray[Int(reminder.colorIndex)] : .lightGray
        progressView.progressTintColor = reminder.isEnabled ? UIColor.colorsArray[Int(reminder.colorIndex)] : .lightGray
        
        updateProgressView(reminder: reminder)
    }
    
   
    func updateProgressView(reminder: Reminder) {
        
       
        completeButton.isHidden = true
        
     
        var totalProgress = reminder.alarmDate!.timeIntervalSince(reminder.dateCreated!) / 86400.0
        let daysLeft = reminder.alarmDate!.timeIntervalSinceNow / 86400.0
        
        timeLeftLabel.text = "\(Int(daysLeft))" + NSLocalizedString(" days left", comment: "x days are left")
        if Int(daysLeft) == 1 {
            timeLeftLabel.text = "\(Int(daysLeft))" + NSLocalizedString(" day left", comment: "1 day left")
        }
        
      
        if let lastDate = reminder.lastDate {
            totalProgress = reminder.alarmDate!.timeIntervalSince(lastDate) / 86400.0
        }
        
      
        progressView.progress = Float((totalProgress - daysLeft) / totalProgress)
        
       
        if daysLeft < 1 {
            
            let currentDayComps = Calendar.current.dateComponents([.day], from: Date())
            let currentDay = currentDayComps.day!
            
            let reminderDayComps = Calendar.current.dateComponents([.day], from: reminder.alarmDate!)
            let alarmDateDay = reminderDayComps.day!
            
            let todayString = NSLocalizedString("Today", comment: "today")
            let tomorrowString = NSLocalizedString("Tomorrow", comment: "tomorrow")
            
            alarmDateLabel.text = currentDay == alarmDateDay ? todayString : tomorrowString
            timeLeftLabel.text = NSLocalizedString("at ", comment: "at ") + "\(DateFormatter.timeOnlyDateFormatter.string(from: reminder.alarmDate!))"
            
           
            if daysLeft <= 0 {
                alarmDateLabel.text = NSLocalizedString("Tap button", comment: "tap on complete button")
                timeLeftLabel.text = NSLocalizedString("to complete", comment: "to complete")
                progressView.progress = 1.0
                completeButton.isHidden = false
            } else {
                completeButton.isHidden = true
            }
        }
    }
    
  
    @objc private func completeButtonTapped() {
        
        guard let reminder = reminder else { return }
        
        completeButton.isHidden = true
        
        
        plantController?.updateReminderDates(reminder: reminder)
        
        
        updateViews()
        reminderDelegate?.didAddOrUpdateReminder()
    }
    
    
    private func setUpSubviews() {
        
      
        addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
      
        containerView.addSubview(completeButton)
        completeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        completeButton.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        completeButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        completeButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.15).isActive = true
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        completeButton.isHidden = true
        
       
        containerView.addSubview(reminderLabel)
        reminderLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        reminderLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8).isActive = true
        reminderLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.45).isActive = true
        
       
        containerView.addSubview(progressView)
        progressView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        progressView.topAnchor.constraint(equalTo: reminderLabel.bottomAnchor, constant: 4).isActive = true
        progressView.widthAnchor.constraint(equalTo: reminderLabel.widthAnchor).isActive = true
        
        
        containerView.addSubview(alarmDateLabel)
        alarmDateLabel.topAnchor.constraint(equalTo: reminderLabel.topAnchor).isActive = true
        alarmDateLabel.bottomAnchor.constraint(equalTo: reminderLabel.bottomAnchor).isActive = true
        alarmDateLabel.leadingAnchor.constraint(equalTo: reminderLabel.trailingAnchor, constant: 16).isActive = true
        alarmDateLabel.trailingAnchor.constraint(equalTo: completeButton.leadingAnchor).isActive = true
        
        
        containerView.addSubview(timeLeftLabel)
        timeLeftLabel.bottomAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 4).isActive = true
        timeLeftLabel.leadingAnchor.constraint(equalTo: alarmDateLabel.leadingAnchor).isActive = true
        timeLeftLabel.widthAnchor.constraint(equalTo: alarmDateLabel.widthAnchor).isActive = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpSubviews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
