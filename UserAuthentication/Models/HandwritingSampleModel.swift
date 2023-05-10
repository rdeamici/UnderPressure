//
//  HandwritingSample.swift
//  UserAuthentication
//
//  Created by Rick DeAmicis on 5/9/23.
//

import Foundation
import PencilKit

struct HandwritingSampleModel: Codable {
    var drawerName = "Rick"
    var targetWord = "Rick"    
    var duration = 1.02
    var drawing = PKDrawing()
}

#if DEBUG
extension HandwritingSampleModel {
    static var sampleData = [
        HandwritingSampleModel(drawerName: "Rick", targetWord: "brown", duration: 1.02),
        HandwritingSampleModel(drawerName: "Elina", targetWord: "brown", duration: 1.02),
        HandwritingSampleModel(drawerName: "Zane", targetWord: "brown", duration: 1.02),
    ]
}
#endif
