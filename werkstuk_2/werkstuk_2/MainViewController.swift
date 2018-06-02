//
//  MainViewController.swift
//  werkstuk_2
//
//  Created by DE MAEYER Kenny (s) on 24/05/2018.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit
import MapKit

class MainViewController: UIViewController, MKMapViewDelegate {

    let URL_VILLO = "https://api.jcdecaux.com/vls/v1/stations?apiKey=6d5071ed0d0b3b68462ad73df43fd9e5479b03d6&contract=Bruxelles-Capitale"
    var stationArray: Array<Station> = Array()
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    var selectedStation: Station?
    var selectedAnnotation: MKPointAnnotation!
    @IBOutlet weak var lastUpdate: UILabel!
    @IBOutlet weak var stationMap: MKMapView!
    
    let coreData: CoreDataController = CoreDataController()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if Reachability.isConnectedToNetwork() {
            print("Internet connection OK")
            DispatchQueue.global(qos: .userInteractive).async {
                self.getDataFromUrl()
            }
        }
        if self.coreData.entityIsEmpty() {
            DispatchQueue.main.async {
                self.addStationAnnotations()
            }
                print("Internet connection Failed")
                let alert = UIAlertView(title: "No Internet Connection", message: "Make Sure your device is connected to the internet", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }
        
        DispatchQueue.main.async {
            if(CLLocationManager.locationServicesEnabled()) {
                self.locationManager = CLLocationManager()
                self.locationManager.delegate = self as? CLLocationManagerDelegate
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.requestAlwaysAuthorization()
                self.locationManager.requestWhenInUseAuthorization()
                self.locationManager.startUpdatingLocation()
                self.currentLocation = self.locationManager.location
                if(self.currentLocation != nil) {
                    let radius: CLLocationDistance = 50000
                    let center = CLLocationCoordinate2D(latitude: self.currentLocation.coordinate.latitude, longitude: self.currentLocation.coordinate.longitude)
                    let region = MKCoordinateRegionMakeWithDistance(center, radius, radius)
                    self.stationMap.setRegion(region, animated: true)
                }
            }
        }
    }
    
    @IBAction func refresh(_ sender: Any) {
        if Reachability.isConnectedToNetwork() {
            print("Internet connection OK")
            DispatchQueue.global(qos: .userInteractive).async {
                self.getDataFromUrl()
                self.viewDidLoad()
            }
        }
        else
        {
            print("Internet connection Failed")
            let alert = UIAlertView(title: "No Internet Connection", message: "Make Sure your device is connected to the internet", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getDataFromUrl() {
        let url = NSURL(string: URL_VILLO)
        
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSArray {
                for station in jsonObj! {
                    let tempObj = Station()
                    if let stationDict = station as? NSDictionary {
                        if let obj = stationDict.value(forKey: "number") {
                            tempObj.number = obj as! Int
                        }
                        if let obj = stationDict.value(forKey: "name") {
                            tempObj.name = obj as! String
                        }
                        if let obj = stationDict.value(forKey: "address") {
                            tempObj.address = obj as! String
                        }
                        if let obj = stationDict.value(forKey: "Posiion") {
                            let pos = obj as! NSArray
                            tempObj.position.latitude = pos[0] as? Double
                            tempObj.position.longitude = pos[1] as? Double
                        }
                        if let obj = stationDict.value(forKey: "banking") {
                            tempObj.banking = obj as! Bool
                        }
                        if let obj = stationDict.value(forKey: "bonus") {
                            tempObj.bonus = obj as! Bool
                        }
                        if let obj = stationDict.value(forKey: "bike_stands") {
                            tempObj.bike_stands = obj as! Int
                        }
                        if let obj = stationDict.value(forKey: "available_bike_stands") {
                            tempObj.available_stands = obj as! Int
                        }
                        if let obj = stationDict.value(forKey: "available_bikes") {
                            tempObj.available_bikes = obj as! Int
                        }
                    }
                    self.stationArray.append(tempObj)
                }
                
                self.coreData.addToCore(stationArray: self.stationArray)
                
                OperationQueue.main.addOperation ({
                    self.addStationAnnotations()
                })
            }
            
        }).resume()
    }
    
    func addStationAnnotations() {
        self.stationArray = coreData.fetchFromCore()
        for station in self.stationArray {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: station.position.latitude!, longitude: station.position.longitude!)
            annotation.title = station.name
            self.stationMap.addAnnotation(annotation)
        }
    }
    
    internal func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        pin.canShowCallout = true
        pin.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        return pin
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control:UIControl) {
        let annView = view.annotation
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "detail") as! DetailViewController
        
        self.stationArray = self.coreData.fetchFromCore()
        
        for station in self.stationArray {
            if (station.name == (annView?.title)!) {
                detailVC.station = station
            }
        }
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
