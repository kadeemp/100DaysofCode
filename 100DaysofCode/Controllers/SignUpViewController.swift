//
//  SignUpViewController.swift
//  100DaysofCode
//
//  Created by Kadeem Palacios on 4/1/19.
//  Copyright © 2019 Kadeem Palacios. All rights reserved.
//

import UIKit
import Firebase
import AlamofireImage

class SignUpViewController: UIViewController {

    @IBOutlet var signUpLabel: UILabel!
    @IBOutlet var firstNameTextField: CustomTextFieldInput!
    @IBOutlet var lastNameTextField: CustomTextFieldInput!
    @IBOutlet var emailTextField: CustomTextFieldInput!
    @IBOutlet var passwordTextField: CustomTextFieldInput!

    @IBOutlet var firstNameImageView: UIImageView!
    @IBOutlet var lastNameImageView: UIImageView!
    @IBOutlet var emailImageView: UIImageView!
    @IBOutlet var passwordImageView: UIImageView!

    @IBOutlet var infoSubmissionBtn: UIButton!
    var firstName:String = ""
    var lastName:String = ""
    var email:String = ""
    var username:String = ""

    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    override func viewDidLoad() {
        super.viewDidLoad()

        if ((firstName != "") && (lastName != "") && (email != "")) {
            firstNameTextField.text = firstName
            lastNameTextField.text = lastName
            emailTextField.text = email
        }

        // Do any additional setup after loading the view.
    }

    func diappearSignupView(completion:() -> ()) {
        UIView.animateKeyframes(withDuration: 1.5, delay: 0, options: .calculationModePaced, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.1, animations: {
                self.signUpLabel.layer.opacity = 0
            })
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.1, animations: {
                self.firstNameTextField.layer.opacity = 0
                self.firstNameImageView.layer.opacity = 0
            })
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.2, animations: {
                self.lastNameTextField.layer.opacity = 0
                self.lastNameImageView.layer.opacity = 0
            })
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.2, animations: {
                self.emailTextField.layer.opacity = 0
                self.emailImageView.layer.opacity = 0
            })
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.2, animations: {
                self.passwordTextField.layer.opacity = 0
                self.passwordImageView.layer.opacity = 0
            })
            UIView.addKeyframe(withRelativeStartTime: 0.29, relativeDuration: 0.1, animations: {
                self.infoSubmissionBtn.layer.opacity = 0
            })
        })

    }

    @IBAction func screenTappedAction(_ sender: Any) {
        let textfields = [firstNameTextField,lastNameTextField,emailTextField,passwordTextField]
        for field in textfields {
            if (field?.isFirstResponder)! {
                field?.resignFirstResponder()
            }
        }
    }
    @IBAction func submitBtnPressed(_ sender: Any) {
        DispatchQueue.main.async {
            FirebaseController.instance.registerUser(firstName: self.firstNameTextField.text!, lastName: self.lastNameTextField.text!, username: self.username) { (complete, error) in
                //            FirebaseController.instance.updateStreak(streak: 10)

                if let user = Auth.auth().currentUser {
                    let credential = EmailAuthProvider.credential(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!)
                    user.linkAndRetrieveData(with: credential, completion: { (status, error) in
                        print("result is \(String(describing: status))\n")
                        print("error is \(String(describing: error))\n")
                        self.performSegue(withIdentifier: SegueIdentifiers.SignUpToMain, sender: self)
                    }
                    )
                }
                print(complete)
            }
        }

//        NetworkingProvider.searchGithubs(emailTextField.text!, completion: { username in
//            UserDefaults.standard.set(username, forKey: "username")
//            NetworkingProvider.getProfilePictureFor(username: username, completion: { (url) in
//                if url != "" {
//                    let urlRequest = URLRequest(url: URL(string: url)!)
//
//                    ImageDownloader().download(urlRequest) { response in
//                        switch response.result {
//                        case .success:
//                            if let image = response.result.value {
//
//                               // CoreDataStack.saveProfilePhoto(image)
//
//
//                            }
//                        case .failure(let error):
//                            print(error)
//                        }
//
//                    }
//                }
//            })
//        })
//        self.navigationController?.setViewControllers([Nav.returnMainView()], animated: true)

        // performSegue(withIdentifier: SegueIdentifiers.signupToMain, sender: self)


        let banner = UIView(frame: CGRect(x: 0, y:  -self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height * 0.30))
        banner.layer.backgroundColor = UIColor.blue.cgColor
        banner.layer.cornerRadius = banner.frame.width * 0.1
//        self.view.addSubview(banner)


        //        UIView.animate(withDuration: 1) {
        //            banner.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height * 0.30)
        //        }
        diappearSignupView {

        }

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
