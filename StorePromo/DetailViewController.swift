//
//  DetailViewController.swift
//  StorePromo
//
//  Created by Admin on 28.07.16.
//  Copyright © 2016 fahrenheit. All rights reserved.
//

import UIKit
import FirebaseStorage

class DetailViewController: UIViewController {
    @IBOutlet var webView: UIWebView!
    var shop:Shop!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let parent = self.parentViewController as! TabController
        shop = parent.shop
        parent.navigationItem.title = shop.name
        
        //get Firebase database reference to selected shop folder
        
        let storage = FIRStorage.storage()
        let storageRef = storage.referenceForURL("gs://storepromo-1386.appspot.com")
        
        let fileRef = storageRef.child("\(shop.image)/\(shop.image).pdf")
        
        let localFileURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent(shop.image)

        
        //check metadata properties
        isNewFileAtReference(fileRef, oldFileDate: NSUserDefaults.standardUserDefaults().stringForKey("\(shop.image)/lastDate")) {
            fileIsNew in
            print("boolToReturn: \(fileIsNew)")
            if fileIsNew {
                //new file and we should download and display it after finishing downloading
            fileRef.writeToFile(localFileURL, completion: {
                    (URL, error) -> Void in
                    if (error != nil) {
                        print("error while downloading file: \(error)")
                    } else {
                        print("URL: \(URL)")
                        self.displayFileFromURL(URL!)
                    }
                })
            } else {
                //display old file
                print("found file in storage - showing it!")
                self.displayFileFromURL(localFileURL)
            }
        }

        
        //  DEFAULT IMPLEMENTATION
        /*
         if let url = NSURL(string: shop.url) {
            let request = NSURLRequest(URL: url)
            webView.loadRequest(request)
        }
         */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func isNewFileAtReference(fileRef: FIRStorageReference, oldFileDate: String?, completion:(Bool) -> Void) {
            fileRef.metadataWithCompletion({ (metadata, error) -> Void in
                var boolToReturn = false
                if (error != nil) {
                    print("An error occured: \(error)")
                } else {
                    print("Metadata.timeCreated: \(metadata!.timeCreated!)")
                    if let oldDate = oldFileDate {
                        if (oldDate == String(metadata!.timeCreated!)) {
                            print("DATES ARE EQUAL")
                            boolToReturn = false
                        } else {
                            print("should download file")
                        NSUserDefaults.standardUserDefaults().setObject(String(metadata!.timeCreated!), forKey: "\(self.shop.image)/lastDate")
                            boolToReturn = true
                        }
                    } else {
                        print("set new object to UserDefaults")
                        NSUserDefaults.standardUserDefaults().setObject(String(metadata!.timeCreated!), forKey: "\(self.shop.image)/lastDate")
                        boolToReturn = true
                    }
                }
                completion(boolToReturn)
            })
    }
    
    private func displayFileFromURL(url: NSURL) {
        print("in display file method")
        let request = NSURLRequest(URL: url)
        webView.loadRequest(request)
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
