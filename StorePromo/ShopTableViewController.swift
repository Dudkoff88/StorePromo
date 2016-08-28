//
//  ShopTableViewController.swift
//  StorePromo
//
//  Created by Admin on 28.07.16.
//  Copyright © 2016 fahrenheit. All rights reserved.
//

import UIKit

class ShopTableViewController: UITableViewController {

    let shops:[Shop] = [Shop(name: "Алми", image: "almi", logo: "almi_logo", url: "http://almi.su/rb/90.html", adresses: ["Минск, пр-т Газеты Звезда 57"]),
                        Shop(name: "Гиппо", image: "gippo", logo: "gippo_logo", url: "http://gippo.by/ru/clients/specoffers/", adresses:["Минск, пр-т Рокоссовского 2",
                            "Минск, ул. Горецкого 2",
                            "Минск, ул. Городецкая 30",
                            "Минск, Игуменский тракт 30",
                            "Минск, ул. Сухаревская 31",
                            "Минск, ул. Жуковского 3",
                            "Минск, ул. Червякова 57",
                            "Минск, пр-т Партизанский 150А"]),
                        Shop(name: "Евроопт", image: "euroopt", logo: "euroopt_logo", url: "http://evroopt.by/tovary-v-magazinah-evroopt", adresses: ["г. Минск, ул. Казинца, 52A",
                            "г. Минск, пр. Независимости, 48",
                            "г. Минск, ул. Алибегова, 13 корп. 1",
                            "г. Минск, ул. Рафиева, 27"]),
                        Shop(name: "Корона", image: "korona", logo: "korona_logo", url: "http://www.korona.by/minsk/gipper/actions/", adresses: ["г. Минск, ул. Кальварийская, 24",
                            "г. Минск, ул. Корженевского, 26",
                            "г. Минск, пр-т. Независимости, 154",
                            "г. Минск, пр-т Победителей, 65"]),
                        Shop(name: "Рублевский", image: "rublevski", logo: "rublevski_logo", url: "http://www.rublevski.by/images/phocagallery/action.pdf", adresses: ["г. Минск, 2-й переулок Багаратиона 18а",
                            "г. Минск, Б. Шевченко, 18",
                            "г. Минск, Логойский тракт, 33",
                            "г. Минск, пр-т Газеты “Звезда”, 16/1-2",
                            "г. Минск, пр-т Партизанский, 13",
                            "г. Минск, пр-т Партизанский, 48",
                            "г. Минск, пр-т Победителей, 1",
                            "г. Минск, пр-т Пушкина, 12а",
                            "г. Минск, пр-т Рокоссовского, 114",
                            "г. Минск, пр. Любимова, 17",
                            "г. Минск, пр. Независимости, 117",
                            "г. Минск, пр. Рокоссовского, 1",
                            "г. Минск, ул. Алтайская, 66а",
                            "г. Минск, ул. Брикета, 2",
                            "г. Минск, ул. Водолажского, 6"]),
                        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style:
            .Plain, target: nil, action: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return shops.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ShopTableViewCell

        // Configure the cell...
        cell.nameLabel.text = shops[indexPath.row].name
        cell.shopImageView.image = UIImage(named:shops[indexPath.row].image)
        cell.logoImageView.image = UIImage(named: shops[indexPath.row].logo)
        cell.numberOfShops.text = "\(shops[indexPath.row].adresses .count)"

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showDetails" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationViewController = segue.destinationViewController as! TabController
                destinationViewController.shop = shops[indexPath.row]
                //   let detailViewController = destinationViewController.viewControllers![0] as! DetailViewController
            }
        }
    }
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
