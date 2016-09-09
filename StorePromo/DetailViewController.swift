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
        
        let documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first
        let destinationUrl = documentsUrl!.URLByAppendingPathComponent(shop.image)
        print(destinationUrl)

        //check metadata.timeCreated property and look for a new file
        isNewFileAtReference(fileRef, oldFileDate: NSUserDefaults.standardUserDefaults().stringForKey("\(shop.image)/lastDate")) {
            fileIsNew in
            print("file is new? \(fileIsNew)")
            if fileIsNew {
                //new file and we should download and display it after finishing downloading
            fileRef.writeToFile(destinationUrl, completion: {
                    (URL, error) -> Void in
                    if (error != nil) {
                        print("error while downloading file: \(error)")
                    } else {
                        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasFileForShop\(self.shop.image)")
                        self.displayFileFromURL(destinationUrl)
                    }
                })
            } else {
                //display old file
                print("found file in storage - showing it!")
                if (NSUserDefaults.standardUserDefaults().boolForKey("hasFileForShop\(self.shop.image)")) {
                self.displayFileFromURL(destinationUrl)
                } else {
                    let alertViewController = UIAlertController.init(title: "NO INTERNET", message: "please conncect", preferredStyle: .Alert)
                    let action = UIAlertAction.init(title: "ok", style: .Default, handler: { action in
                        self.navigationController?.popToRootViewControllerAnimated(true)
                    })
                    alertViewController.addAction(action)
                    self.presentViewController(alertViewController, animated: true, completion: nil)
                }
            }
        }
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
                        if (oldDate != String(metadata!.timeCreated!)) {
                        print("should download file")
                        NSUserDefaults.standardUserDefaults().setObject(String(metadata!.timeCreated!), forKey: "\(self.shop.image)/lastDate")
                        boolToReturn = true
                        }
                    } else {
                        NSUserDefaults.standardUserDefaults().setObject(String(metadata!.timeCreated!), forKey: "\(self.shop.image)/lastDate")
                        boolToReturn = true
                    }
                }
                completion(boolToReturn)
            })
    }
    
    private func displayFileFromURL(url: NSURL) {
        webView.loadData(NSData(contentsOfURL: url)!, MIMEType: "application/pdf", textEncodingName: "", baseURL: url.URLByDeletingLastPathComponent!)
    }
}
