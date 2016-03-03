//
//  AddFeedViewController.swift
//  Beautiful RSS Feeder
//
//  Created by Grant on 01/12/2015.
//  Copyright © 2015 GK Micro Ltd. All rights reserved.
//

import UIKit

class AddFeedViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var feeds = [Feed] ()
    var feedImgs = [String] ()
    let reuseId = "PopFeeds"
    
    @IBOutlet weak var nameLabel: UITextField!
    
    @IBOutlet weak var addressLabel: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
        compileFeeds()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButtonClick() {
        let name = nameLabel.text!
        let address = addressLabel.text!
        
        if (name.characters.count < 4) {
            showAlert("Error", alert: "Please enter a name longer than 4 characters")
            return
        }
        
        if(address.characters.count < 6) {
            showAlert("Error", alert: "Please enter an address longer than 6 characters")
            return
        }
        
        do {
            let feed = try FeedDataHelper.insert(Feed(id: 0, name: name, address: address)!)
            print(feed)
            nameLabel.text = ""
            addressLabel.text = ""
            //code to close view controller
            navigationController?.popViewControllerAnimated(true)
        } catch _ {}
        
        
    }
    
    func showAlert (title: String, alert: String) {
        let alertController = UIAlertController(title: title, message: alert, preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "OK", style: .Default) { (action: UIAlertAction!) in
            print ("OK Pressed")
        }
        alertController.addAction(okAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    @IBOutlet weak var collectionView: UICollectionView!
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let feed = feeds[indexPath.row]
        UIView.animateWithDuration(0.5, animations: {
            self.nameLabel.center.x += 100
            self.addressLabel.center.x += 100
        })
        self.nameLabel.text = feed.getName()
        self.addressLabel.text = feed.getAddress()
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return feeds.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PopFeeds", forIndexPath: indexPath) as! AddFeedsCollectionViewCell
        
        // Configure the cell
        cell.label.text = feeds[indexPath.row].getName()
        cell.imgV.image = UIImage(named: "imgs/" + feedImgs[indexPath.row])
        
        return cell
    }
    
    func compileFeeds () {
        let feedNames = [
            "BBC Top Stories",
            "NPR Top",
            "New York Times",
            "Tech Crunch",
            "CNET",
            "Boing Boing",
            "Cooking for Engineers",
            "Science Daily",
            "Wired",
            "Forbes",
            "Yahoo Baseball",
            "Delicious",
            "Postsecret",
            "XKCD",
            "Penny Arcade",
            "Dinosaur Comics",
            "Something Positive",
            "Wil Wheaton",
            "Dilbert",
            "The Onion"
            
        ]
        let feedAddresses = [
            "http://feeds.bbci.co.uk/news/rss.xml",
            "http://www.npr.org/rss/rss.php?id=1001",
            "http://www.nytimes.com/services/xml/rss/nyt/InternationalHome.xml",
            "http://feeds.feedburner.com/TechCrunch/",
            "http://www.cnet.com/rss/news/",
            "http://boingboing.net/rss",
            "http://www.cookingforengineers.com/atom.xml",
            "http://www.sciencedaily.com/newsfeed.xml",
            "http://feeds.wired.com/wired/index",
            "http://www.forbes.com/technology/feed2",
            "https://sports.yahoo.com/mlb/rss.xml",
            "http://feeds.delicious.com/v2/rss/recent",
            "http://postsecret.com/feed/",
            "http://www.xkcd.com/rss.xml",
            "http://penny-arcade.com/feed",
            "http://rsspect.com/rss/qwantz.xml",
            "http://www.somethingpositive.net/sp.xml",
            "http://wilwheaton.net/feed/",
            "http://comicfeeds.chrisbenard.net/view/dilbert/default",
            "http://www.theonion.com/content/feeds/weekly"
        ]
        feedImgs = [
            "bbc.png",
            "npr.png",
            "nyt.png",
            "tc.png",
            "cnet.png",
            "boing.png",
            "cookingengineers.png",
            "sciencedaily.png",
            "wired.png",
            "forbes.png",
            "yahoo.png",
            "delicious.png",
            "postsecret.png",
            "xkcd.png",
            "penny.png",
            "dino.png",
            "positive.png",
            "wil.png",
            "dilbert.png",
            "onion.png"
        ]
        
        var i = 0
        for _ in feedNames {
            feeds.append(Feed(id: 0, name: feedNames[i], address: feedAddresses[i])!)
            i++
        }
    }

}

