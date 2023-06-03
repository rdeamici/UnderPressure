//
//  HandwritingSample.swift
//  UserAuthentication
//
//  Created by Rick DeAmicis on 5/9/23.
//

import Foundation
import PencilKit

struct HandwritingSamples: Codable {
    var username: String = ""
    var drawings: [HandwritingSampleModel] = []
}

struct HandwritingSampleModel: Codable {
    var targetToDraw: String = ""
    var drawing: [PKDrawingDynamicDataModel] = []
}

struct PKDrawingDynamicDataModel: Codable {
    var altitude: CGFloat
    var azimuth: CGFloat
    var force: CGFloat
    var x: CGFloat
    var y: CGFloat
    var timeOffset: Double
    var strokeNum: Int
    
}
