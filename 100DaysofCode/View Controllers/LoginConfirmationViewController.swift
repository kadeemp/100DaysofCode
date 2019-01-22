//
//  LoginConfirmationViewController.swift
//  100DaysofCode
//
//  Created by Kadeem Palacios on 1/21/19.
//  Copyright © 2019 Kadeem Palacios. All rights reserved.
//

import UIKit
import AlamofireImage
class LoginConfirmationViewController: UIViewController {

    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var profilePictureImageView: UIImageView!
    var username:String!
    var downloader = ImageDownloader()
    let userDefaults = UserDefaults.standard
     var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        usernameLabel.text = username
    }
        // Do any additional setup after loading the view.

    
    @IBAction func confirmationPressed(_ sender: Any) {
        userDefaults.set(username, forKey: "username")

        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        var mainTabBarController: UITabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBar") as! UITabBarController

        let homeViewController: UIViewController = storyboard.instantiateViewController(withIdentifier: "Home")
        let settingsViewController:UIViewController = storyboard.instantiateViewController(withIdentifier: "Settings")

        mainTabBarController.viewControllers = [homeViewController,settingsViewController]
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = mainTabBarController
        self.window?.makeKeyAndVisible()
    }
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
