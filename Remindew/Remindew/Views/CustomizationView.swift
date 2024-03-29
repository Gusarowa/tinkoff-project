//
//  CustomizationView.swift
//  Remindew
//
//  Created by Лена Гусарова on 01.06.2023.

import Foundation
import UIKit

class CustomizationView: UIView {
    
    // MARK: - Properties
    
    var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .customComponentColor
        view.layer.cornerRadius = 15
        return view
    }()
    
    var plantNameLabel: UITextField = {
        let label = UITextField()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.colorsArray[0]
        label.tintColor = UIColor.colorsArray[0]
        label.text = "Name"
        label.font = .boldSystemFont(ofSize: 25)
        label.isEnabled = false
        label.autocorrectionType = .no
        label.textAlignment = .center
        return label
    }()
    
    var iconImageButton: UIButton = {
        let imageView = UIButton(type: .system)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.tintColor = UIColor.colorsArray[0]
        imageView.setImage(UIImage.iconArray[0], for: .normal)
        return imageView
    }()
    
    let colorChangeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.tintColor = UIColor.colorsArray[0]
        button.setImage(UIImage(systemName: "paintbrush.fill"), for: .normal)
        return button
    }()
   
    let standardPadding: CGFloat = 8
   
    weak var datePicker: UIDatePicker?
    weak var frequencySelectorView: FrequencySelectionView?
    
    var localColorsCount = 0 {
        
        didSet {
            
            if localColorsCount == UIColor.colorsArray.count {
                localColorsCount = 0
            }
            
            plantNameLabel.textColor = UIColor.colorsArray[localColorsCount]
            plantNameLabel.tintColor = UIColor.colorsArray[localColorsCount]
            iconImageButton.tintColor = UIColor.colorsArray[localColorsCount]
            colorChangeButton.tintColor = UIColor.colorsArray[localColorsCount]
        }
    }
    
    var localIconCount = 0 {
        
        didSet {
            
            if localIconCount == UIImage.iconArray.count {
                localIconCount = 0
            }
            
            iconImageButton.tintColor = UIColor.colorsArray[localColorsCount]
            iconImageButton.setImage(UIImage.iconArray[localIconCount], for: .normal)
            
        }
    }
    
    // MARK: - View Life Cycle
    
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    private func setupSubviews() {
        
        backgroundColor = .customDetailBackgroundColor
        
      
        addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: topAnchor, constant: standardPadding/2).isActive = true
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -standardPadding/2).isActive = true
        
        
        containerView.addSubview(iconImageButton)
        iconImageButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: standardPadding).isActive = true
        iconImageButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        iconImageButton.widthAnchor.constraint(equalTo: iconImageButton.heightAnchor).isActive = true
        iconImageButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        iconImageButton.addTarget(self, action: #selector(changeIcon), for: .touchUpInside)

       
        containerView.addSubview(colorChangeButton)
        colorChangeButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        colorChangeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -standardPadding).isActive = true
        colorChangeButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        colorChangeButton.widthAnchor.constraint(equalTo: colorChangeButton.heightAnchor).isActive = true
        colorChangeButton.addTarget(self, action: #selector(changeColor), for: .touchUpInside)
        
     
        containerView.addSubview(plantNameLabel)
        plantNameLabel.leadingAnchor.constraint(equalTo: iconImageButton.trailingAnchor, constant: standardPadding).isActive = true
        plantNameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        plantNameLabel.trailingAnchor.constraint(equalTo: colorChangeButton.leadingAnchor, constant: -standardPadding).isActive = true
        plantNameLabel.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: CGFloat(0.5)).isActive = true
    }
    
    @objc private func changeColor() {
        
        localColorsCount += 1

        
        applyColorsToDatePickerAndSwitch()
    }
    
    @objc private func changeIcon() {
        localIconCount += 1
    }
    
    func applyColorsToDatePickerAndSwitch() {
        guard let datePicker = datePicker, let frequencySelectorView = frequencySelectorView else { return }
        datePicker.tintColor = UIColor.colorsArray[localColorsCount]
        frequencySelectorView.mainColor = UIColor.colorsArray[localColorsCount]
    }
}
