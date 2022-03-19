//
//  ProfileViewController.swift
//  Twitter
//
//  Created by 01659826174 01659826174 on 3/18/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit
import AlamofireImage

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        loadProfile()
    }
    

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var numTweetsLabel: UILabel!
    @IBOutlet weak var numFollowingsLabel: UILabel!
    @IBOutlet weak var numFollowersLabel: UILabel!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func loadProfile() {
        print("...loading profile!")
        let myUrl = "https://api.twitter.com/1.1/account/verify_credentials.json"
        let params: [String: Any] = [:]
        TwitterAPICaller.client?.getDictionaryRequest(url: myUrl, parameters: params, success: { (user: NSDictionary) in
            self.configure(user)
        }, failure: { (error) in
            print("Error when loading profile \(error)")
        })
    }
    
    func configure(_ user: NSDictionary) {
       
        let tag = user["screen_name"] as! String
        let numTweets = user["statuses_count"] as! Int
        let numFollowers = user["followers_count"] as! Int
        let numFollowings = user["friends_count"] as! Int
        let imageUrl = URL(string: ((user["profile_image_url_https"]) as? String)!)
        
        userNameLabel.text = user["name"] as! String
        taglineLabel.text = "@\(tag)"
        numTweetsLabel.text = "\(numTweets) Tweets"
        numFollowersLabel.text = "\(numFollowers) Followers"
        numFollowingsLabel.text = "\(numFollowings) Followings"
        profileImageView.af_setImage(withURL: imageUrl!)
                                    
    }

}
