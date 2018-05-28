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
    
    
    func addToCore(stationArray: Array<Station>) {
        let entity = NSEntityDescription.entity (forEntityName: "Stations", in: self.context)
        let newStation = NSManagedObject (entity: entity!, insertInto: self.context)
        
        for station in stationArray {
            newStation.setValue(station.number, forKey: "number")
            newStation.setValue(station.name, forKey: "name")
            newStation.setValue(station.address, forKey: "address")
            newStation.setValue(station.position.latitude, forKey: "latitude")
            newStation.setValue(station.position.longitude, forKey: "longitude")
            newStation.setValue(station.banking, forKey: "banking")
            newStation.setValue(station.bonus, forKey: "bonus")
            newStation.setValue(station.status, forKey: "status")
            newStation.setValue(station.bike_stands, forKey: "bike_stands")
            newStation.setValue(station.available_stands, forKey: "available_bike_stands")
            newStation.setValue(station.available_bikes, forKey: "available_bikes")
        }
        
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
