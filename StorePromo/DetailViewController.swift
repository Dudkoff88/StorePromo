//
//  DetailViewController.swift
//  StorePromo
//
//  Created by Admin on 28.07.16.
//  Copyright © 2016 fahrenheit. All rights reserved.
//

import UIKit
import GoogleMobileAds
import FirebaseStorage
import ARSLineProgress
import CFAlertViewController

class DetailViewController: UIViewController, GADInterstitialDelegate {
    @IBOutlet var webView: UIWebView!
    private var shop:Shop!
    private var interstitial: GADInterstitial!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let parent = self.parentViewController as! TabController
        shop = parent.shop
        parent.navigationItem.title = shop.name
        
        //get Firebase database reference to selected shop folder
        
        createAndLoadInterstitial()
        
        let storage = FIRStorage.storage()
        let storageRef = storage.referenceForURL("gs://storepromo-1386.appspot.com")
        
        let fileRef = storageRef.child("\(shop.image)/\(shop.image).pdf")
        
        let documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first
        let destinationUrl = documentsUrl!.URLByAppendingPathComponent(shop.image)
        print(destinationUrl)

        //check metadata.timeCreated property and look for a new file
        isNewFileAtReference(fileRef, oldFileDate: NSUserDefaults.standardUserDefaults().stringForKey("\(shop.image)/lastDate")) {
            fileIsNew, metadata in
            print("file is new? \(fileIsNew)")
            if fileIsNew {
                let cfAlertViewController = CFAlertViewController.alertControllerWithTitle("Есть новый файл!", message: "Загрузим его? (размер файла: \((metadata?.size)! / 1_000_000) Мб)", textAlignment: .Center, preferredStyle: .Alert, didDismissAlertHandler: nil)
                let yesCFAction = CFAlertAction.init(title: "Да!", style: .Default, alignment: .Justified, color: nil, handler: { action in
                    self.beginDownloadingFromReference(fileRef, toURL: destinationUrl)
                    NSUserDefaults.standardUserDefaults().setObject(String(metadata!.timeCreated!), forKey: "\(self.shop.image)/lastDate")
                })
                let noCFAction = CFAlertAction.init(title: "Нет :(", style: .Destructive, alignment: .Justified, color: nil, handler: { action in
                    self.displayFileFromURL(destinationUrl)
                })
                cfAlertViewController.addAction(yesCFAction!)
                if (NSUserDefaults.standardUserDefaults().boolForKey("hasFileForShop\(self.shop.image)")) {
                    cfAlertViewController.addAction(noCFAction!)
                }
                cfAlertViewController.shouldDismissOnBackgroundTap = false
                self.presentViewController(cfAlertViewController, animated: true, completion: nil)
                //new file and we should download and display it after finishing downloading
         
            } else {
                //display old file
                if (NSUserDefaults.standardUserDefaults().boolForKey("hasFileForShop\(self.shop.image)")) {
                    self.displayFileFromURL(destinationUrl)
                } else {
                    self.showNoInternetAlert()
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func isNewFileAtReference(fileRef: FIRStorageReference, oldFileDate: String?, completion:(Bool, FIRStorageMetadata?) -> Void) {
            fileRef.metadataWithCompletion({ (metadata, error) -> Void in
                var fileIsNew = false
                if (error != nil) {
                    print("An error occured: \(error)")
                } else {
                    print("Metadata.timeCreated: \(metadata!.timeCreated!)")
                    if let oldDate = oldFileDate {
                        if (oldDate != String(metadata!.timeCreated!)) {
                        fileIsNew = true
                        }
                    } else {
                        fileIsNew = true
                    }
                }
                completion(fileIsNew, metadata)
            })
    }
    
    //MARK: - Downloading and displaying files
    
    private func displayFileFromURL(url: NSURL) {
        webView.loadData(NSData(contentsOfURL: url)!, MIMEType: "application/pdf", textEncodingName: "", baseURL: url.URLByDeletingLastPathComponent!)
    }
    
    private func showNoInternetAlert () {
        let alertViewController = CFAlertViewController.alertControllerWithTitle("Отсутствует подключение к интернету", message: "Проверьте Ваше соединение и попробуйте снова", textAlignment: .Center, preferredStyle: .Alert, didDismissAlertHandler: nil)
        let action = CFAlertAction.init(title: "Хорошо!", style: .Default, alignment: .Justified, color: nil, handler: { action in
            self.navigationController?.popToRootViewControllerAnimated(true)
        })
        alertViewController.addAction(action!)
        alertViewController.shouldDismissOnBackgroundTap = false
        self.presentViewController(alertViewController, animated: true, completion: nil)
    }
    
    private func beginDownloadingFromReference(fileRef: FIRStorageReference, toURL: NSURL) {
      //  if interstitial.isReady {
            interstitial.presentFromRootViewController(self)
     //   } else {
     //       print("Ad wasn't ready")
     //   }
        let downloadTask = fileRef.writeToFile(toURL, completion: {
            (URL, error) -> Void in
            if (error != nil) {
                print("error while downloading file: \(error)")
            } else {
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasFileForShop\(self.shop.image)")
                self.displayFileFromURL(toURL)
            }
        })
        downloadTask.observeStatus(.Progress, handler: { (snapshot) -> Void in
         //   self.parentViewController!.view.userInteractionEnabled = false
            ARSLineProgress.showWithProgressObject(snapshot.progress!, completionBlock: {
            //    self.parentViewController!.view.userInteractionEnabled = true
            })
        })
    }
    
    //MARK: - Google Ads Functions
    
    private func createAndLoadInterstitial() {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-9164174062846184/9782293357")
        interstitial.delegate = self
        let request = GADRequest()
        // Request test ads on devices you specify. Your test device ID is printed to the console when
        // an ad request is made.
        request.testDevices = [ kGADSimulatorID, "ee960cd9707ea855be8045291c9024f7" ]
        interstitial.loadRequest(request)
    }
    
    
    
    
    
}
