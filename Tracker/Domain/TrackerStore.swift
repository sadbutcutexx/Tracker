//
//  TrackerStore.swift
//  Tracker
//

import CoreData
import UIKit

protocol TrackerStoreDelegate: AnyObject {
    func trackerCoreDataDidChange(_ store: TrackerStore)
}

final class TrackerStore: NSObject {
    static let shared = TrackerStore()
    private let context: NSManagedObjectContext
    weak var delegate: TrackerStoreDelegate?
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        
        request.sortDescriptors = [
            NSSortDescriptor(key: "category.title", ascending: true),
            NSSortDescriptor(key: "title", ascending: true)
        ]
        
        let controller = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: "category.title",
            cacheName: nil
        )
        
        controller.delegate = self
        return controller
    }()
    
    func performFetch() throws {
        try fetchedResultsController.performFetch()
    }

    override convenience init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.init(context: appDelegate.persistentContainer.viewContext)
    }

    private init(context: NSManagedObjectContext) {
        self.context = context
    }

    func saveTracker(trackerModel: Tracker, categoryTitle: String) throws {
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", trackerModel.id as CVarArg)

        if let _ = try? context.fetch(request).first {
            return
        }
        
        let categoryRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        categoryRequest.predicate = NSPredicate(format: "title == %@", categoryTitle)
        
        let category: TrackerCategoryCoreData
        if let existing = try? context.fetch(categoryRequest).first {
            category = existing
        } else {
            category = TrackerCategoryCoreData(context: context)
            category.title = categoryTitle
        }

        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.id = trackerModel.id
        trackerCoreData.title = trackerModel.title
        trackerCoreData.emoji = trackerModel.emoji
        trackerCoreData.color = trackerModel.color as NSObject
        trackerCoreData.schedule = trackerModel.shedule as NSObject
        trackerCoreData.category = category

        try context.save()
        
        print("Saved tracker:", trackerModel.title)
    }

    func getCategories() -> [TrackerCategory] {
        if fetchedResultsController.fetchedObjects == nil {
            try? fetchedResultsController.performFetch()
        }

        guard let objects = fetchedResultsController.fetchedObjects else { return [] }

        let grouped = Dictionary(grouping: objects) { $0.category?.title ?? "Без категории" }

        return grouped.map { (key, trackers) in
            let models = trackers.compactMap { obj -> Tracker? in
                guard
                    let id = obj.id,
                    let title = obj.title,
                    let emoji = obj.emoji,
                    let color = obj.color as? UIColor
                else { return nil }

                let schedule = obj.schedule as? [Int] ?? []

                return Tracker(
                    id: id,
                    title: title,
                    color: color,
                    emoji: emoji,
                    shedule: schedule
                )
            }
            return TrackerCategory(title: key, trackers: models)
        }
        .sorted { $0.title < $1.title }
    }
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.trackerCoreDataDidChange(self)
    }
}
