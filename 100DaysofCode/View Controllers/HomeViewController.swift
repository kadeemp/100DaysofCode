//
//  HomeViewController.swift
//  100DaysofCode
//
//  Created by Kadeem Palacios on 1/21/19.
//  Copyright © 2019 Kadeem Palacios. All rights reserved.
//

import UIKit
import AlamofireImage

class HomeViewController: UIViewController {

    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var counterLabel: UILabel!
    @IBOutlet var profilePictureImageView: UIImageView!
    var profilePictureURL:URLRequest!
    var userDefaults = UserDefaults.standard
    var username:String!
    var downloader = ImageDownloader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username = userDefaults.string(forKey: "username")
        print(username)
        usernameLabel.text = username!
        if username != nil {
        NetworkingProvider.getProfilePictureFor(username: username, completion: { url in
            if url != "" {
                let urlRequest = URLRequest(url: URL(string: url)!)


                self.downloader.download(urlRequest) { response in
                    if let image = response.result.value {
                        print(image)
                        self.profilePictureImageView.image = image
                    }
                }
            }
        })
            NetworkingProvider.getCurrentStreakFor(username: username) { (streakCount) in
                self.counterLabel.text = String(streakCount)
            }
        }

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
