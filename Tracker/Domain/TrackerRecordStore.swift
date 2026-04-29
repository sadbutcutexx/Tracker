//
//  TrackerRecordStore.swift
//  Tracker
//

import CoreData
import UIKit


final class TrackerRecordStore: NSObject {
    
    static let shared: TrackerRecordStore = TrackerRecordStore()
    private let context: NSManagedObjectContext
    
    override convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        try! self.init(context: context)
    }
    
    private init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    private func saveRecord(trackerRecordModel model: TrackerRecord) {
        let record = TrackerRecordCoreData(context: context)
        record.date = model.date
        record.trackerID = model.trackerId
        try context.save()
    }
    
    private func loadRecords() -> [TrackerRecord] {
        let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()

        guard let records = try? context.fetch(request) else { return [] }

        return records.compactMap {
            guard let trackerId = $0.trackerID, let date = $0.date else { return TrackerRecord }
            return TrackerRecord(trackerId: trackerId, date: date)
        }
    }
}
