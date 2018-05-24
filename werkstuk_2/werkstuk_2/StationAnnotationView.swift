//
//  StationAnnotationView.swift
//  werkstuk_2
//
//  Created by DE MAEYER Kenny (s) on 24/05/2018.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit
import MapKit

class StationAnnotationView: MKAnnotationView {

    @IBOutlet weak var customCalloutView: StationAnnotationView!
    
    override var annotation: MKAnnotation? {
        willSet {customCalloutView?.removeFromSuperview()}
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.canShowCallout = false
    }
    
    required init? (coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.canShowCallout = false
    }
    
    //Callout showing and hiding
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if let newCustomCalloutView = loadStationMapView() {
            //fix location from top-left to its right place
            newCustomCalloutView.frame.origin.x -= newCustomCalloutView.frame.width / 2.0 - (self.frame.width / 2.0)
            newCustomCalloutView.frame.origin.y -= newCustomCalloutView.frame.height
            
            // set custom callout view
            self.addSubview(newCustomCalloutView)
            self.customCalloutView = newCustomCalloutView as! StationAnnotationView
            
            // animate presentation
            if animated {
                self.customCalloutView!.alpha = 0.0
                UIView.animate(withDuration: 2000, animations: {
                    self.customCalloutView!.alpha = 1.0
                })
            }
        } else {
            if customCalloutView != nil {
                if animated {
                    //fade out animation, then remove it
                    UIView.animate(withDuration: 2000, animations: { self.customCalloutView!.alpha = 0.0 }, completion: { (success) in self.customCalloutView!.removeFromSuperview()
                    })
                } else { self.customCalloutView!.removeFromSuperview() } //just remove it
            }
        }
    }
    
    func loadStationMapView() -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 240, height: 350))
        return view
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
