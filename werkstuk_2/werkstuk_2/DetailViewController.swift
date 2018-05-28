//
//  DetailViewController.swift
//  werkstuk_2
//
//  Created by DE MAEYER Kenny (s) on 24/05/2018.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var banking: UILabel!
    @IBOutlet weak var bonus: UILabel!
    @IBOutlet weak var totalOfStands: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var availableStands: UILabel!
    @IBOutlet weak var availableBikes: UILabel!
    
    var station:Station = Station()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.name.text = self.station.name
        self.address.text = self.station.address
        if(self.station.banking) {
            self.banking.text = "YES"
            self.banking.textColor = UIColor.green
        } else {
            self.banking.text = "NO"
            self.banking.textColor = UIColor.red
        }
        if(self.station.bonus) {
            self.bonus.text = "YES"
            self.bonus.textColor = UIColor.green
        } else {
            self.bonus.text = "NO"
            self.bonus.textColor = UIColor.red
        }
        self.totalOfStands.text = String(self.station.bike_stands)
        if(self.station.status == "OPEN") {
            self.status.text = self.station.status
            self.status.textColor = UIColor.green
        } else {
            self.status.text = self.station.status
            self.status.textColor = UIColor.red
        }
        self.availableStands.text = String(self.station.available_stands)
        self.availableBikes.text = String(self.station.available_bikes)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
