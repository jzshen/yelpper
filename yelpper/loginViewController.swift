//
//  loginViewController.swift
//  yelpper
//
//  Created by Unis Barakat on 10/10/15.
//  Copyright © 2015 Jennifer Shen. All rights reserved.
//

import UIKit

class loginViewController: UIViewController {
    

    @IBAction func loginButton(sender: AnyObject) {
        
        let uberSession: Uber = Uber.init(pickupLocation: <#T##CLLocationCoordinate2D#>)
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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