//
//  optionsViewController.swift
//  yelpper
//
//  Created by Unis Barakat on 10/10/15.
//  Copyright © 2015 Jennifer Shen. All rights reserved.
//

import UIKit
import CoreLocation

var locationLongtitude: CLLocationDegrees = 0
var locationLatitude: CLLocationDegrees = 0
var selectedDistance: Int = 1
var productIDs: [String] = []
var selectedProductID: String = ""


class optionsViewController: UIViewController, CLLocationManagerDelegate, UIPickerViewDataSource,UIPickerViewDelegate {
    
    //List of Uber Products
    var itemsList: [String] = []
    
    //Location Manager
    var locManager = CLLocationManager()
    
    //Distance Data
    var distanceData:[[String]] = [["1 mi","5 mi","10 mi","15 mi" ,"20 mi","25 mi"], []]
    
    var distanceTemp: [Int] = [1,5,10,15 ,20,25]
    
    //Selected Data
    
    var sorting: Int = 1
    var selectedUber: String = ""
    
    
    
    //Picker for distance and Uber Product
    @IBOutlet weak var distancePicker: UIPickerView!
    
    //Button for Yelp Price
    @IBOutlet weak var yelpPrice: UISegmentedControl!
    
    
    //Detect Yelp Rating Change
    @IBAction func priceChanged(sender: UISegmentedControl) {
        switch yelpPrice.selectedSegmentIndex
        {
        case 0:
            sorting = 1
        case 1:
            sorting = 2
        case 2:
            sorting = 3
        default:
            sorting = 1
        }
    }
    
    
    
    var businesses: [Business]!
    var destAddress: String = ""
    
    @IBAction func findUber(sender: AnyObject) {
        
        //Find Sorting Method Based on Input
        var sortingMethod: YelpSortMode = .Distance
        
        if(sorting == 1){
            sortingMethod = .Distance
        } else if (sorting == 2){
            sortingMethod = .BestMatched
        } else {
            sortingMethod = .HighestRated
        }
        
        //Using Yelp, find a list of roughly 20-40 restuarants and put thim in an array
        Business.searchWithTerm("Restaurants", sort: sortingMethod, categories: nil, deals: false) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            self.destAddress =  self.businesses[self.randRange(0, upper: self.businesses.count - 1)].address!
            
            print(self.destAddress)
        }
        
        
        //Navigate to address picked with Uber
        
//        let uberSession: uber = uber(pickupLocation: (locManager.location?.coordinate)!)
//        
//        uberSession.dropoffFormattedAddress = destAddress
//        
//        uberSession.deepLink()
        
        
        //get estimate
        
        let estemiate: UBPriceEstimate = UBPriceEstimate.init(dictionary: ["product_id" : selectedProductID , "distance" : selectedDistance ])
        print("getting estimate ...")
        print(estemiate.lowEstimate)
        print("finished estimating..")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(!Reachability.isConnectedToNetwork()){
            let alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        } else {
            // Set Tracking
            self.locManager.delegate = self
            self.locManager.requestWhenInUseAuthorization()
            self.locManager.distanceFilter = kCLDistanceFilterNone
            self.locManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locManager.startUpdatingLocation()
            UBUberAPI.shared().serverToken = "V2PBuPn3aIHgKnWZgf7wrCYK8pfdXxV5ZERdAGs7"
        }
        
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //Distance Picker View Methods
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2 //one for the distance and another for the Uber
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return distanceData[component].count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return distanceData[component][row]
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component
        {
        case 0:
            selectedDistance = distanceTemp[row]
        case 1:
            selectedUber = distanceData[1][row]
            selectedProductID = productIDs[row]
        default:
            print("what the efffffff")
        }

    }
    
    
    
    
    // MARK: - Location Manager Delegate
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("didFailWithError: \(error.description)")
        let errorAlert = UIAlertView(title: "Failed to Get Your Location", message: "Go to settings and allow this app to 'access location while in use' to continue", delegate: nil, cancelButtonTitle: "Ok")
        errorAlert.show()
    }
    
    func locationManager(manager: CLLocationManager,
        didChangeAuthorizationStatus status: CLAuthorizationStatus) {
            
            if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse{
                
                let latitude = Float(locManager.location!.coordinate.latitude)
                let longitude = Float(locManager.location!.coordinate.longitude)
                
                //set Global loattitude and longtitude 
                locationLatitude = locManager.location!.coordinate.latitude
                locationLongtitude = locManager.location!.coordinate.longitude

                UBUberAPI.shared().getProductsFromLatitude(latitude , longitude: longitude, response: {(products: [AnyObject]!, error: NSError!) in
                    
                    for (var i = 0; i < products.count; i++){
                        print(products[i].displayName)
                        self.distanceData[1].append(products[i].displayName)
                        productIDs.append(products[i].productId)
                    }
                    self.selectedUber = self.distanceData[1][0] //set a default
                    self.distancePicker.dataSource = self
                    self.distancePicker.delegate = self
                    
                })
            }
            
    }
    
    //Random Int function
    func randRange (lower: Int , upper: Int) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
    
    
}


//check internet connection

import SystemConfiguration

public class Reachability {
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags.ConnectionAutomatic
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}
