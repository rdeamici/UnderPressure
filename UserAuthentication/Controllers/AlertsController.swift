//
//  AlertsController.swift
//  UserAuthentication
//
//  Created by Rick DeAmicis on 5/17/23.
//

import Foundation
import UIKit
import GoogleSignIn
import GTMSessionFetcher
import GoogleAPIClientForREST


extension UIViewController {

    func displayNeedToSignInAlert() {
        let alert = UIAlertController(title: "Google Sign in", message: "Please sign in Researcher!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(
            title: NSLocalizedString("OK", comment: "Default action"),
            style: .default,
            handler: {(action) in
                self.researcherSignIn()
        }))
        self.present(alert, animated: true, completion: nil)
    }

    func displaySignInRestoredAlert() {
        let alert = UIAlertController(title: "Google Sign in Restored!", message: "", preferredStyle: .alert)
        
        self.present(alert, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func displayRepeatTextAlert(count: Int) {
        var title = "Success! " + String(count) + " more times"
        var delay = 1.0
        var msg = "Please repeat"
        if count != REPEAT_COUNT - 1 {
            title = String(count)
            msg = "Success!"
            delay = 0.5
        }
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        // Present the alert
        present(alert, animated: true, completion: nil)
        
        // Delay the dismissal of the alert
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func displaySaveSuccessfulALert() {
        let alert = UIAlertController(title: "Sample Saved", message: "Your handwriting sample was successfully saved.", preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.green
       
        self.present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func researcherSignIn() {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil else { return }
            
            guard let signInResult = signInResult else { return }
            signInResult.user.refreshTokensIfNeeded { user, error in
                guard error == nil else { return }
                guard let user = user else { return }
                
                let sheetsScope = "https://www.googleapis.com/auth/spreadsheets"
                let grantedScopes = user.grantedScopes
                if grantedScopes == nil || !grantedScopes!.contains(sheetsScope) {
                    let additionalScopes = [sheetsScope]
                    guard let currentUser = GIDSignIn.sharedInstance.currentUser else {
                        return ;  /* Not signed in. */
                    }
                    
                    currentUser.addScopes(additionalScopes, presenting: self) { signInResult, error in
                        guard error == nil else { return }
                        guard let signInResult = signInResult else { return }
                        print("successfully added spreadsheets scope")
                        // Check if the user granted access to the scopes you requested.
                    }
                }
            }
        }
    }
}
