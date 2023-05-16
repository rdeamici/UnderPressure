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
    var duration: TimeInterval = 1.02
    var drawing = PKDrawing()
}
