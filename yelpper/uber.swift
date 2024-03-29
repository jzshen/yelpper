//
//  uber.swift
//  yelpper
//
//  Created by Unis Barakat on 10/10/15.
//  Copyright © 2015 Jennifer Shen. All rights reserved.
//
//

import CoreLocation
import Foundation
import UIKit


class uber {
    
    // required property
    var pickupLocation : CLLocationCoordinate2D!
    
    // optional properties
    var pickupNickname : String?
    var pickupFormattedAddress : String?
    
    var dropoffLocation : CLLocationCoordinate2D?
    var dropoffNickname : String?
    var dropoffFormattedAddress : String?
    
    // -------------------------------------------------------------------
    // init with required property
    // -------------------------------------------------------------------
    init(pickupLocation : CLLocationCoordinate2D) {
        self.pickupLocation = pickupLocation
    }
    
    // -------------------------------------------------------------------
    // perform a deep link to the Uber App if installed
    // check all optional properties while construcing the URL
    // -------------------------------------------------------------------
    func deepLink() {
        if let uberURL = self.constructURL() {
            let sharedApp = UIApplication.sharedApplication()
            print(uberURL)
            sharedApp.openURL(uberURL)
        }
    }
    
    private func constructURL() -> NSURL? {
        
        let uberProtocol = "uber://"
        let httpsProtocol = "https://m.uber.com/"
        
        var uberString = uber.isUberAppInstalled() ? uberProtocol : httpsProtocol
        uberString += "?action=setPickup"
        uberString += "&pickup[latitude]=\(self.pickupLocation.latitude)"
        uberString += "&pickup[longitude]=\(self.pickupLocation.longitude)"
        
        uberString += self.pickupNickname == nil ? "" :
        "&pickup[nickname]=\(self.pickupNickname!)"
        
        uberString += self.pickupFormattedAddress == nil ? "" :
        "&pickup[formatted_address]=\(self.pickupFormattedAddress!)"
        
        if self.dropoffLocation != nil {
            uberString += "&dropoff[latitude]=\(self.dropoffLocation!.latitude)"
            uberString += "&dropoff[longitude]=\(self.dropoffLocation!.longitude)"
        }
        
        uberString += self.dropoffNickname == nil ? "" :
        "&dropoff[nickname]=\(self.dropoffNickname!)"
        
        uberString += self.dropoffFormattedAddress == nil ? "" :
        "&dropoff[formatted_address]=\(self.dropoffFormattedAddress!)"
        
        if let urlEncodedString = uberString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
            return NSURL(string: urlEncodedString)
        } else {
            return nil
        }
    }
    
    // -------------------------------------------------------------------
    // check if the Uber App is installed on the device
    // -------------------------------------------------------------------
    class func isUberAppInstalled() -> Bool {
        let sharedApp = UIApplication.sharedApplication()
        let uberProtocol = NSURL(string: "uber://")
        
        return sharedApp.canOpenURL(uberProtocol!)
    }
    
}
