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
    
    init() {
        handwritingSampleModel = HandwritingSampleModel()
    }
    
    var drawing: PKDrawing {
        get { handwritingSampleModel.drawing }
        set { handwritingSampleModel.drawing = newValue }
    }
    var targetToDraw: String {
        get { handwritingSampleModel.targetToDraw }
        set { handwritingSampleModel.targetToDraw = newValue }
    }

    var duration: TimeInterval {
        get { handwritingSampleModel.duration }
    }
}


class HandwritingSamplesController {
    /// Dispatch queues for the background operations done by this controller.
    private let serializationQueue = DispatchQueue(label: "SerializationQueue", qos: .background)
    private let handwritingSampleModelController: HandwritingSampleModelController = HandwritingSampleModelController()
    private var handwritingSamples: HandwritingSamples = HandwritingSamples()
    
    func createURL() -> URL {
        let documentName = username+".data"
        let dirURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask)[0]
        let fileURL = URL(fileURLWithPath: username, relativeTo: dirURL).appendingPathExtension("data")

        var saveURL: URL {
            let paths = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask)
            let documentsDirectory = paths.first!
            return documentsDirectory.appendingPathComponent(documentName)
        }

        return fileURL
    }
    
    var username: String {
        get { handwritingSamples.username }
        set { handwritingSamples.username = newValue }
    }
    
    func saveDrawing(newTarget: String, newDrawing: PKDrawing) {
        let handwritingSample = HandwritingSampleModel(targetToDraw: newTarget, drawing: newDrawing)
        handwritingSamples.drawings.append(handwritingSample)
    }
    
    func saveDrawingsToLocalDisc() {
        let url = createURL()
        let savingModel = handwritingSamples

        print("saving handwriting samples to:")
        print(url.absoluteString)
        print(savingModel.username)
        print(savingModel.drawings.count)
        print(savingModel.drawings.first!.drawing.dataRepresentation())
        print(savingModel.drawings.first!.drawing.bounds.size)
        print(savingModel.drawings.first!.drawing.strokes.debugDescription)
        print(savingModel.drawings.first!.drawing.strokes.count)
        print(savingModel.drawings.first!.drawing.strokes.first.debugDescription)
        print(savingModel.drawings.first!.drawing.strokes.first!.path.first.debugDescription)

        do {
            let encoder = PropertyListEncoder()
//            encoder.outputFormat = .openStep
            let data = try encoder.encode(savingModel)
            if let s = String(data: data, encoding: .nextstep) {
                print(s)
            }
            print(data.debugDescription)
            print(data)
            try data.write(to: url)
        } catch {
            os_log("Could not save Handwriting Samples for user %s: %s", type: .error, self.username, error.localizedDescription)
        }
    }

    func saveToCloud() {}
}
