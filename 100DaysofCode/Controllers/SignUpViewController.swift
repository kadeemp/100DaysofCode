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
import Alamofire
import WebKit

class SignUpViewController: UIViewController,WKNavigationDelegate  {

    @IBOutlet var signUpLabel: UILabel!
    @IBOutlet var firstNameTextField: CustomTextFieldInput!
    @IBOutlet var lastNameTextField: CustomTextFieldInput!
    @IBOutlet var emailTextField: CustomTextFieldInput!
    @IBOutlet var passwordTextField: CustomTextFieldInput!
    @IBOutlet var githubvalidateButton: UIButton!

    @IBOutlet var firstNameImageView: UIImageView!
    @IBOutlet var lastNameImageView: UIImageView!
    @IBOutlet var emailImageView: UIImageView!
    @IBOutlet var passwordImageView: UIImageView!

    @IBOutlet var infoSubmissionBtn: UIButton!
    var blurView:UIVisualEffectView!
    var signInWebView:WKWebView!
    var authenticated = false
    var firstName:String = ""
    var lastName:String = ""
    var email:String = ""
    var username:String = ""

    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    override func viewDidLoad() {
        super.viewDidLoad()
        if authenticated {

        } else {
            invalidatedViewAnimation()
        }
        if ((firstName != "") && (lastName != "") && (email != "")) {
            firstNameTextField.text = firstName
            lastNameTextField.text = lastName
            emailTextField.text = email
        }
        // Do any additional setup after loading the view.
    }

    //MARK:- IB Actions
    @IBAction func validateGithubButtonPressed(_ sender: Any) {

        self.signInWebView = WKWebView()
        self.signInWebView.navigationDelegate = self
        self.signInWebView.frame = CGRect(x: 0, y: self.view.frame.maxY, width: self.view.frame.width - 40, height: self.view.frame.height * 0.7)
        self.view.addSubview(self.signInWebView)

        UIView.animate(withDuration: 0.8) {

        }
        UIView.animate(withDuration: 0.8, animations: {
            self.signUpLabel.layer.opacity = 0
            self.signInWebView.center = CGPoint(x: self.view.frame.midX , y: self.view.frame.midY )

        }) { (didComplete) in
            if didComplete {
                
                let request = URLRequest(url: URLIDs.githubTokenRequest!)
                self.signInWebView.load(request)
            }
        }
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
        diappearSignupViewAnimation {

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
    //MARK:- Animations
    func invalidatedViewAnimation() {
        let blurEffect = UIBlurEffect(style: .dark)
        blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        blurView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.addSubview(blurView)
        view.bringSubviewToFront(githubvalidateButton)
        view.bringSubviewToFront(signUpLabel)
        firstNameTextField.isEnabled = false

        lastNameTextField.isEnabled = false

        emailTextField.isEnabled = false

        passwordTextField.isEnabled = false

    }

    func diappearSignupViewAnimation(completion:() -> ()) {
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

    func completeWebRequestAnimation(webV:WKWebView) {

        UIView.animate(withDuration: 1.2) {
            self.firstNameTextField.isEnabled = true
            self.lastNameTextField.isEnabled = true
            self.emailTextField.isEnabled = true
            self.passwordTextField.isEnabled = true
            self.signUpLabel.layer.opacity = 1
        }

        UIView.animate(withDuration: 1.5, animations: {
            webV.layer.opacity = 0
            self.blurView.effect = .none


            self.githubvalidateButton.isHidden = true

        }, completion: { (complete) in
            self.blurView.isHidden = true
             webV.isHidden = true
            self.view.willRemoveSubview(webV)
            self.view.willRemoveSubview(self.blurView)
        })

        
    }
    //MARK:- Webview methods
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error, #function)
    }
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print(webView.url!, #function)
        if let user = Auth.auth().currentUser {
            performSegue(withIdentifier: SegueIdentifiers.WebviewToMain, sender: self)


        }
        if webView.url!.host == "codestreak.firebaseapp.com" {
            print(webView.url!.absoluteString.suffix(20))
            submitCredentials(code: String(webView.url!.absoluteString.suffix(20)))
            webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { (cookies) in

                for cookie in cookies {
                    webView.configuration.websiteDataStore.httpCookieStore.delete(cookie, completionHandler: nil)
                }
            }
        }
    }
    func submitCredentials(code:String) {
        let url = URL(string:"https://github.com/login/oauth/access_token")
        let parameters = ["client_id":APIConstants.client_id, "client_secret": APIConstants.client_secret, "code":code]
        Alamofire.request(url!, method: .post, parameters: parameters, headers: nil).responseString(completionHandler:{ (response) in
            switch response.result {
            case .success:
                print("\n")
                print(response.result.value)
                var token = String((response.result.value?.prefix(53))!)
                token = String(token.suffix(40))
                print(token)
                let credential = GitHubAuthProvider.credential(withToken: token)
                Auth.auth().signInAndRetrieveData(with: credential, completion: { (result, error) in
                    if let error = error {
                        print(error)
                        return
                    }

                    if FirebaseController.instance.isDuplicateEmail((Auth.auth().currentUser?.email)!) {
                        self.emailTextField.text = Auth.auth().currentUser!.email!
                        let name = Auth.auth().currentUser!.displayName
                        let names = name?.split(separator: " ")
                        self.firstNameTextField.text = String(names![0])
                        self.lastNameTextField.text = String(names![1])
                        self.completeWebRequestAnimation(webV: self.signInWebView)
                        NetworkingProvider.searchGithubs(self.email, completion: { (username) in
                            self.username = username
                        })
                    } else {
                        self.completeWebRequestAnimation(webV: self.signInWebView)
                        self.performSegue(withIdentifier: SegueIdentifiers.SignUpToMain, sender: self)

                    }
                    print("Successfull sign in ")


                })

            case .failure:
                print(response.error.debugDescription)
            }


        })
    }

}
