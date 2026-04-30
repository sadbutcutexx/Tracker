//
//  TrackerRecordStore.swift
//  Tracker
//

import Foundation
import CoreData
import UIKit

final class TrackerRecordStore: NSObject {
    static let shared = TrackerRecordStore()
    private let context: NSManagedObjectContext

    override convenience init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.init(context: appDelegate.persistentContainer.viewContext)
    }

    private init(context: NSManagedObjectContext) {
        self.context = context
    }

    // Save record
    func addRecord(trackerId: UUID, dateString: String) throws {
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", trackerId as NSUUID)
        
        guard let tracker = try context.fetch(request).first else { return }

        let record = TrackerRecordCoreData(context: context)
        record.date = dateString
        record.trackerId = tracker
        
        try context.save()
    }

    func removeRecord(trackerId: UUID, dateString: String) throws {
        let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "trackerId.id == %@ AND date == %@",
                                        trackerId as NSUUID, dateString)
        
        let records = try context.fetch(request)
        for record in records {
            context.delete(record)
        }
        try context.save()
    }

    func loadRecords() -> [TrackerRecord] {
        let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        
        guard let records = try? context.fetch(request) else { return [] }

        return records.compactMap { (record: TrackerRecordCoreData) -> TrackerRecord? in
            guard let id = record.trackerId?.id,
                  let date = record.date
            else { return nil }
            
            return TrackerRecord(trackerId: id, date: date)
        }
    }
}
