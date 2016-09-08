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

    @IBOutlet weak var mapView: GMSMapView!
    
    var shop:Shop!
    //  var adresses:[AnyObject] = []
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        let parent = self.parentViewController as! TabController
        shop = parent.shop
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        checkAuthorizationStatus()
        
        if ((NSUserDefaults.standardUserDefaults().objectForKey(shop.adresses.last!)) == nil) {
            print("CANNOT FIND CACHED LAST VALUE")
            fetchShopAdresses()
        } else {
            for adress in shop.adresses {
                let dict:[String : Double] = NSUserDefaults.standardUserDefaults().objectForKey(adress) as! [String : Double]
                print("PLACING FROM CACHE: \(dict)")
                self.placeMarkerForCoordinates(latitude: dict["latitude"], longitude: dict["longitude"], title: adress)
            }
        }
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchShopAdresses() {
        print("fetching adresses")
        for adress in shop.adresses {
            LMGeocoder.sharedInstance().geocodeAddressString(adress,
                                                             service: .GoogleService,
                                                             completionHandler: ({
                                                                results, error in
                                                                if let results = results {
                                                                    let lmAdress = results.first!
                                                                    
                                                                    let dict:[String : Double] = ["latitude": lmAdress.coordinate.latitude, "longitude": lmAdress.coordinate.longitude]
                                                                    print("CACHING: \(dict)")
                                                                    NSUserDefaults.standardUserDefaults().setObject(dict, forKey: adress)

                                                                    dispatch_async(dispatch_get_main_queue(), {
                                                                      self.placeMarkerForCoordinates(latitude: lmAdress.coordinate.latitude, longitude: lmAdress.coordinate.longitude, title: adress)
                                                                    })  
                                                            }
                                })
            )
        }
    }
    
    func checkAuthorizationStatus() {
        if (CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse) {
            print("AUTHORIZED")
            locationManager.startUpdatingLocation()
            
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        } else {
            print("ACCESS ISN'T GRANTED")
        }
    }
    
    
    func placeMarkerForCoordinates(latitude latitude: Double?, longitude: Double?, title: String) {
        
            let position = CLLocationCoordinate2DMake(latitude!, longitude!)
            let marker = GMSMarker(position: position)
            marker.title = title
            marker.map = self.mapView
    }

}

// MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {

        if status == .AuthorizedWhenInUse {
            
            locationManager.startUpdatingLocation()
        
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("finished updating locations")
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
        }
        
    }
    
    
}

