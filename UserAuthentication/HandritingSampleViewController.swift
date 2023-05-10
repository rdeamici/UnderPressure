//
//  ViewController.swift
//  UserAuthentication
//
//  Created by Rick DeAmicis on 5/6/23.
//

import UIKit
import PencilKit
import os

class HandwritingSampleViewController: UIViewController {
    @IBOutlet var canvasView: PKCanvasView!
    @IBOutlet var saveButton: UIButton!
    var handwritingSampleModel = HandwritingSampleModel()
    
    private var saveURL: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths.first!
        return documentsDirectory.appending(path: "UserAuthentication.data")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        canvasView = PKCanvasView(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
        canvasView.backgroundColor = UIColor.gray
        canvasView.drawingPolicy = .anyInput
        view.addSubview(canvasView)
//        canvasView.drawingPolicy = .pencilOnly

        saveButton = UIButton(type: .system)
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveDrawing), for: .touchUpInside)
        view.addSubview(saveButton)
        
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            canvasView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            canvasView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            canvasView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            canvasView.heightAnchor.constraint(equalToConstant: 200),
            saveButton.topAnchor.constraint(equalTo: canvasView.bottomAnchor, constant: 20),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
    }
        
    @objc func saveDrawing() {
        var savingModel = handwritingSampleModel
        savingModel.drawing = canvasView.drawing

        let url = saveURL
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(savingModel)
            try data.write(to: url)
            self.clearHandwriting()
        } catch {
            os_log("Could not save HandwritingSampleModel: %s",
                    type: .error,
                    error.localizedDescription)
        }
        
    }
    
    func clearHandwriting() {
        canvasView.drawing = PKDrawing()
    }
}

