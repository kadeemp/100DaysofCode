//
//  PostViewController.swift
//  100DaysofCode
//
//  Created by Kadeem Palacios on 1/25/19.
//  Copyright © 2019 Kadeem Palacios. All rights reserved.
//

import UIKit
import WebKit
import Social
class PostViewController: UIViewController, UITextViewDelegate, WKNavigationDelegate {

    @IBOutlet var shareButton: UIButton!
    @IBOutlet var postTextView: UITextView!
    @IBOutlet var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
//            postTextView.layer.cornerRadius = postTextView.frame.height/8
//        shareButton.layer.cornerRadius = shareButton.frame.height/4

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard1)))
        let twitter = "https://twitter.com/hashtag/100daysofcode?f=tweets&vertical=default&src=hash"
        let url = URL(string: twitter)
        webView.navigationDelegate = self
        self.webView.scrollView.delegate = self
        webView.load(URLRequest(url: url!))
       // webView.loadHTMLString("0", baseURL: url)
        // Do any additional setup after loading the view.
    }
    @objc func dismissKeyboard1() {
        if postTextView.isFirstResponder == true {
            postTextView.resignFirstResponder()
        }
    }
    func presentTweet() {


            let tweetShare = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            if let tweetShare = tweetShare {
                tweetShare.setInitialText("Nice Tutorials of iOSDevCenters")
                self.present(tweetShare, animated: true, completion: nil)
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

    @IBAction func shareBtnPRessed(_ sender: UIButton) {
//        let activityController = UIActivityViewController(activityItems: [postTextView.text], applicationActivities: nil)
//        activityController.popoverPresentationController?.sourceView = sender
//        self.present(activityController, animated: true, completion: nil)
        presentTweet()
    }

}
