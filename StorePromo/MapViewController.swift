//
//  MapViewController.swift
//  StorePromo
//
//  Created by Admin on 29.07.16.
//  Copyright © 2016 fahrenheit. All rights reserved.
//

import UIKit
import GoogleMaps
import LMGeocoder

class MapViewController: UIViewController {
    var shop:Shop!
    var adresses:[AnyObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        let parent = self.parentViewController as! TabController
        shop = parent.shop
        
        
        let camera = GMSCameraPosition.cameraWithLatitude(53.8586854, longitude: 27.4622865, zoom: 8)
        let mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.center = CGPointMake(<#T##x: CGFloat##CGFloat#>, <#T##y: CGFloat##CGFloat#>)
        mapView.padding = UIEdgeInsetsMake(0, 0, 50, 0)
        self.view = mapView
        
        for adress in shop.adresses {
            LMGeocoder.sharedInstance().geocodeAddressString(adress,
                                                             service: .GoogleService,
                                                             completionHandler: ({
                                                                results, error in
                                                                if let results = results {
                                                                    let lmAdress = results.first!
                                                                    // self.adresses.append(lmAdress!)
                                                                    print("Coordinate: \(lmAdress.coordinate.latitude), \(lmAdress.coordinate.longitude)")
                                                                    
                                                                    let position = CLLocationCoordinate2DMake(lmAdress.coordinate.latitude, lmAdress.coordinate.longitude)
                                                                    let marker = GMSMarker(position: position)
                                                                    marker.title = adress
                                                                    marker.map = mapView
                                                                }
                                                             })
            )
        }

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
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
