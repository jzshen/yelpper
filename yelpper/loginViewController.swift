//
//  loginViewController.swift
//  yelpper
//
//  Created by Unis Barakat on 10/10/15.
//  Copyright © 2015 Jennifer Shen. All rights reserved.
//

import UIKit
import CoreLocation

class loginViewController: UIViewController, CLLocationManagerDelegate {
    
    
    let locationManager = CLLocationManager()
    

    @IBAction func loginButton(sender: AnyObject) {
        
        let pickupLocation = locationManager.location?.coordinate

        let uberSession = uber(pickupLocation: pickupLocation!)
        
        uberSession.deepLink()
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // 1
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
