//
//  FrequencySelectionView.swift
//  Remindew
//
//  Created by Лена Гусарова on 01.06.2023.
//

import UIKit
import Foundation

class FrequencySelectionView: UIView {
    
    // MARK: - Properties
    
    
    let everyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("Every", comment: "days label after frequency number")
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.textColor = .mixedBlueGreen
        return label
    }()
    
    
    var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .numberPad
        textField.text = "14"
        textField.backgroundColor = .clear
        textField.textAlignment = .center
        textField.textColor = .mixedBlueGreen
        textField.tintColor = .mixedBlueGreen
        return textField
    }()
        
   
    let daysLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("days", comment: "days label after frequency number")
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.textColor = .mixedBlueGreen
        return label
    }()
    
   
    var mainColor: UIColor = .mixedBlueGreen {
        didSet {
            updateColors()
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
    
    private func updateColors() {
        everyLabel.textColor = mainColor
        textField.textColor = mainColor
        textField.tintColor = mainColor
        daysLabel.textColor = mainColor
    }
    
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField.becomeFirstResponder()
    }
        
   
    private func setupSubviews() {
        
       
        backgroundColor = UIColor.customComponentColor
        layer.cornerRadius = 6
        
        addSubview(everyLabel)
        everyLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        everyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4).isActive = true
        everyLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.33).isActive = true
        everyLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
       
        addSubview(textField)
        textField.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textField.leadingAnchor.constraint(equalTo: everyLabel.trailingAnchor).isActive = true
        textField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.33).isActive = true
        textField.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
      
        addSubview(daysLabel)
        daysLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        daysLabel.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: -4).isActive = true
        daysLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        daysLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

}
