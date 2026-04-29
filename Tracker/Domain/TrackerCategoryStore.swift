//
//  TrackerCategoryStore.swift
//  Tracker
//

import CoreData
import UIKit


final class TrackerCategoryStore: NSObject {
    
    static let shared: TrackerCategoryStore = TrackerCategoryStore()
    private let context: NSManagedObjectContext
    
    override convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        try! self.init(context: context)
    }
    
    private init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    private func setupCategory(trackerCategory categoryModel: TrackerCategory) throws {
        let categoryCoreData = TrackerCategoryCoreData(context: context)
        categoryCoreData.title = categoryModel.title

        for trackerModel in categoryModel.trackers {
            let trackerCoreData = TrackerCoreData(context: context)
            trackerCoreData.id = trackerModel.id
            trackerCoreData.title = trackerModel.title
            trackerCoreData.emoji = trackerModel.emoji
            trackerCoreData.color = trackerModel.color
            trackerCoreData.category = categoryCoreData
        }

        try context.save()
    }
    
    private func loadData() -> [TrackerCategory] {
        //TODO: - Code
    }
}
