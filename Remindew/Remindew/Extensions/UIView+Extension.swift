//
//  UIView+Extension.swift
//  Remindew
//
//  Created by Лена Гусарова on 01.06.2023.

import Foundation
import UIKit

extension UIView {
  func performFlare() {
    
    func flare() {
        transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
    }
    
    func unflare() { transform = .identity }
    
    UIView.animate(withDuration: 0.3,
                   animations: { flare() },
                   completion: { _ in UIView.animate(withDuration: 0.2) { unflare() }})
  }
}
