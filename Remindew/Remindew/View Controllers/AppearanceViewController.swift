//
//  AppearanceViewController.swift
//  Remindew
//
//  Created by Лена Гусарова on 01.06.2023.

import UIKit
import AVFoundation

protocol AppearanceDelegate {
    func didSelectAppearanceObjects(image: UIImage?)
    func didSelectColorsAndIcons(appearanceOptions: AppearanceOptions)
}

class AppearanceViewController: UIViewController {
    
    // MARK: - Properties
    
    let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .systemGroupedBackground
        contentView.layer.cornerRadius = 15
        return contentView
    }()
    
   
    let notchView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .tertiaryLabel
        view.layer.cornerRadius = 2
        return view
    }()
    
    
    let blurredImageView: UIImageView = {
        let backgroundView = UIImageView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.image = .defaultImage
        backgroundView.contentMode = .scaleToFill
        return backgroundView
    }()
 
    
    let optionsBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        view.backgroundColor = .systemGroupedBackground
        view.clipsToBounds = true
        return view
    }()
        
  
    let imageView: UIImageView = {
        let tempImageView = UIImageView()
        tempImageView.translatesAutoresizingMaskIntoConstraints = false
        tempImageView.contentMode = .scaleAspectFit
        tempImageView.backgroundColor = .clear
        tempImageView.image = UIImage(named: "RemindewDefaultImage")
        return tempImageView
    }()
    
    var plantController: PlantController?
    
  
    var imagePicker: UIImagePickerController!
    
  
    var plant: Plant? {
        didSet {
            updateViews()
        }
    }
    
  
    var mainImage: UIImage? {
        didSet {
            updateViews()
        }
    }
    
    
    var appearanceDelegate: AppearanceDelegate?
    
   
    let standardMargin: CGFloat = 20.0
    
   
    let optionsViewHeight: CGFloat = 278
    
   
    let buttonHeight: CGFloat = 36.0
    
   
    var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.isScrollEnabled = false
        return table
    }()
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
        updateViews()
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
    }

    private func updateViews() {
        
        guard isViewLoaded else { return }
        
        imageView.image = mainImage
        blurredImageView.image = mainImage
    }
    
    // MARK: - Helpers
    
    
    @objc private func takePhotoTapped() {
        
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
       
        if UserDefaults.standard.bool(forKey: .alreadyAskedForCameraUsage) == false {
            UserDefaults.standard.set(true, forKey: .alreadyAskedForCameraUsage)
        }
        
       
        else {
            
            let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)

            switch cameraAuthorizationStatus {
            case .notDetermined, .denied, .restricted:
                print("notDetermined, denied, restricted")
                makeCameraUsagePermissionAlert()
                return
            case .authorized:
                print("Authorized camera in takePhoto")
            default:
                print("Default in takePhoto")
            }
        }
        
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("Error: camera is unavailable")
            makeCameraUsagePermissionAlert()
            return
        }
                
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true)
    }
    
    
    @objc private func choosePhotoTapped() {
        
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("Error: the photo library is unavailable")
            return
        }
        
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
   
    private func makeCameraUsagePermissionAlert() {
    
       
        let title = NSLocalizedString("Camera Access Denied",
                                      comment: "Title for camera usage not allowed")
        let message = NSLocalizedString("Please allow camera usage by going to Settings and turning Camera access on", comment: "Error message for when camera access is not allowed")
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: .default) { _ in
            print("selected OK option")
        }
        let settingsString = NSLocalizedString("Settings", comment: "String for Settings option")
        let settingsAction = UIAlertAction(title: settingsString, style: .default) { _ in
           
            print("selected Settings option")
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }
        alertController.addAction(alertAction)
        alertController.addAction(settingsAction)
        self.present(alertController, animated: true, completion: nil)
    }
  
   
    private func makeLibraryAddUsagePermissionAlert() {
        
        let title = NSLocalizedString("Photos Access Denied",
                                      comment: "Title for library add usage not allowed")
        
        let message = NSLocalizedString("Please allow access to Photos by going to Settings -> Photos -> Add Photos Only", comment: "Error message for when Photos add access is not allowed")
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
       
        let alertAction = UIAlertAction(title: "OK", style: .default)
        
       
        let settingsString = NSLocalizedString("Settings", comment: "String for Settings option")
        let settingsAction = UIAlertAction(title: settingsString, style: .default) { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }
        
        alertController.addAction(alertAction)
        alertController.addAction(settingsAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @objc private func savePhotoTapped() {
        
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        guard let image = imageView.image else { return }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let _ = error {
            makeLibraryAddUsagePermissionAlert()
        } else {
            let ac = UIAlertController(title: NSLocalizedString("Photo Saved", comment: "image saved"), message: "", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
  
    private func setupSubViews() {
                
        view.backgroundColor = .systemGroupedBackground
        view.layer.cornerRadius = 15
        
        
        view.addSubview(contentView)
        contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
                
       
        contentView.addSubview(blurredImageView)
        blurredImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        blurredImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        blurredImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        blurredImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -optionsViewHeight + standardMargin).isActive = true
        
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
        blurView.frame = blurredImageView.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurredImageView.addSubview(blurView)
        
        
        contentView.addSubview(notchView)
        notchView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: standardMargin).isActive = true
        notchView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        notchView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        notchView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        
        contentView.addSubview(imageView)
        imageView.centerYAnchor.constraint(equalTo: blurredImageView.centerYAnchor, constant: -10).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: standardMargin).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -standardMargin).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        
 
        contentView.addSubview(optionsBackgroundView)
        optionsBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        optionsBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        optionsBackgroundView.heightAnchor.constraint(equalToConstant: optionsViewHeight).isActive = true
        optionsBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

     
        optionsBackgroundView.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: optionsBackgroundView.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: 148).isActive = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "OptionCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: -22, left: 0 , bottom: 8, right: 0)
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension AppearanceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
            // TODO: set to smaller resolution?
            blurredImageView.image = image
            appearanceDelegate?.didSelectAppearanceObjects(image: image)
        }
        imagePicker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
}

extension AppearanceViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath)
        
        cell.tintColor = .label
        cell.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = .takePhotoLocalizedString
            cell.accessoryView = UIImageView(image: UIImage(systemName: "camera"))
        case 1:
            cell.textLabel?.text = .choosePhotoLocalizedString
            cell.accessoryView = UIImageView(image: UIImage(systemName: "photo"))
        default:
            cell.textLabel?.text = .savePhotoLocalizedString
            cell.accessoryView = UIImageView(image: UIImage(systemName: "photo.on.rectangle"))
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            takePhotoTapped()
        case 1:
            choosePhotoTapped()
        case 2:
            savePhotoTapped()
        default:
            return
        }
    }
    
}

struct AppearanceOptions {
    var plantIconIndex: Int16 = 8
    var plantColorIndex: Int16 = 0
    var actionIconIndex: Int16 = 0
    var actionColorIndex: Int16 = 1
}
