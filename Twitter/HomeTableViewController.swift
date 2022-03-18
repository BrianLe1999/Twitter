//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by 01659826174 01659826174 on 3/11/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit
import AlamofireImage

class HomeTableViewController: UITableViewController {
    

    var tweetArray = [NSDictionary]()
    var numberOfTweet: Int!
    let myRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        numberOfTweet = 20
        loadTweets()
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadTweets()
    }

    @objc func loadTweets() {
        
        print("load tweets")
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": numberOfTweet]
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets: [NSDictionary]) in
            
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
        }, failure: { (Error) in
            print("could not retrieve tweets")
        })
    }
    
    func loadMoreTweets(){
        numberOfTweet = numberOfTweet + 20
        loadTweets()
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArray.count {
            loadMoreTweets()
        }
    }

    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
        
        let tweet = self.tweetArray[indexPath.row]
        let user = tweet["user"] as! NSDictionary
        cell.userNameLabel.text = user["name"] as? String
        cell.tweetContent.text = tweet["text"] as? String
        
        let imageUrl = URL(string: ((user["profile_image_url_https"]) as? String)!)
        cell.profileImageView.af_setImage(withURL: imageUrl!)
        cell.setFavorite(tweet["favorited"] as! Bool)
        cell.tweetId = tweet["id"] as! Int
        cell.setRetweeted(tweet["retweeted"] as! Bool)
        return cell
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.tweetArray.count
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
