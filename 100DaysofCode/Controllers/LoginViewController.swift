//
//  LoginViewController.swift
//  100DaysofCode
//
//  Created by Kadeem Palacios on 4/1/19.
//  Copyright © 2019 Kadeem Palacios. All rights reserved.
//

import UIKit
import Firebase
import WebKit
import Alamofire

class LoginViewController: UIViewController,WKNavigationDelegate  {

    @IBOutlet var emailTextField: CustomTextFieldInput!
    @IBOutlet var passwordTextField: CustomTextFieldInput!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    var githubWebview: WKWebView!
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var githubLoginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func screenTappedAction(_ sender: Any) {
        let textFields = [emailTextField, passwordTextField]

        for field in textFields {
            if (field?.isFirstResponder)! {
                field?.resignFirstResponder()
            }
        }

    }
    func addWebView() {
        self.githubWebview = WKWebView()
        self.githubWebview.navigationDelegate = self
        self.githubWebview.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: self.view.frame.height * 0.7)
        self.githubWebview.center = CGPoint(x: self.view.frame.midX, y: self.view.frame.midY - 40)
        self.githubWebview.layer.opacity = 0
        self.view.addSubview(self.githubWebview)
        let request = URLRequest(url: URLIDs.githubTokenRequest!)
        self.githubWebview.load(request)
        UIView.animate(withDuration: 1.3, delay: 0.5, options: .curveEaseInOut, animations: {
            self.githubWebview.layer.opacity = 1
        })

    }

    @IBAction func loginBtnPressed(_ sender: Any) {
        if emailTextField.text?.isEmpty == false && passwordTextField.text?.isEmpty == false {
            FirebaseController.instance.loginUser(withEmail: emailTextField.text!, andPassword: passwordTextField.text!) { (status, error) in
                switch status {
                case true:
                    self.performSegue(withIdentifier: SegueIdentifiers.loginToMain, sender: self)
                case false:
                    print(false)
                }

                if let error = error {
                    print(error)
                }
            }
        }
    }

    @IBAction func loadGthubWebview(_ sender: Any) {
        addWebView()
    }

    @IBAction func signout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        }
        catch {
            print(error)
        }
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error, #function)
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print(webView.url!, #function)
        if let user = Auth.auth().currentUser {
            performSegue(withIdentifier: SegueIdentifiers.loginToMain, sender: self)


        }
        if webView.url!.host == "codestreak.firebaseapp.com" {

            print(webView.url!.absoluteString.suffix(20))
            submitCredentials(code: String(webView.url!.absoluteString.suffix(20)))
            webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { (cookies) in

                for cookie in cookies {
                    webView.configuration.websiteDataStore.httpCookieStore.delete(cookie, completionHandler: nil)
                    webView.removeFromSuperview()
                }

            }
        }
    }


    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { (cookies) in

            for cookie in cookies {
                webView.configuration.websiteDataStore.httpCookieStore.delete(cookie, completionHandler: nil)
            }
        }
    }
    func clearCache() {
        print("Cache cleared")
        if #available(iOS 9.0, *) {
            let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache])
            let date = NSDate(timeIntervalSince1970: 0)
            WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: date as Date, completionHandler:{ })
        } else {
            var libraryPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, false).first!
            libraryPath += "/Cookies"

            do {
                try FileManager.default.removeItem(atPath: libraryPath)
            } catch {
                print("error")
            }
            URLCache.shared.removeAllCachedResponses()
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
                        print(error , #function)
                        return
                    }
                    FirebaseController.instance.isDuplicateEmail((Auth.auth().currentUser?.email)!, completion: {(isDouble) in
                        if isDouble {
                            self.completeWebRequestAnimation(webV: self.githubWebview)
                            self.performSegue(withIdentifier: SegueIdentifiers.loginToMain, sender: self)
                        } else {
                            print("isDouble = \(isDouble)", #function )

                           self.performSegue(withIdentifier: "LoginToSignup", sender: self)
                        self.completeWebRequestAnimation(webV: self.githubWebview)
                            NetworkingProvider.searchGithubs(Auth.auth().currentUser!.email!, completion: { (username) in
                                //                            self.username = username
                            })
                        }
                    })
                    print("Successfull sign in ")
                    self.clearCache()
                })

            case .failure:
                print(response.error.debugDescription)
            }
        })
    }
    func completeWebRequestAnimation(webV:WKWebView) {

        UIView.animate(withDuration: 1.5, animations: {
            webV.layer.opacity = 0


        }, completion: { (complete) in

            webV.isHidden = true
            webV.removeFromSuperview()

        })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.LoginToSignup {
            let vc = segue.destination as! SignUpViewController
            if let user = Auth.auth().currentUser {

            let name = Auth.auth().currentUser!.displayName
            let names = name?.split(separator: " ")
                vc.email = user.email!
                vc.authenticated = true
                vc.firstName = String(names![0])
                vc.lastName = String(names![1])
                NetworkingProvider.searchGithubs(user.email!, completion: { (username) in
                    vc.username = username
                })
            }
        }
    }
}
