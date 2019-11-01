//
//  DatabaseManager.swift
//  Movie
//
//  Created by Andrey Dovzhenko on 11/1/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import UIKit
import CoreData

struct DatabaseManager {

    static let shared = DatabaseManager()

    private init() { }

    // swiftlint:disable force_cast
    var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate)
            .persistentContainer.viewContext
    }

    func saveContext() {
        do { try context.save() } catch {
            print(error.localizedDescription)
        }
    }

    func removeFromDatabase(object: NSManagedObject) {
        context.delete(object)
        saveContext()
    }

    func addToDatabase(for entityName: String, properties: Mirror.Children) {
        let object = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
        setProperty(for: object, properties: properties)
    }

    func getObjectsFromDatabase(for entityName: String) -> [NSManagedObject] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            return try context.fetch(request) as? [NSManagedObject] ?? [NSManagedObject]()
        } catch {
            return [NSManagedObject]()
        }
    }

    func setProperty(for object: NSManagedObject, properties: Mirror.Children) {
        properties.forEach {
            guard let key = $0.label, object.responds(to: NSSelectorFromString(key)) else {
                return
            }
            object.setValue($0.value, forKey: key)
        }
        saveContext()
    }
}
