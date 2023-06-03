//
//  HandwritingSampleModelController.swift
//  UserAuthentication
//
//  Created by Rick DeAmicis on 5/10/23.
//

import UIKit
import PencilKit
import GoogleAPIClientForREST
import GoogleSignIn
import GTMSessionFetcher

class HandwritingSamplesController {
    private var handwritingSamples = HandwritingSamples()
    private let googleSheetsController = GoogleSheetsController()
    
    var username: String {
        get { handwritingSamples.username }
        set { // reset data for new user
            handwritingSamples = HandwritingSamples()
            handwritingSamples.username = newValue
        }
    }
        
    func extractDynamicData(drawing: PKDrawing) -> [PKDrawingDynamicDataModel] {
        let sampleStartTime = drawing.strokes.first!.path.creationDate.timeIntervalSince1970
        var strokeStartTime = sampleStartTime
        var strokeTimeOffset = strokeStartTime - sampleStartTime
        
        var dynamicDataPoints: [PKDrawingDynamicDataModel] = []
        
        for (stroke_i, stroke) in drawing.strokes.enumerated() {
            strokeStartTime = stroke.path.creationDate.timeIntervalSince1970
            strokeTimeOffset = strokeStartTime - sampleStartTime

            for point in stroke.path {
                let timeOffset = point.timeOffset + strokeTimeOffset
                
                let newDynamicData = PKDrawingDynamicDataModel(altitude: point.altitude, azimuth: point.azimuth, force: point.force, x: point.location.x, y: point.location.y, timeOffset: timeOffset, strokeNum: stroke_i+1)
                
                dynamicDataPoints.append(newDynamicData)
            }
        }
        return dynamicDataPoints
    }
    
    func createSheetsRows(curSample: HandwritingSampleModel, sampleNum: Int) -> [[Any]] {
        var columns: [[Any]] = []
        
        // add header when writing initial data
        if handwritingSamples.drawings.count == 1 {
            columns.append(["altitude", "azimuth", "force", "x","y","timeOffset", "strokeNum", "SampleNum", "sampleTarget"])
        }
        
        for point in curSample.drawing {
            let line = [point.altitude, point.azimuth, point.force, point.x, point.y, point.timeOffset, point.strokeNum, sampleNum, curSample.targetToDraw] as [Any]
            columns.append(line)
        }
        print("\n\nnumber of rows to write:")
        print(columns.count)
        return columns
    }

        
    func saveDrawing(newTarget: String, newDrawing: PKDrawing) {
        let newDrawingDynamicData = extractDynamicData(drawing: newDrawing)
        
        let handwritingSample = HandwritingSampleModel(
            targetToDraw: newTarget,
            drawing: newDrawingDynamicData)
        
        handwritingSamples.drawings.append(handwritingSample)
        
        let rows = createSheetsRows(curSample: handwritingSample, sampleNum: handwritingSamples.drawings.count)
        
        googleSheetsController.writeToGoogleSheets(data: rows, range: username)
    }
}
