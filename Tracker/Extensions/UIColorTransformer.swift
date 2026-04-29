//
//  UIColorTransformer.swift
//  Tracker
//

import Foundation
import UIKit

final class UIColorTransformer: ValueTransformer {
    
    override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }
     
    override class func allowsReverseTransformation() -> Bool {
        true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        
        do {
            let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
            return color
        } catch {
            return nil
        }
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let color = value as? UIColor else { return nil }
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: color) as? UIColor
            return data
        } catch {
            return nil
        }
    }
    
    static func register() {
        let transformer: ValueTransformer = UIColorTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: NSValueTransformerName("UIColorTransformer"))
    }
}
