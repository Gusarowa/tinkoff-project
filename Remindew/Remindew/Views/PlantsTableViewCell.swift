//
//  PlantsTableViewCell.swift
//  Remindew
//
//  Created by Лена Гусарова on 01.06.2023.
//

import UIKit

class PlantsTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
   
    var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .customCellColor
        view.layer.cornerRadius = 15
        return view
    }()
    
  
    var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 23)
        label.textColor = .customTimeLabelColor
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
   
    var plantIconButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        return button
    }()
    
  
    var userPlantImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage.defaultImage
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
        imageView.isUserInteractionEnabled = false
        imageView.backgroundColor = .black
        return imageView
    }()
    
    
    var reminderButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        return button
    }()
    
    
    var silencedButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        button.setImage(UIImage(systemName: "moon.fill"), for: .normal)
        button.tintColor = .systemGray3
        return button
    }()
    
   
    var nicknameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 25)
        label.numberOfLines = 1
        return label
    }()
        
  
    var speciesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .customTimeLabelColor
        label.font = .systemFont(ofSize: 17.0)
        label.numberOfLines = 1
        return label
    }()
    
    
    var daysLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .italicSystemFont(ofSize: 17)
        label.textColor = .systemGray2
        label.numberOfLines = 1
        return label
    }()
    
   
    var standardMargin: CGFloat = CGFloat(16.0)
    
    
    var plant: Plant? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: Constraints
    
    var timeLabelTop: NSLayoutConstraint?
    var timeLabelWidth: NSLayoutConstraint?
    var timeLabelHeight: NSLayoutConstraint?
    var timeLabelTrail: NSLayoutConstraint?
    var timeLabelBottom: NSLayoutConstraint?

    var plantIconTop: NSLayoutConstraint?
    var plantIconBottom: NSLayoutConstraint?
    var plantIconWidth: NSLayoutConstraint?
    var plantIconCenterX: NSLayoutConstraint?

    var reminderLead: NSLayoutConstraint?
    var reminderCenterY: NSLayoutConstraint?
    var reminderWidth: NSLayoutConstraint?
    var reminderHeight: NSLayoutConstraint?
    var reminderTop: NSLayoutConstraint?
    
    var silencedTrail: NSLayoutConstraint?
    var silencedCenterY: NSLayoutConstraint?
    var silencedWidth: NSLayoutConstraint?
    var silencedHeight: NSLayoutConstraint?
    
    var plantImageHeight: NSLayoutConstraint?
    var plantImageWidth: NSLayoutConstraint?
    var plantImageCenterX: NSLayoutConstraint?
    var plantImageCenterY: NSLayoutConstraint?

    // MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateSubviews),
                                               name: .updateImageSizes,
                                               object: nil)
        setUpSubviews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
   
    @objc func updateSubviews() {
        
       
        if UserDefaults.standard.bool(forKey: .useBiggerImages) {
            setupSubviewsBigImage()
        } else {
            setupSubviewsSmallImage()
        }
    }
    
   
    func deactivateRightViewContraints() {
                        
        
        guard timeLabelWidth != nil else { return }
        
        NSLayoutConstraint.deactivate([timeLabelWidth!, timeLabelHeight!, timeLabelTrail!,
                                     plantIconTop!, plantIconBottom!, plantIconWidth!, plantIconCenterX!,
                                     reminderLead!, reminderWidth!, reminderHeight!,
                                     silencedTrail!, silencedCenterY!, silencedWidth!, silencedHeight!,
                                     plantImageHeight!, plantImageWidth!, plantImageCenterX!, plantImageCenterY!])
        
       
        timeLabelTop?.isActive = false
        timeLabelBottom?.isActive = false
        reminderTop?.isActive = false
        reminderCenterY?.isActive = false
    }
    
   
    func setupSubviewsBigImage() {
        
        deactivateRightViewContraints()
        
      
        timeLabelBottom = timeLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -standardMargin)
        timeLabelWidth = timeLabel.widthAnchor.constraint(equalToConstant: 90)
        timeLabelHeight = timeLabel.heightAnchor.constraint(equalToConstant: 22.15)
        timeLabelTrail = timeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        timeLabel.font = .systemFont(ofSize: 17)
        timeLabel.textColor = .customTimeLabelColor
        
        
        plantIconBottom = plantIconButton.bottomAnchor.constraint(equalTo: timeLabel.topAnchor)
        plantIconTop = plantIconButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: standardMargin)
        plantIconWidth = plantIconButton.widthAnchor.constraint(equalTo: plantIconButton.heightAnchor)
        plantIconCenterX = plantIconButton.centerXAnchor.constraint(equalTo: timeLabel.centerXAnchor)
        
      
        plantImageHeight = userPlantImageView.heightAnchor.constraint(equalTo: plantIconButton.heightAnchor, multiplier: 0.9)
        plantImageWidth = userPlantImageView.widthAnchor.constraint(equalTo: userPlantImageView.heightAnchor)
        plantImageCenterX = userPlantImageView.centerXAnchor.constraint(equalTo: timeLabel.centerXAnchor)
        plantImageCenterY = userPlantImageView.centerYAnchor.constraint(equalTo: plantIconButton.centerYAnchor)
        userPlantImageView.layer.cornerRadius = 24.6825
        
        
        reminderLead = reminderButton.leadingAnchor.constraint(equalTo: plantIconButton.trailingAnchor, constant: -6)
        reminderTop = reminderButton.topAnchor.constraint(equalTo: plantIconButton.topAnchor, constant: 2)
        reminderWidth = reminderButton.widthAnchor.constraint(equalToConstant: 14.619)
        reminderHeight = reminderButton.heightAnchor.constraint(equalTo: reminderButton.widthAnchor)
        
      
        silencedTrail = silencedButton.trailingAnchor.constraint(equalTo: timeLabel.leadingAnchor)
        silencedCenterY = silencedButton.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor)
        silencedWidth = silencedButton.widthAnchor.constraint(equalToConstant: 11.075)
        silencedHeight = silencedButton.heightAnchor.constraint(equalTo: silencedButton.widthAnchor)
            
       
        NSLayoutConstraint.activate([timeLabelBottom!, timeLabelWidth!, timeLabelHeight!, timeLabelTrail!,
                                     plantIconBottom!, plantIconTop!, plantIconWidth!, plantIconCenterX!,
                                     plantImageHeight!, plantImageWidth!, plantImageCenterX!, plantImageCenterY!,
                                     reminderLead!, reminderTop!, reminderWidth!, reminderHeight!,
                                     silencedTrail!, silencedCenterY!, silencedWidth!, silencedHeight!])
    }
    
   
    func setupSubviewsSmallImage() {
       
        deactivateRightViewContraints()
    
        
        timeLabelTop = timeLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: standardMargin)
        timeLabelWidth = timeLabel.widthAnchor.constraint(equalToConstant: 116)
        timeLabelHeight = timeLabel.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.3)
        timeLabelTrail = timeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        timeLabel.font = .boldSystemFont(ofSize: 23)
        timeLabel.textColor = .customTimeLabelColor
        
       
        plantIconTop = plantIconButton.topAnchor.constraint(equalTo: timeLabel.bottomAnchor)
        plantIconBottom = plantIconButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        plantIconWidth = plantIconButton.widthAnchor.constraint(equalTo: plantIconButton.heightAnchor)
        plantIconCenterX = plantIconButton.centerXAnchor.constraint(equalTo: timeLabel.centerXAnchor)
        
       
        reminderLead = reminderButton.leadingAnchor.constraint(equalTo: plantIconButton.trailingAnchor, constant: 8)
        reminderCenterY = reminderButton.centerYAnchor.constraint(equalTo: plantIconButton.centerYAnchor)
        reminderWidth = reminderButton.widthAnchor.constraint(equalToConstant: 14.619)
        reminderHeight = reminderButton.heightAnchor.constraint(equalTo: reminderButton.widthAnchor)
        
       
        silencedTrail = silencedButton.trailingAnchor.constraint(equalTo: plantIconButton.leadingAnchor, constant: -8)
        silencedCenterY = silencedButton.centerYAnchor.constraint(equalTo: plantIconButton.centerYAnchor)
        silencedWidth = silencedButton.widthAnchor.constraint(equalToConstant: 14.619)
        silencedHeight = silencedButton.heightAnchor.constraint(equalTo: silencedButton.widthAnchor)
        
        plantImageHeight = userPlantImageView.heightAnchor.constraint(equalTo: plantIconButton.heightAnchor, multiplier: 0.9)
        plantImageWidth = userPlantImageView.widthAnchor.constraint(equalTo: userPlantImageView.heightAnchor)
        plantImageCenterX = userPlantImageView.centerXAnchor.constraint(equalTo: timeLabel.centerXAnchor)
        plantImageCenterY = userPlantImageView.centerYAnchor.constraint(equalTo: plantIconButton.centerYAnchor)
        userPlantImageView.layer.cornerRadius = 20
        
        
        NSLayoutConstraint.activate([timeLabelTop!, timeLabelWidth!, timeLabelHeight!, timeLabelTrail!,
                                     plantIconTop!, plantIconBottom!, plantIconWidth!, plantIconCenterX!,
                                     reminderLead!, reminderCenterY!, reminderWidth!, reminderHeight!,
                                     silencedTrail!, silencedCenterY!, silencedWidth!, silencedHeight!,
                                     plantImageHeight!, plantImageWidth!, plantImageCenterX!, plantImageCenterY!])

    }
    
   
    private func setUpSubviews() {
        contentView.backgroundColor = .customBackgroundColor
        
       
        addSubview(containerView)
        
        containerView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CGFloat(20.0)).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: CGFloat(-20.0)).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: CGFloat(-8.0)).isActive = true
        
       
        containerView.addSubview(nicknameLabel)
        nicknameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: standardMargin).isActive = true
        nicknameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: standardMargin).isActive = true
        nicknameLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.6).isActive = true
        nicknameLabel.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.3).isActive = true
        
       
        containerView.addSubview(speciesLabel)
        speciesLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor).isActive = true
        speciesLabel.leadingAnchor.constraint(equalTo: nicknameLabel.leadingAnchor).isActive = true
        speciesLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.6).isActive = true
        speciesLabel.heightAnchor.constraint(equalToConstant: 22.15).isActive = true
        
        
        containerView.addSubview(daysLabel)
        daysLabel.topAnchor.constraint(equalTo: speciesLabel.bottomAnchor).isActive = true
        daysLabel.leadingAnchor.constraint(equalTo: nicknameLabel.leadingAnchor).isActive = true
        daysLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.6).isActive = true
        daysLabel.heightAnchor.constraint(equalToConstant: 22.15).isActive = true
                
        
        containerView.addSubview(timeLabel)
        containerView.addSubview(plantIconButton)
        containerView.addSubview(reminderButton)
        containerView.addSubview(silencedButton)
        containerView.addSubview(userPlantImageView)
        
       
        updateSubviews()
    }
    
   
    private func updateViews() {
        
        guard let plant = plant else { return }
        guard let nickname = plant.nickname, let species = plant.species else { return }
        updateLabels(plant: plant, nickname: nickname, species: species)
        
       
        updatePlantImageOrIcon(plant: plant)
        
       
        updateStatusButtons(plant: plant)
    }
    
    
    private func updateLabels(plant: Plant, nickname: String, species: String) {
        if UserDefaults.standard.bool(forKey: .usePlantColorOnLabel) {
            nicknameLabel.textColor = UIColor.colorsArray[Int(plant.plantColorIndex)]
        } else {
            nicknameLabel.textColor = .mixedBlueGreen
        }
                        
       
        if UserDefaults.standard.bool(forKey: .sortPlantsBySpecies) {
            nicknameLabel.text = nickname
            speciesLabel.text = species
            
        } else {
            nicknameLabel.text = nickname
            speciesLabel.text = species
            print(nickname)
            print(species)
        }
        
        timeLabel.text = "\(DateFormatter.timeOnlyDateFormatter.string(from: plant.water_schedule!))"
        daysLabel.text = "\(returnDaysString(plant: plant))"
    }
    
   
    private func updatePlantImageOrIcon(plant: Plant) {
        
      
        if UserDefaults.standard.bool(forKey: .usePlantImages) {
            
            userPlantImageView.isHidden = false
            plantIconButton.isHidden = true
            userPlantImageView.image = UIImage.loadImageFromDiskWith(fileName: "userPlant\(plant.identifier!)")
        } else {
           
            plantIconButton.isHidden = false
            plantIconButton.setImage(UIImage.iconArray[Int(plant.plantIconIndex)], for: .normal)
            plantIconButton.tintColor = UIColor.colorsArray[Int(plant.plantColorIndex)]
            userPlantImageView.isHidden = true
        }
    }
    
    
    private func updateStatusButtons(plant: Plant) {
        
        
        if UserDefaults.standard.bool(forKey: .hideSilencedIcon) {
            silencedButton.isHidden = true
        } else {
            silencedButton.isHidden = plant.isEnabled ? true : false
        }
        
        
        reminderButton.isHidden = false
        
        
        if plant.needsWatering {
            reminderButton.setImage(UIImage.iconArray[Int(plant.actionIconIndex)], for: .normal)
            reminderButton.tintColor = UIColor.colorsArray[Int(plant.actionColorIndex)]
            return
        }
       
        if let reminder = plant.checkPlantsReminders() {
            reminderButton.setImage(UIImage.iconArray[Int(reminder.iconIndex)], for: .normal)
            reminderButton.tintColor = UIColor.colorsArray[Int(reminder.colorIndex)]
            return
        }
        
       
        reminderButton.isHidden = true
    }
    
   
    func returnDaysString(plant: Plant) -> String {
        
        let resultMap = plant.frequency!.map { "\(String.dayInitials[Int($0 - 1)])" }
            
        if resultMap.count == 7 {
            return NSLocalizedString("Every day", comment: "Every day as in all 7 days are selected")
        }
        
        return resultMap.joined(separator: " ")
    }
}
