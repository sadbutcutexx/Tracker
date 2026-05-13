//
//  TrackerCategoryStore.swift
//  Tracker
//

import CoreData
import UIKit

final class TrackerCategoryStore: NSObject {

    // MARK: - Singleton

    static let shared = TrackerCategoryStore()

    // MARK: - Properties

    private let context: NSManagedObjectContext

    // MARK: - Init

    override convenience init() {

        let context = (
            UIApplication.shared.delegate as! AppDelegate
        ).persistentContainer.viewContext

        self.init(context: context)
    }

    private init(context: NSManagedObjectContext) {
        self.context = context
    }

    // MARK: - Create Category

    func addCategory(title: String) throws {

        let request: NSFetchRequest<TrackerCategoryCoreData> =
        TrackerCategoryCoreData.fetchRequest()

        request.predicate = NSPredicate(
            format: "title == %@",
            title
        )

        let existing = try context.fetch(request)

        guard existing.isEmpty else {
            return
        }

        let category = TrackerCategoryCoreData(context: context)

        category.title = title

        try context.save()
    }

    // MARK: - Fetch Categories

    func fetchCategories() -> [TrackerCategory] {

        let request: NSFetchRequest<TrackerCategoryCoreData> =
        TrackerCategoryCoreData.fetchRequest()

        request.sortDescriptors = [
            NSSortDescriptor(key: "title", ascending: true)
        ]

        guard let categories = try? context.fetch(request) else {
            return []
        }

        return categories.map { category in

            let trackers =
            (category.trackers?.allObjects as? [TrackerCoreData]) ?? []

            let mappedTrackers: [Tracker] = trackers.compactMap {

                guard
                    let id = $0.id,
                    let title = $0.title,
                    let emoji = $0.emoji,
                    let color = $0.color as? UIColor
                else {
                    return nil
                }

                return Tracker(
                    id: id,
                    title: title,
                    color: color,
                    emoji: emoji,
                    shedule: $0.schedule as? [Int] ?? []
                )
            }

            return TrackerCategory(
                title: category.title ?? "",
                trackers: mappedTrackers
            )
        }
    }
}
