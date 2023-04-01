//
//  DetailViewController.swift
//  TinkoffProject
//
//  Created by Лена Гусарова on 01.04.2023.
//

import UIKit

class DetailViewController: UIViewController {
    private let imageView: UIImageView = {
        var image = UIImageView(image: UIImage(named: "plant"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    private var nameLabel: UILabel = {
        var label = UILabel.init()
        label.font = .boldSystemFont(ofSize: 25)
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        view.backgroundColor = .white
        view.addSubview(imageView)
        view.addSubview(nameLabel)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 280),
            imageView.heightAnchor.constraint(equalToConstant: 250),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),

        ])
    }
    
    func set(name: String) {
        nameLabel.text = "\(name)"
    }
}
