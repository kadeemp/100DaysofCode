//
//  SignUpViewController.swift
//  100DaysofCode
//
//  Created by Kadeem Palacios on 4/1/19.
//  Copyright © 2019 Kadeem Palacios. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet var firstNameTextField: CustomTextFieldInput!
    @IBOutlet var lastNameTextField: CustomTextFieldInput!
    @IBOutlet var emailTextField: CustomTextFieldInput!
    @IBOutlet var passwordTextField: CustomTextFieldInput!




    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func screenTappedAction(_ sender: Any) {
        let textfields = [firstNameTextField,lastNameTextField,emailTextField,passwordTextField]
        for field in textfields {
            if (field?.isFirstResponder)! {
                field?.resignFirstResponder()
            }
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
