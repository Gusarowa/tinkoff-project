//
//  Extensions.swift
//  Remindew
//
//  Created by Лена Гусарова on 01.06.2023.
//

import Foundation
import UIKit

extension UNUserNotificationCenter {
    static func checkPendingNotes(completion: @escaping (Int) -> Void = { _ in }) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notes) in
            DispatchQueue.main.async {
                print("pending count = \(notes.count)")
                completion(notes.count)
            }
        }
    }
}
