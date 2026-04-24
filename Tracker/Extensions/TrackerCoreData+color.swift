//
//  TrackerCoreData+color.swift
//  Tracker
//

import UIKit

extension TrackerCoreData {

    var color: UIColor {
        get {
            guard let data = colorData,
                  let color = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
            else {
                return .black
            }
            return color
        }

        set {
            colorData = try? NSKeyedArchiver.archivedData(
                withRootObject: newValue,
                requiringSecureCoding: true
            )
        }
    }
}
