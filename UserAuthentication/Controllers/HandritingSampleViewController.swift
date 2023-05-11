//
//  ViewController.swift
//  UserAuthentication
//
//  Created by Rick DeAmicis on 5/6/23.
//

import UIKit
import PencilKit
import os

class HandwritingSampleViewController: UIViewController, UITextFieldDelegate, PKCanvasViewDelegate {
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var canvasView: PKCanvasView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var targetToWrite: UILabel!
    
    var handwritingSampleModelController = HandwritingSampleModelController()
    weak var canvasViewDelegate: PKCanvasViewDelegate?
    
    var firstTarget = true
    var targets = [
        "melancholy",
        "Hello World",
        "The quick brown fox jumped over the lazy dog"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        canvasView.drawingPolicy = .anyInput
        canvasView.delegate = self
        resetForm()
    }
    
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        validateForm()
    }

    func navigateToQuestionnaire() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let questionnaireViewController = storyboard.instantiateViewController(withIdentifier: "questionnaireController") as! QuestionnaireViewController
        
        questionnaireViewController.loadViewIfNeeded()
        questionnaireViewController.setup(username: self.nameTF.text!)
        self.present(questionnaireViewController, animated: true, completion: nil)
    }
    
    func resetForm() {
        canvasView.drawing = PKDrawing()
        saveBtn.isEnabled = false
        if targets.isEmpty {
            navigateToQuestionnaire()
        }
    }
    
    func validateForm() {
        if let name = nameTF.text {
            saveBtn.isEnabled = !(canvasView.drawing.strokes.isEmpty || name.isEmpty)
        }
        
    }
    
    func displaySaveSuccessfulALert() {
        let alert = UIAlertController(title: "Sample Saved", message: "Your handwriting sample was successfully saved.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func nameChanged(_ sender: UITextField) {
        if firstTarget {
            targetToWrite.text = nameTF.text
        }
        validateForm()
    }
        
    @IBAction func saveHandritingSample(_ sender: Any) {
        handwritingSampleModelController.drawing = canvasView.drawing
        handwritingSampleModelController.name = nameTF.text!
        handwritingSampleModelController.saveDrawing()
        if firstTarget {
            firstTarget = false
        }
        targetToWrite.text = targets.popLast()
        
        resetForm()
        displaySaveSuccessfulALert()
    }
}

