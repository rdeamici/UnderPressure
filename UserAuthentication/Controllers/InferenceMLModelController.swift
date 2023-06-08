//
//  InferenceMLModelController.swift
//  UserAuthentication
//
//  Created by Rick DeAmicis on 6/8/23.
//

import Foundation
import CoreML
import PencilKit

class InferenceMLModelController {
    var model2 = HandwritingClaissifier2()
    
    func averageStrokeForce(stroke: PKStroke) -> CGFloat {
        var totalForce = 0.0
        for point in stroke.path {
            totalForce += point.force
        }
        return totalForce / Double(stroke.path.count)
    }
    
    func averageSampleForce(strokes: [PKStroke]) -> CGFloat {
        var totalForce = 0.0
        var total_strokes = 0
        for stroke in strokes {
            total_strokes += stroke.path.count
            for point in stroke.path {
                totalForce += point.force
            }
        }
        return totalForce / Double(total_strokes)
    }
    
    func speed(pointA: PKStrokePoint, pointB: PKStrokePoint) -> CGFloat {
        let xa = pointA.location.x
        let ya = pointA.location.y
        let timeA = pointA.timeOffset
        
        let xb = pointB.location.x
        let yb = pointB.location.y
        let timeB = pointB.timeOffset
        
        let x_part = pow((xb - xa), 2)
        let y_part = pow((yb - ya), 2)
        let time_part = timeB - timeA
        let speed = sqrt( x_part + y_part) / time_part
        return speed
    }
    
    func averageStrokeSpeed(stroke: PKStroke) -> CGFloat {
        var totalSpeed = 0.0
        var prev_point = stroke.path.first!
        var pointSpeed = 0.0
        for (i, point) in stroke.path.enumerated() {
            if i > 0 {
                pointSpeed = speed(pointA: prev_point, pointB: point)
                prev_point = point
            }
            totalSpeed += pointSpeed
        }
        return totalSpeed / Double(stroke.path.count)
    }
    
    func averageSampleSpeed(strokes: [PKStroke]) -> CGFloat {
        var totalStrokes = strokes.count
        var averageSpeeds = 0.0
        for stroke in strokes {
            averageSpeeds += averageStrokeSpeed(stroke: stroke)
        }
        return averageSpeeds / Double(totalStrokes)
    }
    
    func strokesInSample(strokes: [PKStroke]) -> Int {
        return strokes.count
    }
    
    func calculatePrediction2(predictions: [HandwritingClaissifier2Output]) -> (String, Double) {
        var usersDict: [String: Double] = [:]
        let numPredictions = Double(predictions.count)
        
        for prediction in predictions {
            for (user, probability) in prediction.userProbability {
                if let probSum = usersDict[user] {
                    usersDict[user] =  probSum + probability
                } else {
                    usersDict[user] = probability
                }
            }
        }
        var highestProb = 0.0
        var predictedUser = ""
        for (user, sumProb) in usersDict {
            let avg_prob = sumProb/numPredictions
            if avg_prob > highestProb {
                highestProb = avg_prob
                predictedUser = user
            }
        }
        
        return (predictedUser, highestProb)
    }

    
    func authenticateUser(drawing: PKDrawing, target: String) -> (String, Double) {
        var predictions2: [HandwritingClaissifier2Output] = [];
        
        let av_sample_force = averageSampleForce(strokes: drawing.strokes)
        let av_sample_speed = averageSampleSpeed(strokes: drawing.strokes)
        let strokes_in_sample = strokesInSample(strokes: drawing.strokes)
        let char_count = target.replacingOccurrences(of: " ", with: "").count
        for stroke in drawing.strokes {
            let av_stroke_force = averageStrokeForce(stroke: stroke)
            var prev_point = stroke.path.first!
            var av_stroke_speed = averageStrokeSpeed(stroke: stroke)

            for (i, point) in stroke.path.enumerated() {
                var pointSpeed: CGFloat = 0.0
                if i > 0 {
                    pointSpeed = speed(pointA: prev_point, pointB: point)
                    prev_point = point
                }
                
                guard let userPrediction2 = try? model2.prediction(
                    altitude:point.altitude,
                    azimuth: point.azimuth,
                    force: point.force,
                    av_force_per_stroke: av_stroke_force,
                    av_force_per_sample: av_sample_force,
                    speed: pointSpeed,
                    av_speed_per_stroke: av_stroke_speed,
                    av_speed_per_sample: av_sample_speed,
                    strokes_in_sample: Double(strokes_in_sample),
                    character_count: Double(char_count)
                ) else {
                    fatalError("Unexpected runtime error.")
                }

                predictions2.append(userPrediction2)
            }
        }
        return calculatePrediction2(predictions: predictions2)
    }
    
    
    
}
