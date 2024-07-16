//
//  Recap.swift
//  pulseLL
//
//  Created by Philipp Hugenroth on 12.07.24.
//

import Foundation
import SwiftUI

struct Recap: Hashable, Codable, Identifiable {
    var id: Int
    var title: String
    var genre: String
    var time: String
    var bpm: Int
    
    // private var imageName: String
    // var image: Image {
    //     Image(imageName)
    // }
}
