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
    @IBOutlet weak var targetToWrite: UILabel!
    @IBOutlet weak var username: UILabel!
    var nameFromSetup: String?
    
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
        title = "Handrwiting Sample Screen"
        
        canvasView.drawingPolicy = .pencilOnly
        canvasView.delegate = self
        
        username.text = nameFromSetup
        saveHandwritingBtn.isHidden = true
        
        cat.isHidden = true
        bird.isHidden = true
        fish.isHidden = true
    
        
        googleSheetsController.createNewTab(title: username.text!)
        handwritingSamplesController.username = username.text!
        curTarget = username.text!
        targetToWrite.text = "Please write: \"" + curTarget + "\""
        repeatCount = REPEAT_COUNT
        curTargets = targets
        
        navigationController?.isNavigationBarHidden = false
    }

    func resetUsernameInput() {
        username.isHidden = true
        targetToWrite.isHidden = true
        canvasView.isHidden = true
        saveHandwritingBtn.isHidden = true
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

    @IBAction func saveHandritingSample(_ sender: Any) {
        
        handwritingSamplesController.saveDrawing(newTarget: curTarget, newDrawing: canvasView.drawing)
        repeatCount -= 1
        resetForm()
    }
}
