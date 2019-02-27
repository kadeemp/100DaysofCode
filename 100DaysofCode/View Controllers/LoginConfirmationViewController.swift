//
//  LoginConfirmationViewController.swift
//  100DaysofCode
//
//  Created by Kadeem Palacios on 1/21/19.
//  Copyright © 2019 Kadeem Palacios. All rights reserved.
//

import UIKit
import AlamofireImage
import CoreData
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
        let context = CoreDataStack.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "User", in: context) else {print(#function, #line,"ISSUE HERE"); return}

        let user = NSManagedObject(entity: entity, insertInto: context)
        user.setValue(username, forKey: "username")
        user.setValue(profilePictureImageView.image?.jpegData(compressionQuality: 1), forKey: "profilePhoto")

        do {
            try context.save()
        }
        catch {
            print("COULD NOT SAVE")
        }



        performSegue(withIdentifier: "toMain", sender: self)
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
