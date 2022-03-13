//
//  HomeTableTableViewController.swift
//  Twitter
//
//  Created by 藍雅 on 3/12/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class HomeTableTableViewController: UITableViewController {
    var tweetArray = [NSDictionary]()
    var numberOfTweet : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweet()

        
    }
    func loadTweet(){
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myPrams = ["count": 10]
        

        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myPrams, success: {
            (tweets: [NSDictionary]) in
            
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            
            self.tableView.reloadData()
        }, failure: {
            (Error) in
            print("Error in loading tweet")
        })
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "TwittCell", for: indexPath ) as! TweetCell
          let user = self.tweetArray[indexPath.row]["user"] as! NSDictionary
          cell.userNameLabel.text = user["name"] as? String
          cell.tweetContent.text = self.tweetArray[indexPath.row]["text"] as? String
          let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
          let data = try? Data(contentsOf: imageUrl!)
          if let imageData = data{
              cell.profileImageView.image = UIImage(data: imageData)
          }
          return cell
      }
    
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }

    

}