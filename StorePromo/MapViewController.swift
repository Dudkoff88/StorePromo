//
//  MapViewController.swift
//  StorePromo
//
//  Created by Admin on 29.07.16.
//  Copyright © 2016 fahrenheit. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        let camera = GMSCameraPosition.cameraWithLatitude(1.285, longitude: 103.848, zoom: 8)
        let map = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        map.myLocationEnabled = true
        map.settings.myLocationButton = true
        map.padding = UIEdgeInsetsMake(0, 0, 50, 0)
        self.view = map
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
