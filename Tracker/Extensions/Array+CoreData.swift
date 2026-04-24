//
//  Array+CoreData.swift
//  Tracker
//

import Foundation

extension Array where Element == Int {
    func toData() -> Data? {
        try? JSONEncoder().encode(self)
    }
    
    static func fromData(_ data: Data) -> [Int]? {
        try? JSONDecoder().decode([Int].self, from: data)
    }
}
