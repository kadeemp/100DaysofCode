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

    @IBOutlet var counterActivtyIndicator: UIActivityIndicatorView!
    @IBOutlet var imageViewActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var counterLabel: UILabel!
    @IBOutlet var profilePictureImageView: UIImageView!
    var profilePictureURL:URLRequest!
    var userDefaults = UserDefaults.standard
    var username:String!
    var downloader = ImageDownloader()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        counterActivtyIndicator.startAnimating()
        imageViewActivityIndicator.startAnimating()

        profilePictureImageView.layer.cornerRadius = 50
        profilePictureImageView.clipsToBounds = true
        profilePictureImageView.layer.borderWidth = 3
        profilePictureImageView.layer.borderColor = UIColor(red: 31/255, green: 67/255, blue: 140/255, alpha: 1).cgColor


        
        if let username = userDefaults.string(forKey: "username") {
        NetworkingProvider.getProfilePictureFor(username: username, completion: { url in
            if url != "" {
                let urlRequest = URLRequest(url: URL(string: url)!)


                self.downloader.download(urlRequest) { response in
                    if let image = response.result.value {
                        print(image)
                        self.profilePictureImageView.image = image
                        self.imageViewActivityIndicator.stopAnimating()
                        self.imageViewActivityIndicator.isHidden = true
                    }
                }
            }
        })
            NetworkingProvider.getCurrentStreakFor(username: username) { (streakCount) in

                self.counterLabel.text = String(streakCount)
                self.counterActivtyIndicator.stopAnimating()
                self.counterActivtyIndicator.isHidden = true
            }

            usernameLabel.text = username
        }


        // Do any additional setup after loading the view.
    }

}
