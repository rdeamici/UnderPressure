//
//  SetupViewController.swift
//  UserAuthentication
//
//  Created by Rick DeAmicis on 6/4/23.
//

import UIKit
import GoogleSignIn
import GTMSessionFetcher
import GoogleAPIClientForREST


class SetupViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var requestNamePromptLabel: UILabel!
    @IBOutlet weak var userInputButton: UIButton!
    @IBOutlet weak var nextScreenBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Setup Screen"
        usernameTextField.delegate = self

        userInputButton.isHidden = true
        nextScreenBtn.isHidden = true
        let user = GIDSignIn.sharedInstance.currentUser
        if user == nil {
            displayNeedToSignInAlert()
        } else {
            displaySignInRestoredAlert()
        }
        usernameTextField.text = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        usernameTextField.text = ""
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
           textField.becomeFirstResponder()
       }
    
    // called when a name is added to nameTF textField box
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nextScreenBtn.isHidden = false
        textField.resignFirstResponder()
        
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let handwritingSampleViewController = segue.destination as? HandwritingSampleViewController
        else {
            return
        }
        handwritingSampleViewController.nameFromSetup = usernameTextField.text
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
