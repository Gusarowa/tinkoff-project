//
//  NotificationView.swift
//  Remindew
//
// Created by Лена Гусарова on 01.06.2023.
//

import Foundation
import UIKit


class NotificationView: UIView {
    
    // MARK: - Properties
    
   
    let notificationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        view.backgroundColor = .customComponentColor
        return view
    }()
    
    
    let smallIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 5
        imageView.backgroundColor = .white
        imageView.image = UIImage.smallAppIconImage
        imageView.clipsToBounds = true
        return imageView
    }()
    
 
    let appNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .light)
        label.textColor = .lightGray
        label.textAlignment = .left
        label.text = "REMINDEW"
        return label
    }()
    
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.text = NSLocalizedString("now", comment: "now text for banner")
        label.textAlignment = .right
        return label
    }()
    
    let reminderTitleTextfield: UITextField = {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.text = .defaultTitleString()
        textfield.backgroundColor = .clear
        textfield.font = .systemFont(ofSize: 14, weight: .semibold)
        textfield.contentVerticalAlignment = .bottom
        textfield.tintColor = .mixedBlueGreen
        return textfield
    }()
    
    let reminderMessageTextfield: UITextField = {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.text = ""
        textfield.font = .systemFont(ofSize: 14)
        textfield.backgroundColor = .clear
        textfield.contentVerticalAlignment = .top
        textfield.tintColor = .mixedBlueGreen
        return textfield
    }()
    
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
        
      
        addSubview(notificationView)
        notificationView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        notificationView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        notificationView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        notificationView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
      
        notificationView.addSubview(smallIconImageView)
        smallIconImageView.topAnchor.constraint(equalTo: notificationView.topAnchor, constant: 10).isActive = true
        smallIconImageView.leadingAnchor.constraint(equalTo: notificationView.leadingAnchor, constant: 12).isActive = true
        smallIconImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        smallIconImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
    
        notificationView.addSubview(appNameLabel)
        appNameLabel.centerYAnchor.constraint(equalTo: smallIconImageView.centerYAnchor).isActive = true
        appNameLabel.leadingAnchor.constraint(equalTo: smallIconImageView.trailingAnchor, constant: 8).isActive = true
        appNameLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
       
        notificationView.addSubview(timeLabel)
        timeLabel.centerYAnchor.constraint(equalTo: smallIconImageView.centerYAnchor).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: notificationView.trailingAnchor, constant: -16).isActive = true
        timeLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2).isActive = true
        
       
        notificationView.addSubview(reminderTitleTextfield)
        reminderTitleTextfield.topAnchor.constraint(equalTo: smallIconImageView.bottomAnchor, constant: 4).isActive = true
        reminderTitleTextfield.leadingAnchor.constraint(equalTo: smallIconImageView.leadingAnchor).isActive = true
        reminderTitleTextfield.trailingAnchor.constraint(equalTo: notificationView.trailingAnchor,
                                                         constant: -16).isActive = true
        
       
        notificationView.addSubview(reminderMessageTextfield)
        reminderMessageTextfield.topAnchor.constraint(equalTo: reminderTitleTextfield.bottomAnchor).isActive = true
        reminderMessageTextfield.leadingAnchor.constraint(equalTo: reminderTitleTextfield.leadingAnchor).isActive = true
        reminderMessageTextfield.trailingAnchor.constraint(equalTo: reminderTitleTextfield.trailingAnchor).isActive = true
    }
    
}
