//
//  RequestData.swift
//  pulseLL
//
//  Created by Philipp Hugenroth on 29.07.24.
//

import Foundation

struct VitalParameters: Codable {
    let heart_rate: Int
    let unix_timestamp: Int
    let song_genre: String
    let user_id: String
}
