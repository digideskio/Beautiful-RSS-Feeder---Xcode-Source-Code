//
//  FeedItemsTableViewController.swift
//  Beautiful RSS Feeder
//
//  Created by Grant on 01/12/2015.
//  Copyright © 2015 GK Micro Ltd. All rights reserved.
//

import UIKit

class FeedItemsTableViewController: UITableViewController, NSXMLParserDelegate {

    var tableData = Dictionary<String, Array<FeedItem>>()
    var sortedSections = [String]()
    
    var feeds = [Feed]()
    
    var currentFeedAddress: String!
    var currentFeedName: String!
    var parser = NSXMLParser()
    var entryTitle: String!
    var entryLink: String!
    var entryDescription: String!
    var entryPubDate: String!
    var currentParsedElement = String()
    var insideAnItem = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let dataStore = SQLiteDataStore.sharedInstance
        do {
            try dataStore.createTables()
        }
        catch _ {}
        self.tableView.sectionIndexColor = UIColor(red: 45/255, green: 31/255, blue: 61/255, alpha: 0.9)
        self.tableView.sectionIndexMinimumDisplayRowCount = 3
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: "getFeedItems:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        do {
            let newFeeds = try FeedDataHelper.findAll()
            if(newFeeds?.count < 1) {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewControllerWithIdentifier("AddFeedViewController") as! AddFeedViewController
                self.showViewController(vc, sender: nil)
                return
            }
            if (newFeeds?.count == feeds.count) {
                return
            }
        } catch _ {
            print ("Error getting feeds")
        }
        
        getFeedItems(self)
    }
    
    func getFeedItems (sender:AnyObject) {
        //first show loading screen
        LoadingOverlay.shared.showOverlay(self.view)
        
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue, {
            do {
                self.feeds = try FeedDataHelper.findAll()!
                self.feeds.sortInPlace({ (f1, f2) -> Bool in
                    f1.getId() < f2.getId()
                })
                
                for feed in self.feeds {
                    self.currentFeedAddress = feed.getAddress()
                    self.currentFeedName = feed.getName()
                    let url: NSURL = NSURL(string: feed.getAddress())!
                    self.parser = NSXMLParser(contentsOfURL: url)!
                    self.parser.delegate = self
                    self.parser.parse()
                }
                for _ in self.tableData {
                    self.sortedSections = Array(self.tableData.keys.sort())
                }
            } catch _ {
                print ("Error getting feed items")
                LoadingOverlay.shared.hideOverlayView()
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
                //close loading screen
                LoadingOverlay.shared.hideOverlayView()
            })
        })
        self.refreshControl?.endRefreshing()
    }

    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == "item" {
            insideAnItem = true
        }
        if insideAnItem {
            switch elementName {
                case "title":
                    entryTitle = String()
                    currentParsedElement = "title"
                case "description":
                    entryDescription = String()
                    currentParsedElement = "description"
                case "link":
                    entryLink = String()
                    currentParsedElement = "link"
                case "pubDate":
                    entryPubDate = String()
                    currentParsedElement = "pubDate"
            default: break
            }
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if insideAnItem {
            switch currentParsedElement {
                case "title":
                entryTitle = entryTitle + string
                case "description":
                entryDescription = entryDescription + string
                case "link":
                entryLink = entryLink + string
                case "pubDate":
                entryPubDate = entryPubDate + string
            default: break
            }
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if insideAnItem {
            switch elementName {
                case "title":
                currentParsedElement = ""
                case "description":
                currentParsedElement = ""
                case "link":
                currentParsedElement = ""
                case "pubDate":
                currentParsedElement = ""
            default: break
            }
            
            if elementName == "item" {
                let feedItem = FeedItem(title: entryTitle, description: entryDescription, link: entryLink, feedName: currentFeedName, feedAddress: currentFeedAddress)
                appendFeedItems(feedItem)
                insideAnItem = false
            }
        }
    }
    
    func appendFeedItems(feedItem: FeedItem) {
        //If there's no section in dictionary for this item, create new one
        if tableData.indexForKey(currentFeedName) == nil {
            tableData[currentFeedName] = [feedItem]
        }
        else {
            tableData[currentFeedName]!.append(feedItem)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableData.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[sortedSections[section]]!.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseIdentifier = "feedItemTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! FeedItemTableViewCell
        
        let tableSection = tableData[sortedSections[indexPath.section]]
        let feedItem = tableSection![indexPath.row]
        
        cell.largeLetter.text = feedItem.getTitle()[feedItem.getTitle().startIndex..<feedItem.getTitle().startIndex.successor()]
        cell.titleLabel.text = feedItem.getTitle()
        
        cell.descLabel.text = feedItem.getDescription()

        // Configure the cell...
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = false;
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //code to fire new view cntroller for web view of rss item
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("FeedItemDetailViewController") as! WebViewController
        let tableSection = tableData[sortedSections[indexPath.section]]
        let feedItem = tableSection![indexPath.row]
        vc.setFeedItem(feedItem)
        //clear selection
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.showViewController(vc, sender: nil)
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sortedSections[section]
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView() // The width will be the same as the cell, and the height should be set in tableView:heightForRowAtIndexPath:
        view.backgroundColor = UIColor(red: 45/255, green: 31/255, blue: 61/255, alpha: 0.9)
        let label = UILabel()
        label.frame = CGRect(x: tableView.bounds.width/2 - 120, y: -8, width: 240, height: 45)
        label.text = sortedSections[section]
        label.textColor = UIColor.whiteColor()
        label.textAlignment = NSTextAlignment.Center
        label.backgroundColor = UIColor.clearColor()
        view.addSubview(label)
        return view
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        //pull out forst letter of feed name
        var sects = [String] ()
        for s in sortedSections {
            sects.append(s[s.startIndex..<s.startIndex.successor()])
        }
        return sects
    }
    
    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return index
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
