//
//  ConfigService.swift
//  SmartEnglishLearning
//
//  Created by Harun Rasit Pekacar on 12/10/24.
//

import SwiftUI

class ConfigService {
    static let shared = ConfigService()
    
    func get(forKey key: String) -> String? {
        guard let plistPath = Bundle.main.path(forResource: "Config", ofType: "plist"),
            let plistData = FileManager.default.contents(atPath: plistPath),
            let plist = try? PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [String: Any],
            let configValue = plist[key] as? String else {
                return nil
            }
        return configValue
    }
}
