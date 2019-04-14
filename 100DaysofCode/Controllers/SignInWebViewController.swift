////
////  SignInWebViewController.swift
////  100DaysofCode
////
////  Created by Kadeem Palacios on 4/5/19.
////  Copyright © 2019 Kadeem Palacios. All rights reserved.
////
//
//import UIKit
//import WebKit
//import Alamofire
//import Firebase
//
//class SignInWebViewController: UIViewController, WKNavigationDelegate {
//
//    @IBOutlet var loginWebView: WKWebView!
//    var firstName:String!
//    var lastName:String!
//    var email:String!
//    var username:String!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        loginWebView.navigationDelegate = self
//        loginWebView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
//        loginWebView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
//
//
//        let url = URL(string: "https://github.com/login/oauth/authorize?client_id=\(APIConstants.client_id)")
//        let request = URLRequest(url: url!)
//        loginWebView.load(request)
//
//        // Do any additional setup after loading the view.
//    }
//
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
////        if keyPath == "title" {
////            if let title = loginWebView.title {
////                print(title)
////            }
////        }
////        else if keyPath == "estimatedProgress" {
////            print(Float(loginWebView.estimatedProgress))
////        }
//    }
//
//
//
//    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//        print(error, #function)
//    }
//    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
//        print(webView.url!, #function)
//        if let user = Auth.auth().currentUser {
//            performSegue(withIdentifier: SegueIdentifiers.WebviewToMain, sender: self)
//
//
//        }
//        if webView.url!.host == "codestreak.firebaseapp.com" {
//            print(webView.url!.absoluteString.suffix(20))
//            submitCredentials(code: String(webView.url!.absoluteString.suffix(20)))
//            webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { (cookies) in
//
//                for cookie in cookies {
//                    webView.configuration.websiteDataStore.httpCookieStore.delete(cookie, completionHandler: nil)
//                }
//            }
//        }
//    }
//
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == SegueIdentifiers.toSIGNUP {
//            let vc = segue.destination as! SignUpViewController
//            vc.email = self.email
//            vc.firstName = self.firstName
//            vc.lastName = self.lastName
//            vc.username = self.username
//            
//        }
//    }
//}
//
//extension SignInWebViewController {
//
//    func submitCredentials(code:String) {
//        let url = URL(string:"https://github.com/login/oauth/access_token")
//        let parameters = ["client_id":APIConstants.client_id, "client_secret": APIConstants.client_secret, "code":code]
//        Alamofire.request(url!, method: .post, parameters: parameters, headers: nil).responseString(completionHandler:{ (response) in
//            switch response.result {
//            case .success:
//                print("\n")
//                print(response.result.value)
//                var token = String((response.result.value?.prefix(53))!)
//                token = String(token.suffix(40))
//                print(token)
//                let credential = GitHubAuthProvider.credential(withToken: token)
//                Auth.auth().signInAndRetrieveData(with: credential, completion: { (result, error) in
//                    if let error = error {
//                        print(error)
//                        return
//                    }
//
//                   !FirebaseController.instance.isDuplicateEmail((Auth.auth().currentUser?.email)!, completion: { (isDouble) in
//
//                    if isDouble {
//
//                    } else {
//
//                    }
//                    })
//
//                    if 1 == 1{
//                        self.email = Auth.auth().currentUser!.email
//                        let name = Auth.auth().currentUser!.displayName
//                        let names = name?.split(separator: " ")
//                        self.firstName = String(names![0])
//                        self.lastName = String(names![1])
//                        NetworkingProvider.searchGithubs(self.email, completion: { (username) in
//                            self.username = username
//                            self.performSegue(withIdentifier: SegueIdentifiers.toSIGNUP, sender: self)
//
//                        })
//                    } else {
//                        self.performSegue(withIdentifier: SegueIdentifiers.WebviewToMain, sender: self)
//                    }
//                    print("Successfull sign in ")
//                    print(Auth.auth().currentUser!.email)
//                    print(Auth.auth().currentUser!.displayName)
//
//                    print(Auth.auth().currentUser!.photoURL)
//                    print(Auth.auth().currentUser)
//
//                })
//              //  self.navigationController?.popViewController(animated: true)
//
//            case .failure:
//                print(response.error.debugDescription)
//            }
//
//
//        })
//    }
//    
//}
