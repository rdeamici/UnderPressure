//
//  InferenceViewController.swift
//  UserAuthentication
//
//  Created by Rick DeAmicis on 6/3/23.
//

import UIKit
import PencilKit

class InferenceViewController: UIViewController, PKCanvasViewDelegate {

    @IBOutlet weak var targetToWriteLabel: UILabel!
    @IBOutlet weak var canvasView: PKCanvasView!
    @IBOutlet weak var inferredUsernameLabel: UILabel!
    @IBOutlet weak var probabilityLabel: UILabel!
    @IBOutlet weak var authenticateBtn: UIButton!
    @IBOutlet weak var catImage: UIImageView!
    
    
    private let authenticatedModelController = InferenceMLModelController()
    
    private let random_words = [
        "Vociferous",
        "Authenticate",
        "Irvine",
        "California",
        "boot",
        "skip",
        "authenticate me",
        "cat"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Inference Screen"
        navigationController?.navigationBar.tintColor = .white // Back button color
        
        catImage.isHidden = true
        canvasView.drawingPolicy = .pencilOnly
        canvasView.delegate = self
        inferredUsernameLabel.text = ""
        probabilityLabel.text = ""
        
        generateRandomWord()
    }
    
    func generateRandomWord() {
        let randomWord = random_words.randomElement()
        if randomWord == "cat" {
            targetToWriteLabel.text = ""
            catImage.isHidden = false
        } else {
            targetToWriteLabel.text = randomWord
            catImage.isHidden = true
        }
    }
    
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        if canvasView.drawing.strokes.count > 0 {
            probabilityLabel.text = ""
            inferredUsernameLabel.text = ""
        }
    }
    @IBAction func authenticateUser(_ sender: Any) {
        let (user, probability) = authenticatedModelController.authenticateUser(drawing: canvasView.drawing, target: targetToWriteLabel.text!)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.allowsFloats = false
        
        inferredUsernameLabel.text = user
        probabilityLabel.text = formatter.string(from: probability as NSNumber)
        canvasView.drawing = PKDrawing()
        generateRandomWord()
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
