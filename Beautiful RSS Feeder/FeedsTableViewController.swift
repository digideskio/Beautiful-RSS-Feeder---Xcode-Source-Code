//
//  FeedsTableViewController.swift
//  Beautiful RSS Feeder
//
//  Created by Grant on 01/12/2015.
//  Copyright © 2015 GK Micro Ltd. All rights reserved.
//

import UIKit

class FeedsTableViewController: UITableViewController {
    
    @IBAction func rearrangeButtClicked(sender: AnyObject) {
            self.editing = !self.editing
    }
    
    var feeds = [Feed] ()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        getFeeds()
    }
    
    func getFeeds () {
        do {
            feeds = try FeedDataHelper.findAll()!
            for feed in feeds {
                print(feed.getName())
            }
        }
        catch _ {
            print("Feed database access error")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseIdentifier = "FeedsTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! FeedsTableViewCell
        
        //fetch data
        let feed = feeds[indexPath.row]
        
        cell.feedName.text = feed.getName()
        cell.feedAddress.text = feed.getAddress()

        // Configure the cell...

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let feed = feeds[indexPath.row]
            do {
                try FeedDataHelper.delete(feed)
            }
            catch _ {}
            feeds.removeAtIndex(indexPath.row)
            
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        let itemToMove = feeds[fromIndexPath.row]
        feeds.removeAtIndex(fromIndexPath.row)
        feeds.insert(itemToMove, atIndex: toIndexPath.row)

        do {
            print("deleting table")
                try FeedDataHelper.deleteFeedsTable()
        } catch _ {}
        
        for feed in feeds {
            do {
                let id = try FeedDataHelper.insert(Feed(id: 0, name: feed.getName(), address: feed.getAddress())!)
                print("inserting feed: " + feed.getName())
                print (id)

            } catch _ {}
        }
    }
    

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
