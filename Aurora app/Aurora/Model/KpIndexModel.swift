//
//  KpIndexModel.swift
//  Aurora
//
//  Created by Alan S Mathew on 2025-06-04.
//

import Foundation

struct KpIndexModel : Codable {
    let datetime: [Date]
    let kp: [Double]
    let status: [String]
}


struct KpIndexEntry: Identifiable {
    let id = UUID()
    let date: Date
    let kp: Double
}
