//
//  HandwritingSampleModelController.swift
//  UserAuthentication
//
//  Created by Rick DeAmicis on 5/10/23.
//

import Foundation
import UIKit
import PencilKit
import os

class HandwritingSampleModelController {
    var handwritingSampleModel: HandwritingSampleModel
    /// Dispatch queues for the background operations done by this controller.
    private let serializationQueue = DispatchQueue(label: "SerializationQueue", qos: .background)
    
    func createURL() -> URL {
        let documentName = name+"_" + targetToDraw + ".data"
        var saveURL: URL {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentsDirectory = paths.first!
            return documentsDirectory.appending(path: documentName)
        }
        return saveURL
    }
    
    init() {
        handwritingSampleModel = HandwritingSampleModel()
    }
    
    var drawing: PKDrawing {
        get { handwritingSampleModel.drawing }
        set { handwritingSampleModel.drawing = newValue }
    }
    
    var name: String {
        get { handwritingSampleModel.drawerName }
        set { handwritingSampleModel.drawerName = newValue }
    }
    
    var targetToDraw: String {
        get { handwritingSampleModel.targetToDraw }
        set { handwritingSampleModel.targetToDraw = newValue }
    }
    
    func saveDrawing() {
        let savingModel = handwritingSampleModel
        let url = createURL()
        saveToLocalDisc(savingModel: savingModel, url: url)
        
    }
    
    func saveToLocalDisc(savingModel: HandwritingSampleModel, url: URL) {
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(savingModel)
            try data.write(to: url)
        } catch {
            os_log("Could not save Handwriting Sample done by %s of target %s: %s", type: .error, self.name, self.targetToDraw, error.localizedDescription)
        }
    }

    func saveToCloud() {}
}
