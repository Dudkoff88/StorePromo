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
                placeMarkerForCoordinates(latitude: dict["latitude"], longitude: dict["longitude"], title: adress)
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
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    
    func placeMarkerForCoordinates(latitude latitude: Double?, longitude: Double?, title: String) {
        
            let position = CLLocationCoordinate2DMake(latitude!, longitude!)
            let marker = GMSMarker(position: position)
            marker.title = title
            marker.map = mapView
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
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
        } else {
            newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    
}

