//
//  LoginViewController.swift
//  100DaysofCode
//
//  Created by Kadeem Palacios on 4/1/19.
//  Copyright © 2019 Kadeem Palacios. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var emailTextField: CustomTextFieldInput!
    @IBOutlet var passwordTextField: CustomTextFieldInput!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!

    @IBOutlet var loginBtn: UIButton!

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
    @IBAction func loginBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: SegueIdentifiers.loginToMain, sender: self)
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
