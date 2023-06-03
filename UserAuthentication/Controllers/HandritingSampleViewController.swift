//
//  ViewController.swift
//  UserAuthentication
//
//  Created by Rick DeAmicis on 5/6/23.
//

import UIKit
import PencilKit
import os
import SafariServices
import GoogleSignIn
import GTMSessionFetcher
import GoogleAPIClientForREST


let REPEAT_COUNT = 5

class HandwritingSampleViewController: UIViewController, UITextFieldDelegate, PKCanvasViewDelegate {
    
    @IBOutlet weak var saveHandwritingBtn: UIButton!
    @IBOutlet weak var canvasView: PKCanvasView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var targetToWrite: UILabel!
    @IBOutlet weak var namePrompt: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var changeUsernameBtn: UIButton!
    @IBOutlet weak var researcherSignIn: UIButton!
    
    @IBOutlet weak var bird: UIImageView!
    @IBOutlet weak var cat: UIImageView!
    @IBOutlet weak var fish: UIImageView!
    
    
    var handwritingSamplesController = HandwritingSamplesController()
    var googleSheetsController = GoogleSheetsController()
    
    weak var canvasViewDelegate: PKCanvasViewDelegate?
    
    var targets = [
        "fish",
        "bird",
        "cat",
        "The quick brown fox jumps over the lazy dog",
        "a short sentence",
        "HELLO WORLD",
        "hello world",
        "COMPUTER",
        "computer",
        "SECURITY",
        "security",
        "HANDWRITING",
        "handwriting",
        "PINEAPPLE",
        "pineapple",
        "VEGETARIAN",
        "vegetarian",
        "CARNIVOROUS",
        "carnivorous",
        "0 1 2 3 4 5 6 7 8 9"
    ]
    
    var curTargets: [String] = []
    var curTarget: String = ""
    var repeatCount = REPEAT_COUNT
        
    override func viewDidLoad() {
        super.viewDidLoad()
        canvasView.drawingPolicy = .pencilOnly
        canvasView.delegate = self
        canvasView.isHidden = true
        
        nameTF.delegate = self
        nameTF.clearsOnBeginEditing = true
        username.isHidden = true
        targetToWrite.isHidden = true
        changeUsernameBtn.isHidden = true
        saveHandwritingBtn.isHidden = true
        
        cat.isHidden = true
        bird.isHidden = true
        fish.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let user = GIDSignIn.sharedInstance.currentUser
        if user == nil {
            nameTF.isHidden = true
            displayNeedToSignInAlert()
        } else {
            displaySignInRestoredAlert()
        }
    }
    
    
    @IBAction func signIn(_ sender: UIButton) {
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
            self.nameTF.isHidden = false
        }
    }

    @IBAction func onChangeUsernameBtnClicked(_ sender: Any) {
        resetUsernameInput()
        
    }

    func resetUsernameInput() {
        namePrompt.isHidden = false
        nameTF.isHidden = false
        username.isHidden = true
        targetToWrite.isHidden = true
        canvasView.isHidden = true
        saveHandwritingBtn.isHidden = true
        changeUsernameBtn.isHidden = true
        
    }
    
    // called when a name is added to nameTF textField box
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handwritingSamplesController.username = textField.text!
        username.text = textField.text!
        
        googleSheetsController.createNewTab(title: textField.text!)

        curTargets = targets
        curTarget = textField.text!
        repeatCount = REPEAT_COUNT

        targetToWrite.isHidden = false
        targetToWrite.text = "Please write the following: \n\"" + curTarget + "\""

        username.isHidden = false
        nameTF.isHidden = true
        nameTF.text = ""
        namePrompt.isHidden = true
        canvasView.isHidden = false
        
        cat.isHidden = true
        bird.isHidden = true
        fish.isHidden = true
        
        changeUsernameBtn.isHidden = false
        changeUsernameBtn.setTitle("New Participant", for: .normal)
        
        resetForm()

        textField.resignFirstResponder()
        return true
    }
    
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        if canvasView.drawing.strokes.count > 0 {
            saveHandwritingBtn.isHidden = false
            saveHandwritingBtn.isEnabled = true
        }
    }

    func openQuestionnaire() {
        guard let questionnaireURL = URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSePAflNW0QietC1lczuWj50ZHF4XvWNclxKQE2mGKy1_ARWBw/viewform?usp=sf_link") else { return }
        
        let safariVC = SFSafariViewController(url: questionnaireURL)
        present(safariVC, animated: true, completion: nil)
    }
    
    func resetForm() {
        canvasView.drawing = PKDrawing()
        canvasView.drawingPolicy = .pencilOnly
        saveHandwritingBtn.isHidden = true
        saveHandwritingBtn.isEnabled = false


        if repeatCount == 0 {
            // no more samples to collect
            if curTargets.isEmpty {
                targetToWrite.text = ""
                cat.isHidden = true
                bird.isHidden = true
                fish.isHidden = true
                resetUsernameInput()
                openQuestionnaire()
                
            } else {
                curTarget = curTargets.popLast()!

                if curTarget == "cat" {
                    targetToWrite.text = "Please draw:"
                    cat.isHidden = false
                    bird.isHidden = true
                    fish.isHidden = true
                }
                else if curTarget == "bird" {
                    targetToWrite.text = "Please draw:"
                    cat.isHidden = true
                    bird.isHidden = false
                    fish.isHidden = true
                }
                else if curTarget == "fish" {
                    targetToWrite.text = "Please draw:"
                    cat.isHidden = true
                    bird.isHidden = true
                    fish.isHidden = false
                }
                else {
                    targetToWrite.text = "Please write: \"" + curTarget + "\""
                }
                repeatCount = REPEAT_COUNT
                displaySaveSuccessfulALert()
            }
        } else if repeatCount != REPEAT_COUNT {
            displayRepeatTextAlert(count: repeatCount)
        }
    }
        
    func validateForm() {
        if let name = nameTF.text {
            saveHandwritingBtn.isEnabled = !(canvasView.drawing.strokes.isEmpty || name.isEmpty)
        }
        
    }

    @IBAction func saveHandritingSample(_ sender: Any) {
        
        handwritingSamplesController.saveDrawing(newTarget: curTarget, newDrawing: canvasView.drawing)
        repeatCount -= 1
        resetForm()
    }
}
