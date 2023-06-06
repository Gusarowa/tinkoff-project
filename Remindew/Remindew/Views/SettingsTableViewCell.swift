//
//  SettingsTableViewCell.swift
//  Remindew
//
//Created by Лена Гусарова on 01.06.2023.

import UIKit

struct CustomSetting {
    var settingKey: String
}

class SettingsTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
   
    let colorChangeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.tintColor = UIColor.colorsArray[0]
        button.setImage(UIImage(systemName: "paintbrush.fill"), for: .normal)
        return button
    }()
    
    
    var colorIndex: Int = 0 {
        didSet {
            if colorIndex >= UIColor.colorsArray.count {
                colorIndex = 0
            }
            updateColors()
        }
    }
    
    
    var customSetting: String?
    
  
    var optionSwitch: UISwitch!
    
   
    var settingLabel: UILabel!
    
   
    var standardMargin: CGFloat = CGFloat(20.0)
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpSubviews()
    }
    
    
    @objc func optionChanged(_ sender: UISwitch) {
        
        
        guard let setting = customSetting else { return }
        switch setting {
        
        case .resultFillsSpeciesTextfield:
            UserDefaults.standard.set(optionSwitch.isOn, forKey: .resultFillsSpeciesTextfield)
            
        case .darkThemeOn:
            UserDefaults.standard.set(optionSwitch.isOn, forKey: .darkThemeOn)
            UIColor().updateToDarkOrLightTheme()
            
        case .usePlantImages:
            UserDefaults.standard.set(optionSwitch.isOn, forKey: .usePlantImages)
            
            NotificationCenter.default.post(name: .checkWateringStatus, object: self)
            
        case .usePlantColorOnLabel:
            UserDefaults.standard.set(optionSwitch.isOn, forKey: .usePlantColorOnLabel)
          
            NotificationCenter.default.post(name: .checkWateringStatus, object: self)
                        
        case .hideSilencedIcon:
            UserDefaults.standard.set(optionSwitch.isOn, forKey: .hideSilencedIcon)
            
            NotificationCenter.default.post(name: .checkWateringStatus, object: self)
            
        case .sortPlantsBySpecies:
            UserDefaults.standard.set(optionSwitch.isOn, forKey: .sortPlantsBySpecies)
         
            NotificationCenter.default.post(name: .updateSortDescriptors, object: self)
            
        case .useBiggerImages:
            
            UserDefaults.standard.set(optionSwitch.isOn, forKey: .useBiggerImages)
            NotificationCenter.default.post(name: .updateImageSizes, object: self)
            
        default:
            break
        }
    }
    
   
    private func setUpSubviews() {
    
        contentView.backgroundColor = UIColor.customCellColor
        
        
        let label = UILabel()
        contentView.addSubview(label)
        self.settingLabel = label
        settingLabel.translatesAutoresizingMaskIntoConstraints = false
        settingLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        settingLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                            constant: 20).isActive = true
        settingLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: CGFloat(0.7)).isActive = true
        settingLabel.font = .systemFont(ofSize: 16)
        
        
        let option = UISwitch()
        contentView.addSubview(option)
        self.optionSwitch = option
        optionSwitch.translatesAutoresizingMaskIntoConstraints = false
        optionSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -standardMargin).isActive = true
        optionSwitch.centerYAnchor.constraint(equalTo: settingLabel.centerYAnchor).isActive = true
        optionSwitch.addTarget(self, action: #selector(optionChanged), for: .valueChanged)
        optionSwitch.isHidden = true
        
      
        contentView.addSubview(colorChangeButton)
        colorChangeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -standardMargin).isActive = true
        colorChangeButton.centerYAnchor.constraint(equalTo: settingLabel.centerYAnchor).isActive = true
        colorChangeButton.addTarget(self, action: #selector(changeColor), for: .touchUpInside)
        colorChangeButton.isHidden = true
    }
    
    
    @objc private func changeColor() {

        colorIndex += 1
       
        NotificationCenter.default.post(name: .updateMainColor, object: self)
    }
    
 
    private func updateColors() {
        
       
        colorChangeButton.tintColor = UIColor.colorsArray[colorIndex]
        
        settingLabel.textColor = UIColor.colorsArray[colorIndex]
        
        
        UserDefaults.standard.set(colorIndex, forKey: .mainNavThemeColor)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpSubviews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
