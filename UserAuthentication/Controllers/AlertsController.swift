//
//  AlertsController.swift
//  UserAuthentication
//
//  Created by Rick DeAmicis on 5/17/23.
//

import Foundation
import UIKit

extension UIViewController {

    func displayNeedToSignInAlert() {
        let alert = UIAlertController(title: "Google Sign in", message: "Please sign in Researcher!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
        self.present(alert, animated: true, completion: nil)
    }

    func displaySignInRestoredAlert() {
        let alert = UIAlertController(title: "Google Sign inRestored", message: "Previous Sign In Restored!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    func displayRepeatTextAlert(count: Int) {
        let alert = UIAlertController(title: "Success! " + String(count) + " more times", message: "Please repeat", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    func displaySaveSuccessfulALert() {
        let alert = UIAlertController(title: "Sample Saved", message: "Your handwriting sample was successfully saved.", preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.green
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
}
