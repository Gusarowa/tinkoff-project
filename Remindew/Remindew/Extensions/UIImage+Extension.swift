//
//  UIImage+Extension.swift
//  Remindew
//
//  Created by Лена Гусарова on 01.06.2023.

import Foundation
import UIKit

extension UIImage {
    
    
    static var savedUserPlantImages = [String: UIImage]() {
        didSet {
           
            if savedUserPlantImages.count > 100 {
                savedUserPlantImages.removeAll()
            }
        }
    }
    
   
    static let iconArray = [UIImage(systemName: "drop.fill"), UIImage(systemName: "cross.fill"), UIImage(systemName: "ant.fill"), UIImage(systemName: "scissors"), UIImage(systemName: "aqi.low"), UIImage(systemName: "rotate.right.fill"), UIImage(systemName: "arrow.up.bin.fill"), UIImage(systemName: "circle.fill"), UIImage(systemName: "leaf.fill")]
    
   
    static let plantIconArray = [UIImage(systemName: "leaf.fill"), UIImage(named: "planticonleaf")]
    
    
    static let logoImage = UIImage(named: "plantslogoclear1024x1024")!
    
    
    static let smallAppIconImage = UIImage(named: "plantslogo60x60")
    
  
    static let leafdropIcon = UIImage(named: "planticonleaf")!.withRenderingMode(.alwaysTemplate)
    
    
    static let defaultImage = UIImage(named: "RemindewDefaultImage")
    
   
    static func applyLowerPortionGradient(imageView: UIImageView, opacity: Float = 0.5) {
        
        let gradient = CAGradientLayer()
       
        let chunk = imageView.bounds.height / CGFloat(2.0)
       
        let bottomHalf = CGRect(x: imageView.bounds.origin.x,
                                y: imageView.bounds.maxY - chunk,
                                width: imageView.bounds.width,
                                height: chunk)
        gradient.frame = bottomHalf
       
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
      
        gradient.opacity = opacity
        imageView.layer.addSublayer(gradient)
    }
        
  
    static func saveImage(imageName: String, image: UIImage) {
        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else { return }

      
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
              
                savedUserPlantImages.removeValue(forKey: imageName)
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }

        }

        do {
            try data.write(to: fileURL)
            savedUserPlantImages[imageName] = image
        } catch let error {
            print("error saving file with error", error)
        }

    }

    static func loadImageFromDiskWith(fileName: String) -> UIImage? {
        if let imageFromCache = savedUserPlantImages[fileName] {
            return imageFromCache
        }
                
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory

        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)

        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            savedUserPlantImages[fileName] = image
            return image
        }

        return nil
    }
    
    static func deleteImage(_ imageName: String) {
        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                savedUserPlantImages.removeValue(forKey: imageName)
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
        }
    }
    
     static func resizeImage(image: UIImage) -> UIImage {
        
        let newWidth: CGFloat = 1024.0 
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
