//
//  TrackerStore.swift
//  Tracker
//

import CoreData
import UIKit


final class TrackerStore: NSObject {
    
    static let shared: TrackerStore = TrackerStore()
    private let context: NSManagedObjectContext
    
    override convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        try! self.init(context: context)
    }
    
    private init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    private func setupTracker(tracker trackerModel: Tracker, category: TrackerCategoryCoreData) throws {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.id = trackerModel.id
        trackerCoreData.title = trackerModel.title
        trackerCoreData.emoji = trackerModel.emoji
        trackerCoreData.color = trackerModel.color
        trackerCoreData.schedule = trackerModel.shedule
        trackerCoreData.category = category

        try context.save()
    }
    
    private func loadData() -> [TrackerCategory] {
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()

        guard let trackerObjects = try? context.fetch(request) else {
            return []
        }

        let trackers: [Tracker] = trackerObjects.compactMap { trackerCoreData in
            guard
                let id = trackerCoreData.id,
                let title = trackerCoreData.title,
                let emoji = trackerCoreData.emoji,
                let color = trackerCoreData.color as? UIColor
            else { return nil }

            let schedule = trackerCoreData.schedule as? [Int] ?? []

            return Tracker(
                id: id,
                title: title,
                color: color,
                emoji: emoji,
                shedule: schedule
            )
        }

        let grouped = Dictionary(grouping: trackerObjects.compactMap { trackerCoreData -> (String, Tracker)? in
            guard
                let categoryTitle = trackerCoreData.category?.title,
                let id = trackerCoreData.id,
                let title = trackerCoreData.title,
                let emoji = trackerCoreData.emoji,
                let color = trackerCoreData.color as? UIColor
            else { return nil }

            let schedule = trackerCoreData.schedule as? [Int] ?? []
            let tracker = Tracker(id: id, title: title, color: color, emoji: emoji, shedule: schedule)
            return (categoryTitle, tracker)
        }, by: { $0.0 })

        return grouped
            .map { key, values in
                TrackerCategory(
                    title: key,
                    trackers: values.map { $0.1 }
                )
            }
            .sorted { $0.title < $1.title }
    }
}
