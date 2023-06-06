//
//  SettingsPageViewController.swift
//  Remindew
//
//  Created by Лена Гусарова on 01.06.2023.



import UIKit

class SettingsPageViewController: UIViewController {
    
    // MARK: - Properties
    
    private var tableView: UITableView!
    public var totalPlantCount = 0
    public var totalLocationsCount = 0
    private var stats: String {
        return "\n\n" + NSLocalizedString("Version ", comment: "version") + "\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")" + " - " + NSLocalizedString("Plants", comment: "plants") + ": \(totalPlantCount), " + NSLocalizedString("Locations", comment: "locations") + ": \(totalLocationsCount)"
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        registerTableViewCells()
        configureTableView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(dismissSettingsPage), name: .checkWateringStatus, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dismissSettingsPage), name: .updateSortDescriptors, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dismissSettingsPage), name: .updateImageSizes, object: nil)
    }
    
    // MARK: - UI Setup
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func registerTableViewCells() {
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: "SettingCell")
    }
    
    private func configureTableView() {
        tableView.backgroundColor = UIColor.customBackgroundColor
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Actions
    
    @IBAction func clearDismissButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissSettingsPage() {
        dismiss(animated: true, completion: nil)
    }
}

extension SettingsPageViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 3:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return NSLocalizedString("APPEARANCE", comment: "appearance section title")
        case 3:
            return NSLocalizedString("NAVIGATION BAR", comment: "main nav theme section title")
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 0:
            return .appearanceSectionLocalizedDescription
        case 3:
            return .navigationBarSettingLocalizedString + stats
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 42
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let settingCell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as? SettingsTableViewCell else { return UITableViewCell() }
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                settingCell.settingLabel.text = NSLocalizedString("Dark Theme", comment: "dark mode setting")
                settingCell.optionSwitch.isHidden = false
                settingCell.colorChangeButton.isHidden = true
                settingCell.customSetting = .darkThemeOn
                settingCell.optionSwitch.isOn = UserDefaults.standard.bool(forKey: .darkThemeOn)
                settingCell.settingLabel.textColor = .label
            } else if indexPath.row == 1 {
                settingCell.settingLabel.text = NSLocalizedString("Images Instead of Icons", comment: "images instead of icons setting")
                settingCell.optionSwitch.isHidden = false
                settingCell.colorChangeButton.isHidden = true
                settingCell.customSetting = .usePlantImages
                settingCell.optionSwitch.isOn = UserDefaults.standard.bool(forKey: .usePlantImages)
                settingCell.settingLabel.textColor = .label
            }
        case 3:
            settingCell.settingLabel.text = NSLocalizedString("Main Color", comment: "main color setting label")
            settingCell.colorIndex = UserDefaults.standard.integer(forKey: .mainNavThemeColor)
            settingCell.optionSwitch.isHidden = true
            settingCell.colorChangeButton.isHidden = false
        default:
            break
        }
        
        return settingCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
            
        

