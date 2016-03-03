//
//  WebViewController.swift
//  Beautiful RSS Feeder
//
//  Created by Grant on 01/12/2015.
//  Copyright © 2015 GK Micro Ltd. All rights reserved.
//

import UIKit
import GoogleMobileAds

class WebViewController: UIViewController {
    
    var feedItem = FeedItem(title: "", description: "", link: "", feedName: "", feedAddress: "")
    
    func setFeedItem (feedItem: FeedItem) {
        self.feedItem = feedItem
    }
    
    //main web view
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .Plain, target: self, action: "share")

        UIWebView.loadRequest(webView) (NSURLRequest(URL: NSURL(string: feedItem.getLink())!))
        loadAd()
    }
    
    func share () {
            let objectsToShare = [feedItem.getTitle(), feedItem.getLink()]
            let activityVC = UIActivityViewController(activityItems: objectsToShare,applicationActivities: nil)
                
            self.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    func loadAd () {
        bannerView.adUnitID = "ca-app-pub-3173186601544743/3044445144"
        bannerView.rootViewController = self
        let req = GADRequest()
        req.testDevices = [""]
        bannerView.loadRequest(req)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
