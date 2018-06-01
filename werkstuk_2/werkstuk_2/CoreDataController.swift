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
    
    func fetchFromCore()  -> Array<Station> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Stations")
        var stationArray:Array<Station> = Array()
        
        //working with requests
        //request.predicate = NSPredicate(format: "age = %@", "12")
        
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try self.context.fetch(request)
            for data in result as! [NSManagedObject] {
                let tempStation:Station = Station()
                
                tempStation.number = data.value(forKey: "number") as! Int
                tempStation.name = data.value(forKey: "name") as! String
                tempStation.address = data.value(forKey: "address") as! String
                tempStation.position.latitude = data.value(forKey: "latitude") as? Double
                tempStation.position.longitude = data.value(forKey: "longitude") as? Double
                tempStation.banking = data.value(forKey: "banking") as! Bool
                tempStation.bonus = data.value(forKey: "bonus") as! Bool
                tempStation.status = data.value(forKey: "status") as! String
                tempStation.bike_stands = data.value(forKey: "bike_stands") as! Int
                tempStation.available_stands = data.value(forKey: "available_bike_stands") as! Int
                tempStation.available_bikes = data.value(forKey: "available_bikes") as! Int
                
                stationArray.append(tempStation)
            }
        } catch {
            print("Failed")
        }
        
        return stationArray
    }
    
    func entityIsEmpty() -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Stations")
        var count:Int = 0
        do {
            count = try self.context.count(for: request)
        } catch {
            print(error)
        }
        
        
        if count == 0 {
            return true
        } else {
            return false
        }
        
    }
}
