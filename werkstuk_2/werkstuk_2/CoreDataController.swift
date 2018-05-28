//
//  CoreDataController.swift
//  werkstuk_2
//
//  Created by ontlener on 28/05/2018.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit
import CoreData

class CoreDataController: NSObject {

    let appDelegate:AppDelegate
    let context:NSManagedObjectContext
    
    override init() {
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = self.appDelegate.persistentContainer.viewContext
    }
    
    
    func addToCore() {
        let entity = NSEntityDescription.entity (forEntityName: "Stations", in: self.context)
        let newStation = NSManagedObject (entity: entity!, insertInto: self.context)
        
        newStation.setValue("value", forKey: "number")
        newStation.setValue("value", forKey: "name")
        newStation.setValue("value", forKey: "address")
        newStation.setValue("value", forKey: "latitude")
        newStation.setValue("value", forKey: "longitude")
        newStation.setValue("value", forKey: "banking")
        newStation.setValue("value", forKey: "bonus")
        newStation.setValue("value", forKey: "status")
        newStation.setValue("value", forKey: "bike_stands")
        newStation.setValue("value", forKey: "available_bike_stands")
        newStation.setValue("value", forKey: "available_bikes")
        
        // save the data
        do {
            try self.context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func fetchFromCore() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Stations")
        
        //working with requests
        //request.predicate = NSPredicate(format: "age = %@", "12")
        
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try self.context.fetch(request)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "attribute") as! String)
            }
        } catch {
            print("Failed")
        }
    }
}
