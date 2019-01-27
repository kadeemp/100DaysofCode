//
//  PostViewController.swift
//  100DaysofCode
//
//  Created by Kadeem Palacios on 1/25/19.
//  Copyright © 2019 Kadeem Palacios. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var shareButton: UIButton!
    @IBOutlet var postTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
            postTextView.layer.cornerRadius = postTextView.frame.height/8
        shareButton.layer.cornerRadius = shareButton.frame.height/4

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        // Do any additional setup after loading the view.
    }
    @objc func dismissKeyboard() {
        if postTextView.isFirstResponder == true {
            postTextView.resignFirstResponder()
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
        let activityController = UIActivityViewController(activityItems: [postTextView.text], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = sender
        self.present(activityController, animated: true, completion: nil)
    }
}
