//
//  MainViewController.swift
//  StorePromo
//
//  Created by Игорь Майсюк on 07.09.16.
//  Copyright © 2016 fahrenheit. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GADAppEventDelegate, GADBannerViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    let shops:[Shop] = [
        // Shop(name: "Алми", image: "almi", logo: "almi_logo",  adresses: ["Минск, пр-т Газеты Звезда 57"]),
                        Shop(name: "Гиппо", image: "gippo", logo: "gippo_logo",  adresses:["Минск, пр-т Рокоссовского 2",
                            "Минск, ул. Горецкого 2",
                            "Минск, ул. Городецкая 30",
                            "Минск, Игуменский тракт 30",
                            "Минск, ул. Сухаревская 31",
                            "Минск, ул. Жуковского 3",
                            "Минск, ул. Червякова 57",
                            "Минск, пр-т Партизанский 150А"]),
                        Shop(name: "Евроопт", image: "euroopt", logo: "euroopt_logo",  adresses: ["г. Минск, ул. Казинца, 52A",
                            "г. Минск, пр. Независимости, 48",
                            "г. Минск, ул. Алибегова, 13 корп. 1",
                            "г. Минск, ул. Рафиева, 27"]),
                    //  Shop(name: "Корона", image: "korona", logo: "korona_logo",  adresses: ["г. Минск, ул. Кальварийская, 24",
                    //        "г. Минск, ул. Корженевского, 26",
                    //       "г. Минск, пр-т. Независимости, 154",
                    //      "г. Минск, пр-т Победителей, 65"]),
                        Shop(name: "Рублевский", image: "rublevski", logo: "rublevski_logo",  adresses: ["г. Минск, 2-й переулок Багаратиона 18а",
                            "г. Минск, Б. Шевченко, 18",
                            "г. Минск, Логойский тракт, 33",
                            "г. Минск, пр-т Газеты “Звезда”, 16/1-2",
                            "г. Минск, пр-т Партизанский, 13",
                            "г. Минск, пр-т Партизанский, 48",
                            "г. Минск, пр. Победителей, 1",
                            "г. Минск, пр. Пушкина, 12а",
                            "г. Минск, пр-т Рокоссовского, 114",
                            "г. Минск, пр. Любимова, 17",
                            "г. Минск, пр. Независимости, 117",
                            "г. Минск, пр. Рокоссовского, 1",
                            "г. Минск, ул. Алтайская, 66а",
                            "г. Минск, ул. Брикета, 2",
                            "г. Минск, ул. Водолажского, 6",
                            "г. Минск, ул. Есенина, 12"]),
                        Shop(name: "ProStore", image: "prostore", logo: "prostore_logo", adresses: ["г. Минск, ул. Каменногорская, 3",
                            "г. Минск, пр. Победителей, 84",
                            "г. Минск, пр. Дзержинского, 126",
                            "г. Минск, пр. Партизанский, 182",
                            "г. Минск, ул. Уборевича, 176"
                            ]),
                        Shop(name: "Соседи", image: "sosedi", logo: "sosedi_logo", adresses: ["г. Минск, Долгиновский тр-т, 178",
                            "г. Минск, ул. В.Хоружей, 17",
                            "г. Минск, ул. Дунина-Марцинкевича, 11"
                            ]),
                        Shop(name: "Белмаркет", image: "belmarket", logo: "belmarket_logo", adresses: ["г.Минск, 2-й Велосипедный переулок, 32",
                            "г.Минск, Колодищи, ул.Минская,5",
                            "г.Минск, ул. Варвашени, 1",
                            "г.Минск, ул. Героев 120-й Дивизии, 21"])
        
                        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
 
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style:
            .Plain, target: nil, action: nil)
        
        print("Google Mobile Ads SDK version: \(GADRequest.sdkVersion())")
        bannerView.adUnitID = "ca-app-pub-9164174062846184/1239951757"
        bannerView.adSize = kGADAdSizeSmartBannerPortrait
        bannerView.delegate = self
        bannerView.rootViewController = self

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID, "ee960cd9707ea855be8045291c9024f7"]
        bannerView.loadRequest(request)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return shops.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ShopTableViewCell
        
        // Configure the cell...
        cell.nameLabel.text = shops[indexPath.row].name
        cell.shopImageView.image = UIImage(named:shops[indexPath.row].image)
        cell.logoImageView.image = UIImage(named: shops[indexPath.row].logo)
        cell.numberOfShops.text = "\(shops[indexPath.row].adresses .count)"
        
        return cell
    }
    
    //MARK: - AdMob delegate methods
    
    func adViewDidReceiveAd(bannerView: GADBannerView!) {
        self.bannerView.hidden = false
        print("displayed new ad!")
    }
    
    func adView(bannerView: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
        self.bannerView.hidden = true
        print(error)
    }
    
    //MARK: - Table view delegate methods
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetails" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationViewController = segue.destinationViewController as! TabController
                destinationViewController.shop = shops[indexPath.row]
            }
        }
    }

}
