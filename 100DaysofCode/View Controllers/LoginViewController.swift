//
//  ViewController.swift
//  100DaysofCode
//
//  Created by Kadeem Palacios on 1/21/19.
//  Copyright © 2019 Kadeem Palacios. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var usernameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        usernameTextField.text = "kadeemp"

    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        NetworkingProvider.validateUsername(usernameTextField.text!) { (status) in
            if status == 200 {

                self.performSegue(withIdentifier: SegueIdentifiers.toLoginConfirmation, sender: nil)

            } else if status == 404 {
                let errorAlertView = UIAlertController(title: "Error", message: "We couldn't find an account with that username", preferredStyle: .actionSheet )
                let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                errorAlertView.addAction(alertAction)
                self.present(errorAlertView, animated: true, completion: nil)
            }
        }
        return true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.toLoginConfirmation {
            let destinationVC = segue.destination as! LoginConfirmationViewController
            destinationVC.username = usernameTextField.text!
        }
    }

}

