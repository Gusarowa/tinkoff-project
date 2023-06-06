//
//  DaySelectionView.swift
//  Remindew
//
//  Created by Лена Гусарова on 01.06.2023.

import UIKit
import AVFoundation

class DaySelectionView: UIStackView {

    // MARK: - Properties
    
    var buttonArray = [UIButton]()
    let selectedFont: UIFont = UIFont.boldSystemFont(ofSize: 20.0)
    let unselectedFont: UIFont = UIFont.systemFont(ofSize: 15, weight: .regular)

    // MARK: - View Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    @objc private func selectDay(_ button: UIButton) {
        
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
       
        if button.tintColor == .secondaryLabel {
            button.tintColor = UIColor.customSelectedDayColor//.darkGray
            button.titleLabel?.font = selectedFont
        }
       
        else {
            button.tintColor = .secondaryLabel
            button.titleLabel?.font = unselectedFont
        }
    }
    
    private func setupSubviews() {
        
        distribution = .fillEqually
        self.spacing = 4
        for integer in 0..<String.dayInitials.count {
            let day = UIButton(type: .system)
            day.translatesAutoresizingMaskIntoConstraints = false
            addArrangedSubview(day)
            buttonArray.append(day)
            day.tag = integer + 1
            day.contentMode = .scaleToFill
            day.setTitle("\(String.dayInitials[integer])", for: .normal)
            day.backgroundColor = .clear
            
            day.tintColor = .secondaryLabel
            
            day.addTarget(self, action: #selector(selectDay), for: .touchUpInside)
            
            day.layer.cornerRadius = 13.0
        }
    }
    
   
    func selectDays(_ daysToSelect: [Int16]) {
        
        for day in daysToSelect {
            let index = Int(day) - 1
           
            if buttonArray[index].tintColor == .secondaryLabel {
                buttonArray[index].tintColor = UIColor.customSelectedDayColor//.darkGray
                buttonArray[index].titleLabel?.font = selectedFont
            }
        }
    }
 
    private func resetDays() {
        for button in buttonArray {
            button.tintColor = .secondaryLabel
            button.titleLabel?.font = unselectedFont
        }
    }
    
 
    func returnDaysSelected() -> [Int16] {
        
        var result = [Int16]()
        
        for button in buttonArray {
            if button.tintColor == UIColor.customSelectedDayColor {
                result.append(Int16(button.tag))
            }
        }
        return result
    }
}
