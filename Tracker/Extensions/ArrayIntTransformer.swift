//
//  ArrayIntTransformer.swift
//  Tracker
//

import Foundation

final class ArrayIntTransformer: ValueTransformer {
    
    override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let array = value as? [Int] else {
            return nil
        }
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: array, requiringSecureCoding: true)
            
            return data
        } catch {
            return nil
        }
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }

        do {
            return try NSKeyedUnarchiver.unarchivedObject(
                ofClasses: [NSArray.self, NSNumber.self],
                from: data
            ) as? [Int]
        } catch {
            return nil
        }
    }
    
    static func register() {
        let tranformer: ArrayIntTransformer = ArrayIntTransformer()
        
        ValueTransformer.setValueTransformer(tranformer, forName: NSValueTransformerName("IntArrayTransformer"))
    }
}
