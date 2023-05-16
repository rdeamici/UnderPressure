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

let REPEAT_COUNT = 3

class HandwritingSampleViewController: UIViewController, UITextFieldDelegate, PKCanvasViewDelegate {
    
    @IBOutlet weak var saveHandwritingBtn: UIButton!
    @IBOutlet weak var canvasView: PKCanvasView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var targetToWrite: UILabel!
    @IBOutlet weak var namePrompt: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var changeUsernameBtn: UIButton!
    
    var handwritingSamplesController = HandwritingSamplesController()
    weak var canvasViewDelegate: PKCanvasViewDelegate?
    
    var targets = [
        "The quick brown fox jumped over the lazy dog",
        "Hello World",
        "melancholy"
    ]
    
    var curTargets: [String] = []
    var curTarget: String = ""
    var repeatCount = 3
    
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
    }
    
    @IBAction func onChangeUsernameBtnClicked(_ sender: Any) {
        namePrompt.isHidden = false
        nameTF.isHidden = false
        
        username.isHidden = true
        targetToWrite.isHidden = true
        canvasView.isHidden = true
        saveHandwritingBtn.isHidden = true
        
        changeUsernameBtn.isHidden = true
    }

    func resetUsernameInput() {
        nameTF.isHidden = false
        namePrompt.isHidden = false
        username.isHidden = true
        targetToWrite.isHidden = true
        changeUsernameBtn.isHidden = true
        canvasView.isHidden = true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handwritingSamplesController.username = textField.text!
        username.text = "user: " + textField.text!

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
    
        
        changeUsernameBtn.isHidden = false
        changeUsernameBtn.setTitle("Change Name", for: UIControl.State.normal)
        nameTF.resignFirstResponder()
        
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
            if curTargets.isEmpty {
                targetToWrite.text = ""
                handwritingSamplesController.saveDrawingsToLocalDisc()
//                displaySaveSuccessfulALert()
                resetUsernameInput()
//                navigateToQuestionnaire()
                openQuestionnaire()
                
            } else {
                curTarget = curTargets.popLast()!
                targetToWrite.text = "Please write: \"" + curTarget + "\""
                print(targetToWrite.text!)
                repeatCount = REPEAT_COUNT
                displaySaveSuccessfulALert()
            }
        } else if repeatCount != REPEAT_COUNT {
            print("need to repeat text")
            displayRepeatTextAlert()
        }
    }
        
    func validateForm() {
        if let name = nameTF.text {
            saveHandwritingBtn.isEnabled = !(canvasView.drawing.strokes.isEmpty || name.isEmpty)
        }
        
    }
    
    func displayRepeatTextAlert() {
        let alert = UIAlertController(title: "Success!!", message: "Please repeat the previous writing sample.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func displaySaveSuccessfulALert() {
        let alert = UIAlertController(title: "Sample Saved", message: "Your handwriting sample was successfully saved.", preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.green
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
        
    @IBAction func saveHandritingSample(_ sender: Any) {
        handwritingSamplesController.saveDrawing(newTarget: curTarget, newDrawing: canvasView.drawing)
        repeatCount -= 1
        resetForm()
    }
}

